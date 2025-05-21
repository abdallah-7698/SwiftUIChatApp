//
//  MessageBubble.swift
//  ChatViewApp
//
//  Created by name on 18/05/2025.
//
import SwiftUI

struct MessageBubble: View {
    
    let message: ChatMessage
    let currentUserId: String
    
    
    private var backgroundColor: Color {
        if message.from == "System" {
            return Color.gray.opacity(0.2)
        } else if isFromCurrentUser {
            return Color.blue
        } else {
            return Color.gray.opacity(0.4)
        }
    }
    
    private var textColor: Color {
        isFromCurrentUser ? .white : .primary
    }
    
    private var isFromCurrentUser: Bool {
        message.from == currentUserId
    }
    
    var body: some View {
        VStack() {
            if message.from != "System" && !isFromCurrentUser {
                Text(message.from)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            HStack {
                if !isFromCurrentUser && message.from != "System" {
                    Spacer()
                }
                
                VStack(alignment: .leading) {
                    if message.isPrivate {
                        Text("Private")
                            .font(.caption2)
                            .foregroundColor(.purple)
                    }
                    
                    if isFromCurrentUser && message.from != "System" {
                        MessageView(messageType: .personal, message: message.content)
                    } else if !isFromCurrentUser && message.from != "System" {
                        MessageView(messageType: .general, message: message.content)
                    } else {
                        MessageView(messageType: .system, message: message.content)
                    }
                }
                
                if isFromCurrentUser && message.from != "System" {
                    Spacer()
                }
            }
            
            
        }
        
        .frame(maxWidth: .infinity)
        .padding(.vertical, 5)
    }
}

#Preview {
    VStack {
        MessageBubble(message: .init(from: "User 1", content: "Hi", isPrivate: true), currentUserId: "123")
        MessageBubble(message: .init(from: "123", content: "Hi", isPrivate: false), currentUserId: "123")
    }
    .padding(10)
    .border(Color.gray)
}
