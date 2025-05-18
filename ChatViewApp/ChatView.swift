import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    @State private var messageText = ""
    @State private var recipient = ""
    @State private var isPrivateMessage = false
    
    var body: some View {
        VStack {
            // Connection status
            ConnectionStatusView(isConnected: viewModel.isConnected)
            
            // Messages list
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(viewModel.messages) { message in
                        MessageBubble(message: message, currentUserId: viewModel.userId)
                    }
                }
                .padding(.horizontal)
            }
            
            // Active users
            if !viewModel.activeUsers.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.activeUsers, id: \.self) { user in
                            Button(action: {
                                self.recipient = user
                                self.isPrivateMessage = true
                            }) {
                                Text(user)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.blue.opacity(0.2))
                                    .cornerRadius(15)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(height: 40)
            }
            
            // Message input
            VStack {
                if isPrivateMessage {
                    HStack {
                        Text("To: \(recipient)")
                        
                        Spacer()
                        
                        Button(action: {
                            isPrivateMessage = false
                            recipient = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal)
                }
                
                HStack {
                    TextField("Type a message", text: $messageText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: messageText) { _, newValue in
                            viewModel.updateTypingStatus(!newValue.isEmpty)
                        }
                    
                    Button(action: sendMessage) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.blue)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Chat")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(viewModel.isConnected ? "Disconnect" : "Connect") {
                    if viewModel.isConnected {
                        viewModel.disconnect()
                    } else {
                        viewModel.connect()
                    }
                }
            }
        }
        .onAppear {
            viewModel.connect()
        }
        .onDisappear {
            viewModel.disconnect()
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage)
        }
    }
    
    private func sendMessage() {
        guard !messageText.isEmpty else { return }
        
        if isPrivateMessage && !recipient.isEmpty {
            viewModel.sendPrivateMessage(messageText, to: recipient)
        } else {
            viewModel.sendPublicMessage(messageText)
        }
        
        messageText = ""
    }
}

struct ConnectionStatusView: View {
    let isConnected: Bool
    
    var body: some View {
        HStack {
            Circle()
                .fill(isConnected ? Color.green : Color.red)
                .frame(width: 10, height: 10)
            
            Text(isConnected ? "Connected" : "Disconnected")
                .font(.caption)
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
        .background(Color.gray.opacity(0.1))
    }
}

struct MessageBubble: View {
    let message: ChatMessage
    let currentUserId: String
    
    private var isFromCurrentUser: Bool {
        message.from == currentUserId
    }
    
    var body: some View {
        VStack(alignment: isFromCurrentUser ? .trailing : .leading) {
            if message.from != "System" {
                Text(message.from)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            HStack {
                if isFromCurrentUser && message.from != "System" {
                    Spacer()
                }
                
                VStack(alignment: .leading) {
                    if message.isPrivate {
                        Text("Private")
                            .font(.caption2)
                            .foregroundColor(.purple)
                    }
                    
                    Text(message.content)
                        .padding(10)
                        .background(backgroundColor)
                        .foregroundColor(textColor)
                        .cornerRadius(10)
                }
                
                if !isFromCurrentUser && message.from != "System" {
                    Spacer()
                }
            }
        }
        .padding(.vertical, 5)
    }
    
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
}

// Add unique identifier for ForEach
extension ChatMessage: Identifiable {
    var id: String {
        UUID().uuidString // In a real app, use a more reliable ID
    }
}