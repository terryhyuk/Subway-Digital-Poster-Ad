//
//  ViewController.swift
//  Ad-Project
//
//  Created by Seong Yeob Yoon on 12/27/24.
//

import UIKit
import Firebase
import FirebaseFirestore

class ViewController: UIViewController {
    
    @IBOutlet weak var Dropdownbutton: UIButton!
    
    @IBOutlet weak var publicbutton: UIButton!
    @IBOutlet weak var privatebutton: UIButton!
    
    @IBOutlet weak var tvtitle: UITextView!
    @IBOutlet weak var tvcontents: UITextView!
    
    var isPublic : Bool = true
    
    let options = ["강남", "잠실", "홍대입구"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupDropdownButton()
        setupRadioButtons()
    }
    
    func setupDropdownButton() {
        let OptionClosure = {(action: UIAction) in self.Dropdownbutton.setTitle(action.title, for: .normal)}
        
        Dropdownbutton.menu = UIMenu(children : options.map { option in UIAction(title: option, state: .off, handler: OptionClosure)})
        
        Dropdownbutton.showsMenuAsPrimaryAction = true
        Dropdownbutton.changesSelectionAsPrimaryAction = true
    }
    
    // 라디오 버튼 형태로 만들어주기
    func setupRadioButtons() {
        publicbutton.setImage(UIImage(systemName: "circle"), for: .normal)
        publicbutton.setImage(UIImage(systemName: "circle.fill"), for: .selected)
        privatebutton.setImage(UIImage(systemName: "circle"), for: .normal)
        privatebutton.setImage(UIImage(systemName: "circle.fill"), for: .selected)
        
        updateRadioButtons()
    }
    
    // 라디오 버튼 선택 여부
    func updateRadioButtons() {
        publicbutton.isSelected = isPublic
        privatebutton.isSelected = !isPublic
    }
    
    @IBAction func publicbuttontap(_ sender: UIButton) {
        isPublic = true
        updateRadioButtons()
    }
    
    @IBAction func privatebuttontap(_ sender: UIButton) {
        isPublic = false
        updateRadioButtons()
    }
    
    @IBAction func btnsubmit(_ sender: UIButton) {
//      saveDataToFirebase()
        
        if (tvtitle.text.isEmpty || tvcontents.text.isEmpty || Dropdownbutton.titleLabel?.text?.isEmpty ?? true) {
            let alert = UIAlertController(title: "경고", message: "빈칸을 채워주세요!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // Alert창
        let alert = UIAlertController(title: "문의하기", message: "문의하시겠습니까 ?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "예", style: .default, handler: {_ in self.saveDataToFirebase()
        
            let confirmationAlert = UIAlertController(title: "문의완료", message: "최대한 빠른 시일내에 연락드리겠습니다!", preferredStyle: .alert)
            confirmationAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            
            self.present(confirmationAlert, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "아니오", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btncancel(_ sender: UIButton) {
        
        let cancelAlert = UIAlertController(title: "취소", message: "작성을 취소하시겠습니까 ?", preferredStyle: .alert)
        cancelAlert.addAction(UIAlertAction(title: "예", style: .default, handler: {
            _ in
            self.clearFields()
        }))
        
        cancelAlert.addAction(UIAlertAction(title: "아니오", style: .cancel, handler: nil))
        
        self.present(cancelAlert, animated: true, completion: nil)
    }
    
    // 파이어베이스에 저장할 데이터들 변수 생성
    func saveDataToFirebase() {
        guard let title = tvtitle.text, !title.isEmpty,
              let contents = tvcontents.text, !contents.isEmpty,
              let selectedStation = Dropdownbutton.titleLabel?.text
        else {
            print("모든 필드를 입력해주세요.")
            return
        }
        
        let author = "author"
   
        // 데이터 베이스 인스턴스
        let db = Firestore.firestore()
        
        // 보낼 데이터 목록
        let post : [String : Any] = [
            "author" : author,
            "title" : title,
            "contents" : contents,
            "station" : selectedStation,
            "isPublic" : isPublic,
            "writeTime" : FieldValue.serverTimestamp(),
            "isAnswer" : false
        ]
        
        // 필드 생성
        db.collection("post").addDocument(data: post) {
            error in if let error = error {
                print("데이터 저장 실패: \(error.localizedDescription)")
            } else {
                print("데이터가 성공적으로 저장되었습니다.")
                self.clearFields()
            }
        }
        
    }
    
    func clearFields() {
        tvtitle.text = ""
        tvcontents.text = ""
        Dropdownbutton.setTitle(options[0], for: .normal)
        isPublic = true
        updateRadioButtons()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
