//
//  ChatWebSocketManager.swift
//  ChatViewApp
//
//  Created by name on 17/05/2025.
//

//I think it is better to make it as components

// Connectionas
// make a connection
// cancel

// sendable actions

// log in with new id
// send message to the group
// send poivate message
// send Typing Status

// make the final shape of the potocol so we do not edit it each time

// try to replce the call backs and use the sream instead
// try to avoid the temporal coubling in this code


//i will make the view model handle the response for me
// i will make the manager send the stream for me

import Foundation

class ChatWebSocketManager {
    private var webSocketTask: URLSessionWebSocketTask?
    private var socketStream: SocketStream?
    
    // Callback handlers
    var onReceiveMessage: ((ChatMessage) -> Void)?
    var onConnectionChange: ((Bool) -> Void)?
    var onUserListUpdate: (([String]) -> Void)?
    var onError: ((String) -> Void)?
}

extension ChatWebSocketManager {
    
    func connect() {
        // Get the URL
        guard let url = URL(string: "ws://localhost:8765") else {
            onError?("Invalid URL")
            return
        }
        
        webSocketTask = URLSession.shared.webSocketTask(with: url)
        socketStream = SocketStream(task: webSocketTask!)
        
        setReceiveHandler()
        onConnectionChange?(true)
    }
    
    func disconnect() {
        Task { try? await socketStream?.cancel() }
        onConnectionChange?(false)
    }
}

//MARK: - Receive the Messages
extension ChatWebSocketManager {
    
    private func setReceiveHandler() {
        Task {
            do {
                for try await message in socketStream! {
                    switch message {
                    case .string(let string):
                        print("❌", string)
                        handleMessage(string)
                        
                        //TODO: - make it handle different types of messages
                    case .data(let data):
                        print("❌❌", data)
                        if let text = String(data: data, encoding: .utf8) {
                            self.handleMessage(text)
                        }
                        
                    @unknown default:
                        print("Unknown message type")
                        break
                    }
                }
            } catch {
                onConnectionChange?(false)
                self.onError?("Receive error: \(error.localizedDescription)")
            }
        }
    }
    
    // get the json response and convert it into message
    private func handleMessage(_ messageText: String) {
        guard let data = messageText.data(using: .utf8),
              let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let messageType = jsonObject["type"] as? String else {
            onError?("Invalid message format")
            return
        }
        
        print("❌❌❌", messageType)
        
        switch messageType {
        case "message":
            let from = jsonObject["from"] as? String ?? "Unknown"
            let content = jsonObject["content"] as? String ?? ""
            let to = jsonObject["to"] as? String
            let isPrivate = to != nil
            
            let message = ChatMessage(from: from, content: content, isPrivate: isPrivate, to: to)
            onReceiveMessage?(message)
            
        case "system":
            let content = jsonObject["message"] as? String ?? ""
            let message = ChatMessage(from: "System", content: content, isPrivate: false)
            onReceiveMessage?(message)
            
        case "presence":
            if let users = jsonObject["users"] as? [String] {
                onUserListUpdate?(users)
            }
            
        case "error":
            if let errorMessage = jsonObject["message"] as? String {
                onError?(errorMessage)
            }
            
        default:
            break
        }
    }
    
}

// MARK: - Send Data
extension ChatWebSocketManager {
    // Make a log in to get an id
    private func sendLoginMessage(userId: String) {
        let loginMessage = ["type": "login", "user_id": userId]
        sendJsonMessage(loginMessage)
    }
    
    func sendPublicMessage(_ content: String) {
        let message = ["type": "message", "content": content]
        sendJsonMessage(message)
    }
    
    func sendPrivateMessage(_ content: String, to recipient: String) {
        let message = ["type": "message", "content": content, "to": recipient]
        sendJsonMessage(message)
    }
    
    func sendTypingStatus(_ isTyping: Bool) {
        let message = ["type": "typing", "status": isTyping] as [String : Any]
        sendJsonMessage(message)
    }
    
    private func sendJsonMessage(_ message: [String: Any]) {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: message),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            onError?("Failed to serialize message")
            return
        }
        
        Task {
            if webSocketTask!.state == .running  {
                await socketStream?.send(.string(jsonString))
            } else {
                onError?("Failed to serialize message")
            }
        }
    }
}
