//
//  LoginView.swift
//  ChatViewApp
//
//  Created by name on 18/05/2025.
//

import SwiftUI

struct LoginView: View {
    @State var text = ""
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            VStack(alignment: .leading) {
                
                VStack(alignment: .leading) {
                    Text("Inter your ID")
                        .font(.headline)
                        .foregroundColor(.neumorphictextColor)
                        .padding(.leading, 5)
                    
                    HStack {
                        NeumorphicStyleTextField(textField: TextField("ID", text: $text), imageName: "person.crop.circle")
                    }
                }
                .padding()
                .background(Color.background)
                .cornerRadius(10)
                .shadow(color: .darkShadow, radius: 5, x: 5, y: 5)
                .shadow(color: .lightShadow, radius: 5, x: -5, y: -5)
                
                NeumorphicStyleButton(title: "Login", systemImage: "arrow.right") {
                    // Handle login action here
                    print("Login tapped with ID: \(text)")
                }
                .padding(.top, 30)
                
                
            }.padding()
        }
    }
}

#Preview {
    LoginView()
}

struct NeumorphicStyleTextField: View {
    var textField: TextField<Text>
    var imageName: String
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .foregroundColor(.darkShadow)
            textField
        }
        .padding()
        .foregroundColor(.neumorphictextColor)
        .background(Color.background)
        .cornerRadius(6)
        .shadow(color: Color.darkShadow, radius: 3, x: 2, y: 2)
        .shadow(color: Color.lightShadow, radius: 3, x: -2, y: -2)
        
    }
}
struct NeumorphicStyleButton: View {
    var title: String
    var systemImage: String?
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .foregroundColor(.neumorphictextColor)
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.background)
            .cornerRadius(6)
            .shadow(color: Color.darkShadow, radius: 3, x: 2, y: 2)
            .shadow(color: Color.lightShadow, radius: 3, x: -2, y: -2)
        }
    }
}
