//
//  Singup_check.swift
//  Ad_Manager
//
//  Created by LrZl on 12/27/24.
//

// 유효성 검사
import Foundation

struct SignUp_check {
    static func isValidEmail(_ email: String) -> Bool {
        // 간단히 @와 .com만 포함되어 있는지 확인
        return email.contains("@") && email.contains(".com")
    }
    
    static func isValidPassword(_ password: String) -> Bool {
        // 기존 비밀번호 검증 유지
        guard password.count >= 4 else { return false }
        
        let numberSequences = ["1234", "2345", "3456", "4567", "5678", "6789", "0123"]
        for sequence in numberSequences {
            if password.contains(sequence) {
                return false
            }
        }
        
        let passwordRegex = "^(?=.*[0-9])(?=.*[!@#$%^&*])[0-9!@#$%^&*]{4,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    
    static func isValidPhoneNumber(_ number: String) -> Bool {
        // 숫자만 추출
        let digits = number.filter { $0.isNumber }
        // 9~11자리 숫자인지 확인
        return digits.count >= 9 && digits.count <= 11
    }
    
    static func doPasswordsMatch(_ password: String, _ confirmPassword: String) -> Bool {
        return password == confirmPassword
    }
    
    static func isValidForm(id: String, password: String, confirmPassword: String,
                           name: String, companyName: String, email: String, tel: String) -> Bool {
        guard !id.isEmpty,
              isValidPassword(password),
              doPasswordsMatch(password, confirmPassword),
              !name.isEmpty,
              !companyName.isEmpty, // 회사 이름은 빈 값만 아니면 됨
              isValidEmail(email),
              isValidPhoneNumber(tel) else {
            return false
        }
        return true
    }
}
