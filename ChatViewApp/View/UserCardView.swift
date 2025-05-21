//
//  UserCardView.swift
//  ChatViewApp
//
//  Created by name on 18/05/2025.
//

import SwiftUI

struct UserCards: View {
    @StateObject private var viewModel = ChatViewModel()
    @State private var recipient = ""
    @State private var isPrivateMessage = false
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    ForEach(viewModel.activeUsers, id: \.self) { user in
                        UserCardView(userName: user)
                            .padding(5)
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
                    }
                }
            }
            .padding(.horizontal)
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
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Active Users")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(.neumorphictextColor)
                        .padding()
                }
            }
            .background(Color.background.ignoresSafeArea())
        }
    }
}


#Preview{
    UserCards()
}


struct UserCardView: View {
    let userName: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.darkShadow)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(userName)
                    .font(.headline)
                    .foregroundColor(.neumorphictextColor)
            }
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.background)
        .cornerRadius(16)
        .shadow(color: .darkShadow, radius: 3, x: 2, y: 2)
        .shadow(color: .lightShadow, radius: 3, x: -2, y: -2)
        
        .contentShape(Rectangle())
    }
}

