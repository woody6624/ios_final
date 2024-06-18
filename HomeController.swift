//
//  HomeController.swift
//  ios_final
//
//  Created by ios프로젝트 on 6/16/24.
//

import UIKit

class HomeController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var guLabel: UILabel!
    @IBAction func logoutBtn(_ sender: UIButton) {
        UserSession.shared.logout()
        navigateToLogin()
    }
    @IBOutlet weak var addcheerMessage: UIButton!
    @IBOutlet weak var hopeMessageTableView: UITableView!
    //응원 메시지 배열
    var cheerMessages: [CheerMessage] = []
    //사용자 이름
    var nameLabel: UILabel?
    //응원 메시지 추가 버튼 클릭
    @IBAction func addCheerBtn(_ sender: UIButton) {
        showAddCheerMessageAlert()

    }
    
    override func viewDidLoad() {
            super.viewDidLoad()
            hopeMessageTableView.delegate = self
            hopeMessageTableView.dataSource = self
            hopeMessageTableView.register(UITableViewCell.self, forCellReuseIdentifier: "CheerMessageCell")
        }

        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            //뷰가 나타날떄 사용자의 이름과 응원 메시지들을 출력
            showUserName()
            loadCheerMessages()
            showGu()
        }
    
    
        private func showGu(){
            guLabel.text=UserSession.shared.currentUser?.userAddress
        }
        
        //사용자 이름 표시 함수
        private func showUserName() {
            nameLabel?.removeFromSuperview()
                
            //라벨 생성 후 이름 표시
            if let userName = UserSession.shared.currentUser?.userName {
                let label = UILabel()
                label.text = "안녕하세요 \(userName) 님"
                label.textColor = .white
                label.textAlignment = .center
                label.backgroundColor = .blue //
                label.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(label)

                //화면에 표시를 위한 콘스트레인트
                NSLayoutConstraint.activate([
                    label.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
                    label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    label.heightAnchor.constraint(equalToConstant: 50)
                ])

                nameLabel = label

                //3초만 누군지보여줌
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.hideUserName()
                }
            } else {
                showAlert(message: "사용자 정보를 가져올 수 없습니다.")
            }
        }

        private func hideUserName() {
            nameLabel?.removeFromSuperview()
            nameLabel = nil
        }

        func loadCheerMessages() {
            guard let userAddress = UserSession.shared.currentUser?.userAddress else {
                showAlert(message: "사용자 주소 정보를 가져올 수 없습니다.")
                return
            }
            
            CheerMessageAPI.shared.findMessagesBySameDong(userAddress: userAddress) { [weak self] result in
                switch result {
                case .success(let messages):
                    DispatchQueue.main.async {
                        self?.cheerMessages = messages
                        //응원메시지 소팅
                        self?.cheerMessages.sort { $0.ddabongCount ?? 0 > $1.ddabongCount ?? 0 }
                        self?.hopeMessageTableView.reloadData()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.showAlert(message: "아직 아무도 작성하지 않았어요!")
                    }
                }
            }
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return cheerMessages.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheerMessageCell", for: indexPath)
            
            let message = cheerMessages[indexPath.row]
            
            
            for subview in cell.contentView.subviews {
                subview.removeFromSuperview()
            }
            
            //테이블 내부에 들어갈 셀
            let messageLabel = UILabel(frame: CGRect(x: 16, y: 8, width: cell.contentView.bounds.width - 32, height: 20))
            messageLabel.text = message.messageContent
            messageLabel.textColor = .black
            messageLabel.font = UIFont.systemFont(ofSize: 16)
            cell.contentView.addSubview(messageLabel)
            
            let ddabongLabel = UILabel(frame: CGRect(x: 16, y: 32, width: cell.contentView.bounds.width - 32, height: 16))
            ddabongLabel.text = "\(message.ddabongCount ?? 0) 개의 따봉"
            ddabongLabel.textColor = .gray
            ddabongLabel.font = UIFont.systemFont(ofSize: 12)
            cell.contentView.addSubview(ddabongLabel)
            
            return cell
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let message = cheerMessages[indexPath.row]
            increaseDdabongCount(messageId: message.id)
        }
        //따봉 카운트 업!
        private func increaseDdabongCount(messageId: Int) {
            CheerMessageAPI.shared.increaseDdabongCount(messageId: messageId) { [weak self] result in
                switch result {
                case .success:
                    self?.loadCheerMessages() //
                case .failure(let error):
                    print("Failed to update ddabong count: \(error.localizedDescription)")
                }
            }
        }
        //응원 메시지 추가
        @objc private func showAddCheerMessageAlert() {
            let alertController = UIAlertController(title: "응원 메시지 추가", message: "응원 메시지를 입력하세요.", preferredStyle: .alert)
            alertController.addTextField { textField in
                textField.placeholder = "메시지 내용"
            }
            
            let addAction = UIAlertAction(title: "추가", style: .default) { [weak self] _ in
                if let messageContent = alertController.textFields?.first?.text, !messageContent.isEmpty {
                    self?.registerNewCheerMessage(messageContent: messageContent)
                } else {
                    self?.showAlert(message: "메시지를 입력하세요.")
                }
            }
            
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            
            alertController.addAction(addAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        }

        private func registerNewCheerMessage(messageContent: String) {
            guard let kakaoId = UserSession.shared.currentUser?.kakaoId else {
                showAlert(message: "카카오 ID를 가져올 수 없습니다.")
                return
            }

            CheerMessageAPI.shared.registerNewCheerMessage(kakaoId: kakaoId, messageContent: messageContent) { [weak self] result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        self?.showAlert(message: "응원 메시지가 성공적으로 추가되었습니다.")
                        self?.loadCheerMessages()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.showAlert(message: "응원 메시지 추가 실패: \(error.localizedDescription)")
                    }
                }
            }
        }

        private func showAlert(message: String) {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                if let presentedViewController = self.presentedViewController {
                    presentedViewController.dismiss(animated: true) {
                        self.present(alert, animated: true, completion: nil)
                    }
                } else {
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        private func navigateToLogin() {
                if let loginController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginController") as? LoginController {
                    loginController.modalPresentationStyle = .fullScreen
                    present(loginController, animated: true, completion: nil)
                } else {
                    print("LoginController를 찾을 수 없습니다.")
                }
            }
    }
