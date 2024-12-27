//
//  SingUp.swift
//  Ad_Manager
//
//  Created by LrZl on 12/26/24.
//

import SwiftUI

struct SignUp: View {
    @Environment(\.dismiss) var dismiss
    @State private var userId = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var name = ""
    @State private var companyName = ""
    @State private var email = ""
    @State private var tel = ""

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
                Text("Create Account")
                    .font(.headline)
                Spacer()
            }
            .padding(.horizontal)

            VStack(spacing: 25) {
                HStack {
                    TextField("ID", text: $userId)
                    Button("Check ID") {
                        // 아이디 체크 로직
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(red: 255/255, green: 218/255, blue: 214/255))
                    .cornerRadius(20)
                }

                TextField("Password", text: $password)
                TextField("Confirm Password", text: $confirmPassword)
                TextField("Name", text: $name)
                TextField("Company Name", text: $companyName)
                TextField("Email", text: $email)
                TextField("Tel", text: $tel)
            }
            .textFieldStyle(UnderlineTextFieldStyle())
            .padding(.horizontal)

            Spacer()

            HStack(spacing: 20) {
                Button("SignUp") {
                    // 회원가입 로직
                }
                .frame(width: 120)
                .padding(.vertical, 12)
                .background(Color(red: 203/255, green: 241/255, blue: 245/255))
                .cornerRadius(25)

                Button("Cancel") {
                    dismiss()
                }
                .frame(width: 120)
                .padding(.vertical, 12)
                .background(Color(red: 255/255, green: 218/255, blue: 214/255))
                .cornerRadius(25)
            }
            .padding(.bottom, 30)
        }
    }
}

struct UnderlineTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        VStack {
            configuration
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray.opacity(0.3))
        }
    }
}

#Preview {
    SignUp()
}
