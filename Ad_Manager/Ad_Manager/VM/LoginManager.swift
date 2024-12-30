//
//  LoginManager.swift
//  Ad_Manager
//
//  Created by aeong on 12/30/24.
//

import FirebaseFirestore
import SwiftUI

class LoginManager: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String? = nil

    func login(id: String, password: String) {
        guard !id.isEmpty, !password.isEmpty else {
            errorMessage = "ID와 Password를 입력하세요."
            return
        }

        let db = Firestore.firestore()

        db.collection("users")
            .whereField("id", isEqualTo: id)
            .getDocuments { snapshot, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.errorMessage = "로그인 실패: \(error.localizedDescription)"
                    }
                    return
                }

                guard let documents = snapshot?.documents, !documents.isEmpty else {
                    DispatchQueue.main.async {
                        self.errorMessage = "해당 사용자가 존재하지 않습니다."
                    }
                    return
                }

                if let userData = documents.first?.data(),
                   let storedPassword = userData["password"] as? String
                {
                    if storedPassword == password {
                        DispatchQueue.main.async {
                            self.isLoggedIn = true
                            self.errorMessage = nil
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.errorMessage = "비밀번호가 일치하지 않습니다."
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.errorMessage = "사용자 데이터에 문제가 있습니다."
                    }
                }
            }
    }

    func logout() {
        isLoggedIn = false
        errorMessage = nil
    }
}
