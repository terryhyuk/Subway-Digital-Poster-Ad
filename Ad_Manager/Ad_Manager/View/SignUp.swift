//
//  SingUp.swift
//  Ad_Manager
//
//  Created by LrZl on 12/26/24.
//

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
    
    // MARK: - Computed Properties
    private var passwordMessage: String {
        if password.isEmpty {
            return "비밀번호는 숫자와 특수문자를 포함한 4자리 이상이어야 합니다"
        } else if confirmPassword.isEmpty {
            return "비밀번호 확인을 입력해주세요"
        } else if password == confirmPassword {
            return "비밀번호가 일치합니다"
        } else {
            return "비밀번호가 일치하지 않습니다"
        }
    } // end of passwordMessage
    
    private var passwordMessageColor: Color {
        if password.isEmpty || confirmPassword.isEmpty {
            return .gray
        } else if password == confirmPassword {
            return .green
        } else {
            return .red
        }
    } // end of passwordMessageColor
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 40) {
                        // MARK: - Input Form Section
                        VStack(spacing: 40) {
                            // ID Input Section
                            HStack {
                                TextField("ID", text: $id)
                                    .autocapitalization(.none)
                                Button("Check ID") {
                                    Task {
                                        do {
                                            let isAvailable = try await viewModel.checkIdAvailability(id: id)
                                            alertMessage = isAvailable ? "사용 가능한 아이디 입니다" : "이미 사용중인 아이디 입니다."
                                            showinAlert = true
                                        } catch {
                                            alertMessage = "오류가 발생했습니다"
                                            showinAlert = true
                                        }
                                    }
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color(red: 255/255, green: 218/255, blue: 214/255))
                                .cornerRadius(20)
                            } // end of ID Section
                            
                            // Password Section
                            VStack(spacing: 25) {
                                SecureField("Password", text: $password)
                                    .autocapitalization(.none)
                                    .textContentType(.oneTimeCode)
                                    
                                SecureField("Confirm Password", text: $confirmPassword)
                                    .autocapitalization(.none)
                                    .textContentType(.oneTimeCode)
                                    .onSubmit {
                                        if !confirmPassword.isEmpty {
                                            if password != confirmPassword {
                                                alertMessage = "비밀번호가 일치하지 않습니다"
                                                showinAlert = true
                                            }
                                        }
                                    }
                            } // end of Password Section
                            
                            // User Info Section
                            TextField("Name", text: $name)
                            TextField("Company Name", text: $companyName)
                            
                            // Contact Info Section
                            TextField("Email", text: $email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                            
                            TextField("Tel", text: $tel)
                                .keyboardType(.numberPad)
                        } // end of Input Form Section
                        .textFieldStyle(UnderlineTextFieldStyle())
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        // MARK: - Button Section
                        HStack(spacing: 20) {
                            Button("SignUp") {
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
                                        dismiss()
                                    } catch {
                                        alertMessage = "회원가입에 실패했습니다"
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
                        } // end of Button Section
                        .padding(.bottom, 30)
                    }
                }
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                        to: nil, from: nil, for: nil)
                }
            }
            .navigationTitle("Create Account")
            .navigationBarTitleDisplayMode(.inline)
            .alert("알림", isPresented: $showinAlert) {
                Button("확인", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    } // end of body
} // end of SignupView

// MARK: - Extensions
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
} // end of View extension

// MARK: - Custom Styles
struct UnderlineTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        VStack {
            configuration
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray.opacity(0.3))
        }
    }
} // end of UnderlineTextFieldStyle

// MARK: - Preview
#Preview {
    SignUp()
}
