//
//  singup.swift
//  Ad_Manager
//
//  Created by LrZl on 12/27/24.
//

import Foundation
import FirebaseFirestore
import FirebaseCore

@MainActor
class SignUpViewModel: ObservableObject {
    @Published var errorMessage = ""
    @Published var isLoading = false
    @Published var isIdAvailable = false
    
    func checkIdAvailability(id: String) async throws -> Bool {
        isLoading = true
        defer { isLoading = false }
        
        guard !id.isEmpty else {
            errorMessage = "ID를 입력해주세요"
            return false
        }
        
        let snapshot = try await Firestore.firestore()
            .collection("users")
            .whereField("id", isEqualTo: id)
            .getDocuments()
        
        isIdAvailable = snapshot.documents.isEmpty
        errorMessage = isIdAvailable ? "사용 가능한 ID입니다" : "이미 사용중인 ID입니다"
        return isIdAvailable
    }
    
    func createAccount(id: String, password: String, name: String,
                      companyName: String, email: String, tel: String,
                      isAdmin: Bool = false) async throws {
        // 각 필드별 유효성 검사
        if id.isEmpty {
            throw NSError(domain: "", code: -1,
                         userInfo: [NSLocalizedDescriptionKey: "ID를 입력해주세요"])
        }
        
        if !isIdAvailable {
            throw NSError(domain: "", code: -1,
                         userInfo: [NSLocalizedDescriptionKey: "ID 중복 체크를 해주세요"])
        }
        
        if password.isEmpty {
            throw NSError(domain: "", code: -1,
                         userInfo: [NSLocalizedDescriptionKey: "비밀번호를 입력해주세요"])
        }
        
        if name.isEmpty {
            throw NSError(domain: "", code: -1,
                         userInfo: [NSLocalizedDescriptionKey: "이름을 입력해주세요"])
        }
        
        if companyName.isEmpty {
            throw NSError(domain: "", code: -1,
                         userInfo: [NSLocalizedDescriptionKey: "회사명을 입력해주세요"])
        }
        
        if !SignUp_check.isValidEmail(email) {
            throw NSError(domain: "", code: -1,
                         userInfo: [NSLocalizedDescriptionKey: "올바른 이메일 형식이 아닙니다\n(예: example@domain.com)"])
        }
        
        if !SignUp_check.isValidPhoneNumber(tel) {
            throw NSError(domain: "", code: -1,
                         userInfo: [NSLocalizedDescriptionKey: "전화번호 형식이 올바르지 않습니다"])
        }
        
        let userData: [String: Any] = [
            "id": id,
            "password": password,
            "name": name,
            "companyName": companyName,
            "email": email,
            "tel": tel,
            "isAdmin": false
        ]
        
        try await Firestore.firestore()
            .collection("users")
            .addDocument(data: userData)
    }
}
