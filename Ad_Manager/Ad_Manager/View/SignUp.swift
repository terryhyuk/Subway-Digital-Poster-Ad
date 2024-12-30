//
//  SingUp.swift
//  Ad_Manager
//
//  Created by LrZl on 12/26/24.
//

import FirebaseFirestore
import SwiftUI

struct SignUp: View {
    // MARK: - Properties

    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = SignUpViewModel()
    
    // MARK: - State Variables

    @State private var id = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var name = ""
    @State private var companyName = ""
    @State private var email = ""
    @State private var tel = ""
    @State private var isAdmin = false
    @State private var showinAlert = false
    @State private var alertMessage: String = ""
    @State private var isPasswordFieldEnabled = false
    @State private var isNameFieldEnabled = false
    @State private var showPasswordConfirmMessage = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 40) {
                    // MARK: - Input Form Section

                    VStack(spacing: 40) {
                        // ID Input Section
                        HStack {
                            TextField("ID", text: $id)
                                .autocapitalization(.none)
                            Button("Check ID") {
                                if id.isEmpty {
                                    alertMessage = "ID를 입력해주세요"
                                    showinAlert = true
                                    return
                                }
                                Task {
                                    do {
                                        let isAvailable = try await viewModel.checkIdAvailability(id: id)
                                        if isAvailable {
                                            isPasswordFieldEnabled = true
                                            alertMessage = "사용 가능한 아이디입니다"
                                        } else {
                                            isPasswordFieldEnabled = false
                                            alertMessage = "이미 사용중인 아이디입니다"
                                        }
                                        showinAlert = true
                                    } catch {
                                        alertMessage = "오류가 발생했습니다"
                                        showinAlert = true
                                        isPasswordFieldEnabled = false
                                    }
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color(red: 255/255, green: 218/255, blue: 214/255))
                            .cornerRadius(20)
                        }
                    
                        // Password Section
                        VStack(spacing: 25) {
                            SecureField("Password", text: $password)
                                .disabled(!isPasswordFieldEnabled)
                                .autocapitalization(.none)
                                .textContentType(.oneTimeCode)
                            
                            SecureField("Confirm Password", text: $confirmPassword)
                                .disabled(!isPasswordFieldEnabled)
                                .autocapitalization(.none)
                                .textContentType(.oneTimeCode)
                                .onChange(of: confirmPassword) {
                                    if !confirmPassword.isEmpty && !password.isEmpty {
                                        if password == confirmPassword {
                                            showPasswordConfirmMessage = true
                                            isNameFieldEnabled = true
                                        } else {
                                            showPasswordConfirmMessage = false
                                            isNameFieldEnabled = false
                                        }
                                    }
                                }
                            
                            if !confirmPassword.isEmpty && !password.isEmpty {
                                Text(password == confirmPassword ? "비밀번호가 일치합니다" : "비밀번호를 확인해주세요")
                                    .foregroundColor(password == confirmPassword ? .green : .red)
                                    .font(.caption)
                            }
                        }

                        // User Info Section
                        TextField("Name", text: $name)
                            .disabled(!isNameFieldEnabled)
                        
                        TextField("Company Name", text: $companyName)
                            .disabled(!isNameFieldEnabled)
                        
                        // Contact Info Section
                        TextField("Email", text: $email)
                            .disabled(!isNameFieldEnabled)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        
                        TextField("Tel", text: $tel)
                            .disabled(!isNameFieldEnabled)
                            .keyboardType(.numberPad)
                    }
                    .textFieldStyle(UnderlineTextFieldStyle())
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // MARK: - Button Section

                    HStack(spacing: 20) {
                        Button("SignUp") {
                            // 모든 필수 필드 검증
                            if id.isEmpty || password.isEmpty || confirmPassword.isEmpty ||
                                name.isEmpty || companyName.isEmpty || email.isEmpty || tel.isEmpty
                            {
                                alertMessage = "모든 정보를 입력해주세요"
                                showinAlert = true
                                return
                            }
                            
                            Task {
                                do {
                                    try await viewModel.createAccount(
                                        id: id,
                                        password: password,
                                        name: name,
                                        companyName: companyName,
                                        email: email,
                                        tel: tel,
                                        isAdmin: isAdmin
                                    )
                                    alertMessage = "회원가입이 완료되었습니다"
                                    showinAlert = true
                                } catch {
                                    alertMessage = error.localizedDescription
                                    showinAlert = true
                                }
                            }
                        }
                        .frame(width: 120)
                        .padding(.vertical, 10)
                        .background(Color(red: 203/255, green: 241/255, blue: 245/255))
                        .cornerRadius(25)
                        
                        Button("Cancel") {
                            dismiss()
                        }
                        .frame(width: 120)
                        .padding(.vertical, 10)
                        .background(Color(red: 255/255, green: 218/255, blue: 214/255))
                        .cornerRadius(25)
                    }
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("Create Account")
            .navigationBarTitleDisplayMode(.inline)
            .alert("알림", isPresented: $showinAlert) {
                Button("확인") {
                    if alertMessage == "회원가입이 완료되었습니다" {
                        dismiss()
                    }
                }
            } message: {
                Text(alertMessage)
            }

            .ignoresSafeArea(.keyboard, edges: .bottom)
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
