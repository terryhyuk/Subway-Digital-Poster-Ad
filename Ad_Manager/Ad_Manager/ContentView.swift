//
//  ContentView.swift
//  Ad_Manager
//
//  Created by aeong on 12/26/24.
//

import FirebaseFirestore
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var loginManager: LoginManager
    @State private var id: String = "" // 사용자 ID 입력값
    @State private var password: String = "" // 비밀번호 입력값
    @State private var isSignUpPresented: Bool = false // SignUp 화면 상태 관리

    var body: some View {
        NavigationStack {
            if loginManager.isLoggedIn {
                MainView()
            } else {
                VStack {
                    Spacer()

                    // 앱 로고
                    Image("AdHome")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)

                    // 입력 필드
                    VStack(spacing: 20) {
                        TextField("ID", text: $id)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(30)
                            .foregroundColor(.black)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)

                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(30)
                            .foregroundColor(.black)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                    .padding()

                    // 버튼
                    HStack(spacing: 20) {
                        Button(action: {
                            loginManager.login(id: id, password: password)
                        }) {
                            Text("LogIn")
                                .bold()
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue.opacity(0.2)) // 배경색
                                .foregroundColor(.black) // 텍스트 색상
                                .cornerRadius(30)
                        }

                        Button(action: {
                            isSignUpPresented = true // SignUp 화면 전환
                        }) {
                            Text("SignUp")
                                .bold()
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.red.opacity(0.2)) // 배경색
                                .foregroundColor(.black) // 텍스트 색상
                                .cornerRadius(30)
                        }
                        .navigationDestination(isPresented: $isSignUpPresented) {
                            SignUp()
                        }
                    }
                    .padding(.horizontal)

                    // 에러 메시지
                    Text(loginManager.errorMessage ?? "")
                        .foregroundColor(.red)
                        .font(.footnote)
                        .frame(height: 20)
                        .padding(.top)

                    Spacer()
                }
                .padding()
            }
        }
    }
}
