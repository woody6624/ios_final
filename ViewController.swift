//
//  ViewController.swift
//  ios_final
//
//  Created by ios프로젝트 on 6/16/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var kakaoIdTextField: UITextField!
    
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var userAddressPickerView: UIPickerView!
    let locations = ["강남구", "강동구", "강북구", "강서구", "관악구", "광진구", "구로구", "금천구", "노원구", "도봉구", "동대문구",
                     "동작구", "마포구", "서대문구", "서초구", "성동구", "성북구", "송파구", "양천구", "영등포구", "용산구", "은평구",
                     "종로구", "중구", "중랑구"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userAddressPickerView.delegate = self
        self.userAddressPickerView.dataSource = self
    }
    
    @IBAction func registerUserBtn(_ sender: UIButton) {
        guard let kakaoId = kakaoIdTextField.text, !kakaoId.isEmpty,
                     let userName = userNameTextField.text, !userName.isEmpty,
                     let userPassword = userPasswordTextField.text, !userPassword.isEmpty else {
                   displayAlert(message: "모든 필드를 입력해주세요.")
                   return
               }
               
               let selectedRow = userAddressPickerView.selectedRow(inComponent: 0)
               let userAddress = locations[selectedRow]
               
               // 유저 등록 API 호출
               UserAPI.shared.registerUser(kakaoId: kakaoId, userName: userName, userPassword: userPassword, userAddress: userAddress) { result in
                   DispatchQueue.main.async {
                       switch result {
                       case .success(let user):
                           self.displayAlert(message: "\(user.userName)님, 회원가입이 성공적으로 완료되었습니다.")
                           
                       case .failure(let error):
                           self.displayAlert(message: "회원가입 실패: \(error.localizedDescription)")
                       }
                   }
               }
           }
           
           func displayAlert(message: String) {
               let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
               present(alert, animated: true, completion: nil)
           }
       }

       extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
           func numberOfComponents(in pickerView: UIPickerView) -> Int {
               return 1
           }
           
           func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
               return locations.count
           }
           
           func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
               return locations[row]
           }
       }
