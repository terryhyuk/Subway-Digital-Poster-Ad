//
//  singup.swift
//  Ad_Manager
//
//  Created by LrZl on 12/27/24.
//

import Foundation
import FirebaseFirestore
import FirebaseCore

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
        
        // Firebase에서 ID 중복 체크
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
        isLoading = true  // 로딩 상태 추가
        defer { isLoading = false }
        
        // ID 중복 체크 확인
        guard isIdAvailable else {
            throw NSError(domain: "", code: -1,
                          userInfo: [NSLocalizedDescriptionKey: "ID 중복 체크를 해주세요"])
        }
        
        // 유효성 검사
        guard SignUp_check.isValidForm(id: id, password: password,
                                       confirmPassword: password,
                                       name: name, companyName: companyName,
                                       email: email, tel: tel) else {
            throw NSError(domain: "", code: -1,
                          userInfo: [NSLocalizedDescriptionKey: "입력 정보를 확인해주세요"])
        }
        
        // Firestore에 데이터 저장
        let userData: [String: Any] = [
            "id": id,
            "password": password,
            "name": name,
            "companyName": companyName,
            "email": email,
            "tel": tel,
            "isAdmin": false
        ]
        
        // addDocument를 사용하여 자동 ID 생성
        try await Firestore.firestore()
            .collection("users")
            .addDocument(data: userData)
    }
}
