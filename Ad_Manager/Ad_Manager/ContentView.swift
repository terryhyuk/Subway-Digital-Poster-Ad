//
//  ContentView.swift
//  Ad_Manager
//
//  Created by aeong on 12/26/24.
//

import FirebaseFirestore
import SwiftUI

struct ContentView: View {
    @FocusState var isTextFieldFocused: Bool
    @State private var id: String = "" // 사용자 ID 입력값
    @State private var password: String = "" // 비밀번호 입력값
    @State private var errorMessage: String? = nil // 에러 메시지 상태
    @State private var isLoggedIn: Bool = false // 로그인 성공 상태
    @State private var isSignUpPresented: Bool = false // SignUp 화면 전환 상태

    var body: some View {
        NavigationStack {
            if isLoggedIn {
                MainView() // 로그인 성공 후 이동할 화면
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
                            .focused($isTextFieldFocused)
                            .autocapitalization(.none) // 자동 대문자 비활성화
                            .disableAutocorrection(true) // 자동 완성 비활성화

                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(30)
                            .foregroundColor(.black)
                            .focused($isTextFieldFocused)
                            .autocapitalization(.none) // 대문자 비활성화
                            .disableAutocorrection(true) // 자동 완성 비활성화
                    }
                    .padding()

                    // 버튼
                    HStack(spacing: 20) {
                        Button(action: {
                            login()
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
                    Text(errorMessage ?? "")
                        .foregroundColor(.red)
                        .font(.footnote)
                        .frame(height: 20) // 고정된 공간 확보
                        .padding(.top)
                        .opacity(errorMessage == nil ? 0 : 1) // 애니메이션 효과
                        .animation(.easeInOut, value: errorMessage)

                    Spacer()
                }
                .padding()
            }
        }
    }

    // Firestore 로그인 함수
    func login() {
        guard !id.isEmpty, !password.isEmpty else {
            errorMessage = "ID와 Password를 입력하세요."
            return
        }

        let db = Firestore.firestore()

        // Firestore에서 사용자 검색
        db.collection("users")
            .whereField("id", isEqualTo: id)
            .getDocuments { snapshot, error in
                if let error = error {
                    errorMessage = "로그인 실패: \(error.localizedDescription)"
                    return
                }

                guard let documents = snapshot?.documents, !documents.isEmpty else {
                    errorMessage = "해당 사용자가 존재하지 않습니다."
                    return
                }

                // 사용자 데이터 검증
                if let userData = documents.first?.data(),
                   let storedPassword = userData["password"] as? String
                {
                    if storedPassword == password {
                        DispatchQueue.main.async {
                            isLoggedIn = true // 로그인 성공
                            errorMessage = nil
                        }
                    } else {
                        DispatchQueue.main.async {
                            errorMessage = "비밀번호가 일치하지 않습니다."
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        errorMessage = "사용자 데이터에 문제가 있습니다."
                    }
                }
            }
    }
}

// 다음 화면(MainView) 예제
struct MainView: View {
    var body: some View {
        VStack {
            Text("메인 화면입니다!")
                .font(.largeTitle)
                .padding()

            NavigationLink(destination: AnotherView()) {
                Text("다음 화면으로 이동")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}

// 추가 화면 예제
struct AnotherView: View {
    var body: some View {
        Text("다음 화면입니다!")
            .font(.title)
            .padding()
    }
}

// 미리보기
#Preview {
    ContentView()
}
