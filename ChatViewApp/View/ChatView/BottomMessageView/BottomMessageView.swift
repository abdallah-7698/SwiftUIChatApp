//
//  BottomMessageView.swift
//  ChatViewApp
//
//  Created by name on 20/05/2025.
//

import SwiftUI

struct BottomMessageView: View {
    
    @ObservedObject var viewModel: ChatViewModel
    @Binding var messageText: String
    let sendAction: () -> Void
    
    var body: some View {
        VStack {
            
            //                if isPrivateMessage {
            //                    HStack {
            //                        Text("To: \(recipient)")
            //
            //                        Spacer()
            //
            //                        Button(action: {
            //                            isPrivateMessage = false
            //                            recipient = ""
            //                        }) {
            //                            Image(systemName: "xmark.circle.fill")
            //                                .foregroundColor(.gray)
            //                        }
            //                    }
            //                    .padding(.horizontal)
            //                }
            
            HStack(spacing: 2) {
                TextField("Type a message", text: $messageText)
                    .foregroundColor(.neumorphictextColor)
                    .padding(15)
                    .background(Color.background)
                    .cornerRadius(20)
                    .shadow(color: Color.darkShadow.opacity(0.2), radius: 4, x: 2, y: 2)
                    .shadow(color: Color.lightShadow.opacity(0.9), radius: 4, x: -2, y: -2)
                    .onChange(of: messageText) { _, newValue in
                        viewModel.updateTypingStatus(!newValue.isEmpty)
                    }
                
                Button(action: sendAction) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.neumorphictextColor)
                        .padding(10)
                        .background(Color.background)
                        .clipShape(Circle())
                        .shadow(color: Color.darkShadow.opacity(0.2), radius: 3, x: 2, y: 2)
                        .shadow(color: Color.lightShadow.opacity(0.9), radius: 3, x: -2, y: -2)
                }
            }
            .padding(.trailing,-13)
            .padding(.top,15)
            .padding(.horizontal, 5)
            
        }
    }
}

#Preview {
    NavigationView {
        VStack {Rectangle().fill(Color.red)}
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    BottomMessageView(viewModel: ChatViewModel(), messageText: .constant(""), sendAction: {})
                }
            }
    }
    
}
