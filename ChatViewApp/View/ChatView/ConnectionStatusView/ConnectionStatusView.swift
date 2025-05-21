//
//  ConnectionStatusView.swift
//  ChatViewApp
//
//  Created by name on 20/05/2025.
import SwiftUI

struct ConnectionStatusView: View {
    @Binding var isConnected: Bool
    @ObservedObject var viewModel: ChatViewModel
    
    var body: some View {
        HStack(spacing: 12) {
            HStack(spacing: 6) {
                Circle()
                    .fill(isConnected ? Color.successGreen : Color.errorRed)
                    .frame(width: 10, height: 10)
                    .shadow(color: (isConnected ? Color.successGreen : Color.errorRed).opacity(0.6), radius: 4, x: 0, y: 0)
                
                Text(isConnected ? "Connected" : "Disconnected")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(isConnected ? Color.successGreen : Color.errorRed)
            }
            
            Spacer()
            
            Button {
                if isConnected {
                    viewModel.disconnect()
                } else {
                    viewModel.connect()
                }
            } label: {
                Text(isConnected ? "Disconnect" : "Connect")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(isConnected ? Color.red.opacity(0.8) : Color.green.opacity(0.8))
                    .padding(.vertical, 6)
                    .padding(.horizontal, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isConnected ? Color.red.opacity(0.8) : Color.green.opacity(0.8), lineWidth: 1.5)
                    )
            }
            .buttonStyle(PlainButtonStyle())
            .animation(.easeInOut(duration: 0.25), value: isConnected)
            
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.background)
                .shadow(color: Color.darkShadow.opacity(0.12), radius: 6, x: 4, y: 4)
                .shadow(color: Color.lightShadow.opacity(0.7), radius: 6, x: -4, y: -4)
        )
        .padding(.horizontal)
        .animation(.easeInOut, value: isConnected)
    }
}

#Preview {
    NavigationView {
        VStack{
            Rectangle().fill(Color.gray.opacity(0.1))
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                ConnectionStatusView(isConnected: .constant(false), viewModel: ChatViewModel())
            }
        }
    }
}

