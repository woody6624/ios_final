//
//  LoginController.swift
//  ios_final
//
//  Created by ios프로젝트 on 6/16/24.
//

import UIKit

class LoginController: UIViewController {
    
    @IBOutlet weak var kakaoIdTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    var isRequestInProgress = false

    @IBAction func loginBtnClicked(_ sender: UIButton) {
        guard let kakaoId = kakaoIdTextField.text, !kakaoId.isEmpty,
                      let password = passwordTextField.text, !password.isEmpty else {
                    showAlert(message: "아이디와 비밀번호를 모두 입력해주세요.")
                    return
                }
                
                //네트워크에 대한 중복 요청 방지 후 요청 시작
                if isRequestInProgress {
                    return
                }
                isRequestInProgress = true
                loginButton.isEnabled = false
                
                UserAPI.shared.loginUser(kakaoId: kakaoId, userPassword: password) { result in
                    DispatchQueue.main.async {
                        self.isRequestInProgress = false
                        self.loginButton.isEnabled = true
                        
                        switch result {
                        case .success(let user):
                            UserSession.shared.loginUser(user: user)
                            
                        
                            
                            self.performLoginSuccess()
                            self.clearTextFields()
                        case .failure(let error):
                            self.showLoginErrorAlert(message: "로그인에 실패했습니다. 다시 시도해주세요.")
                            print("Login error: \(error.localizedDescription)")
                        }
                    }
                }
            }

            private func showAlert(message: String) {
                let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                    self.clearTextFields()
                }))
                self.present(alert, animated: true, completion: nil)
            }
            private func showLoginErrorAlert(message: String) {
                if let presentedViewController = presentedViewController {
                    presentedViewController.dismiss(animated: true) {
                        self.presentLoginErrorAlert(message: message)
                    }
                } else {
                    presentLoginErrorAlert(message: message)
                }
            }
            private func presentLoginErrorAlert(message: String) {
                let alert = UIAlertController(title: "로그인 실패", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }

            private func clearTextFields() {
                kakaoIdTextField.text = ""
                passwordTextField.text = ""
            }

            private func performLoginSuccess() {
                //홈 컨트롤러 로그인 에러로 인한 디버그에서 해준 해결책
                //홈 컨트롤러가 이미 실행 중인지 체크
                if presentedViewController is HomeController {
                    print("이미 HomeController가 표시되고 있습니다.")
                    return
                }
                //홈 컨트롤러를 인스턴스화에 표현
                if let homeController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeController") as? HomeController {
                    homeController.modalPresentationStyle = .fullScreen
                    present(homeController, animated: true, completion: nil)
                } else {
                    print("HomeController를 찾을 수 없습니다.")
                }
            }

        }
