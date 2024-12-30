//
//  Singup_check.swift
//  Ad_Manager
//
//  Created by LrZl on 12/27/24.
//

// 유효성 검사
import Foundation

enum SignUp_check {
    static func isValidEmail(_ email: String) -> Bool {
        // @ 필수, .com/.net/.kr 등의 최상위 도메인 포함
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.(com|net|kr|org|co\\.kr)$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        // 기본 형식 검사
        guard emailPredicate.evaluate(with: email) else {
            return false
        }
        
        // 추가 검증
        let components = email.components(separatedBy: "@")
        guard components.count == 2,
              !components[0].isEmpty,
              !components[1].isEmpty,
              !email.contains(".."),
              !email.hasPrefix("."),
              !email.hasSuffix(".")
        else {
            return false
        }
        
        return true
    }

    static func isValidPassword(_ password: String) -> Bool {
        // 최소 4자리 검사
        guard password.count >= 4 else { return false }
        
        let numberRegex = "^[0-9]{4,}$" // 숫자만 4자리 이상
        let letterRegex = "^[A-Za-z]{4,}$" // 영문만 4자리 이상
        let letterNumberRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{4,}$" // 영문+숫자 조합
        let letterNumberSpecialRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[!@#$%^&*])[A-Za-z\\d!@#$%^&*]{4,}$" // 영문+숫자+특수문자 조합
        
        let numberPredicate = NSPredicate(format: "SELF MATCHES %@", numberRegex)
        let letterPredicate = NSPredicate(format: "SELF MATCHES %@", letterRegex)
        let letterNumberPredicate = NSPredicate(format: "SELF MATCHES %@", letterNumberRegex)
        let letterNumberSpecialPredicate = NSPredicate(format: "SELF MATCHES %@", letterNumberSpecialRegex)
        
        return numberPredicate.evaluate(with: password) ||
            letterPredicate.evaluate(with: password) ||
            letterNumberPredicate.evaluate(with: password) ||
            letterNumberSpecialPredicate.evaluate(with: password)
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
                            name: String, companyName: String, email: String, tel: String) -> Bool
    {
        guard !id.isEmpty,
              isValidPassword(password),
              doPasswordsMatch(password, confirmPassword),
              !name.isEmpty,
              !companyName.isEmpty, // 회사 이름은 빈 값만 아니면 됨
              isValidEmail(email),
              isValidPhoneNumber(tel)
        else {
            return false
        }
        return true
    }
}
