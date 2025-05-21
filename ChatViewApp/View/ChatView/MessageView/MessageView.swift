//
//  GeneralMessageView.swift
//  ChatViewApp
//
//  Created by name on 18/05/2025.
//

import SwiftUI

struct MessageView: View {
    enum MessageType {
        case personal
        case general
        case system
    }
    
    let messageType: MessageType
    let message: String
    
    var body: some View {
        switch messageType {
        case .personal:
            personalMessageView(message: message)
        case .general:
            GeneralMessageView(message: message)
        case .system:
            SystemMessageView(message: message)
        }
    }
}

#Preview {
    ZStack{
        Color.background
        VStack {
            MessageView(messageType: .system, message: "Message")
            MessageView(messageType: .general, message: "Message")
            MessageView(messageType: .personal, message: "Message")
        }
    }
    .ignoresSafeArea(.all)
}


private struct personalMessageView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .padding(10)
            .foregroundColor(.white)
            .fontWeight(.bold)
            .cornerRadius(10)
            .background {
                UnevenRoundedRectangle(cornerRadii: .init(
                    topLeading: 25,
                    bottomLeading: 1,
                    bottomTrailing: 40,
                    topTrailing: 20),
                                       style: .continuous)
                .foregroundStyle(Color.accentIndigo)
            }
    }
}


private struct GeneralMessageView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .padding(10)
            .foregroundColor(.white)
            .fontWeight(.bold)
            .cornerRadius(10)
            .background {
                UnevenRoundedRectangle(cornerRadii: .init(
                    topLeading: 25,
                    bottomLeading: 20,
                    bottomTrailing: 1,
                    topTrailing: 20),
                                       style: .continuous)
                .foregroundStyle(Color.elevatedSurface)
            }
    }
}

private struct SystemMessageView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .padding(10)
            .foregroundColor(.gray.opacity(0.8))
            .fontWeight(.light)
            .cornerRadius(10)
            .underline()
    }
}
