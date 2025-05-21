//
//  ChatViewModel.swift
//  ChatViewApp
//
//  Created by name on 17/05/2025.
//

import Foundation
import Combine

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var activeUsers: [String] = []
    @Published var isConnected: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    private var webSocketManager: ChatWebSocketManager
    let userId: String
    
    init() {
        // In a real app, you'd get this from user login
        self.userId = "iOS_User_\(Int.random(in: 1000...9999))"
        self.webSocketManager = ChatWebSocketManager(userId: userId)
        
        setupCallbacks()
    }
    
    private func setupCallbacks() {
        webSocketManager.onReceiveMessage = { [weak self] message in
            DispatchQueue.main.async {
                self?.messages.append(message)
            }
        }
        
        webSocketManager.onConnectionChange = { [weak self] isConnected in
            DispatchQueue.main.async {
                self?.isConnected = isConnected
            }
        }
        
        webSocketManager.onUserListUpdate = { [weak self] users in
            DispatchQueue.main.async {
                self?.activeUsers = users
            }
        }
        
        webSocketManager.onError = { [weak self] error in
            DispatchQueue.main.async {
                self?.errorMessage = error
                self?.showError = true
            }
        }
    }
    
    func connect() {
        webSocketManager.connect()
    }
    
    func disconnect() {
        webSocketManager.disconnect()
    }
    
    func sendPublicMessage(_ content: String) {
        webSocketManager.sendPublicMessage(content)
    }
    
    func sendPrivateMessage(_ content: String, to recipient: String) {
        webSocketManager.sendPrivateMessage(content, to: recipient)
    }
    
    func updateTypingStatus(_ isTyping: Bool) {
        webSocketManager.sendTypingStatus(isTyping)
    }
}
