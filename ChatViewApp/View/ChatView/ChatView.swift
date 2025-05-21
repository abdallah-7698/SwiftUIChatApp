//
//  ChatView.swift
//  ChatViewApp
//
//  Created by name on 17/05/2025.
//


import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    @State private var messageText = ""
    @State private var recipient = ""
    @State private var isPrivateMessage = false
    
    var body: some View {
        NavigationView {
            VStack {
                
                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false) {
                        LazyVStack(alignment: .leading) {
                            ForEach(viewModel.messages) { message in
                                MessageBubble(message: message, currentUserId: viewModel.userId)
                                    .id(message.id)
                            }

                            Color.clear.id("BOTTOM_ANCHOR")
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 3)
                    }
                    // Scroll on first appearance
                    .onAppear {
                        scrollToBottom(proxy: proxy)
                    }
                    // Scroll when messages change
                    .onChange(of: viewModel.messages.count) {
                        scrollToBottom(proxy: proxy)
                    }
                }
                
                // Active users
                //            if !viewModel.activeUsers.isEmpty {
                //                ScrollView(.horizontal, showsIndicators: false) {
                //                    HStack {
                //                        ForEach(viewModel.activeUsers, id: \.self) { user in
                //                            Button(action: {
                //                                self.recipient = user
                //                                self.isPrivateMessage = true
                //                            }) {
                //                                Text(user)
                //                                    .padding(.horizontal, 12)
                //                                    .padding(.vertical, 6)
                //                                    .background(Color.blue.opacity(0.2))
                //                                    .cornerRadius(15)
                //                            }
                //                        }
                //                    }
                //                    .padding(.horizontal)
                //                }
                //                .frame(height: 40)
                //            }
            }
            .background(Color.background)
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    ConnectionStatusView(isConnected: $viewModel.isConnected, viewModel: viewModel)
                }
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    BottomMessageView(viewModel: viewModel, messageText: $messageText, sendAction: sendMessage)
                }
                
            }
            .toolbarBackground(.hidden, for: .bottomBar)
            .toolbarBackground(.hidden, for: .automatic)
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
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        // Make sure we have messages before scrolling
        guard !viewModel.messages.isEmpty else { return }
        
        withAnimation(.easeInOut(duration: 1.0)) {
            proxy.scrollTo("BOTTOM_ANCHOR")
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


extension ChatMessage: Identifiable, Equatable {
    var id: String {
        UUID().uuidString
    }
    
    static func == (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
        lhs.id == rhs.id
    }
}

#Preview{
    ChatView()
}
