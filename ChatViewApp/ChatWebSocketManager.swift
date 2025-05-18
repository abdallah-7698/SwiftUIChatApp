import Foundation

class ChatWebSocketManager: NSObject {
    private var webSocketTask: URLSessionWebSocketTask?
    private var session: URLSession!
    
    // Callback handlers
    var onReceiveMessage: ((ChatMessage) -> Void)?
    var onConnectionChange: ((Bool) -> Void)?
    var onUserListUpdate: (([String]) -> Void)?
    var onError: ((String) -> Void)?
    
    private var userId: String
    
    init(userId: String) {
        self.userId = userId
        super.init()
        session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
    }
    
    func connect() {
        guard let url = URL(string: "ws://localhost:8765") else {
            onError?("Invalid URL")
            return
        }
        
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
        
        // Send login message immediately after connecting
        sendLoginMessage()
        
        // Start receiving messages
        receiveMessage()
        
        onConnectionChange?(true)
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
        onConnectionChange?(false)
    }
    
    private func sendLoginMessage() {
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
        let message = ["type": "typing", "status": isTyping]
        sendJsonMessage(message)
    }
    
    private func sendJsonMessage(_ message: [String: Any]) {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: message),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            onError?("Failed to serialize message")
            return
        }
        
        webSocketTask?.send(.string(jsonString)) { error in
            if let error = error {
                self.onError?("Send error: \(error.localizedDescription)")
            }
        }
    }
    
    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    self.handleMessage(text)
                case .data(let data):
                    if let text = String(data: data, encoding: .utf8) {
                        self.handleMessage(text)
                    }
                @unknown default:
                    break
                }
                
                // Continue receiving messages
                self.receiveMessage()
                
            case .failure(let error):
                self.onError?("Receive error: \(error.localizedDescription)")
                // Attempt to reconnect after a delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self.connect()
                }
            }
        }
    }
    
    private func handleMessage(_ messageText: String) {
        guard let data = messageText.data(using: .utf8),
              let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let messageType = jsonObject["type"] as? String else {
            onError?("Invalid message format")
            return
        }
        
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

// Data models
struct ChatMessage {
    let from: String
    let content: String
    let isPrivate: Bool
    let to: String?
    
    init(from: String, content: String, isPrivate: Bool, to: String? = nil) {
        self.from = from
        self.content = content
        self.isPrivate = isPrivate
        self.to = to
    }
}