//
//  MasterPiecePopupController.swift
//  ios_final
//
//  Created by ios프로젝트 on 6/17/24.
//

import UIKit

class MasterPiecePopupController: UIViewController {

    @IBOutlet weak var masterPieceImage: UIImageView!
    @IBOutlet weak var masterPieceName: UILabel!
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var productionYear: UILabel!
    @IBOutlet weak var materPieceDescription: UITextView!
    override func viewDidLoad() {
           super.viewDidLoad()
           //랜덤한 작품 정보를 가져옴
           fetchRandomMasterpiece()
       }
       
       func fetchRandomMasterpiece() {
           guard let url = URL(string: "http://15.164.219.39:8079/api/masterpieces/random") else {
               print("Invalid URL")
               return
           }
           
           URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
               guard let self = self else { return }
               
               if let error = error {
                   print("Error fetching random masterpiece: \(error)")
                   return
               }
               
               guard let data = data else {
                   print("No data received")
                   return
               }
               
               do {
                   let masterpiece = try JSONDecoder().decode(MasterPiece.self, from: data)
                   DispatchQueue.main.async {
                       self.updateUI(with: masterpiece)
                   }
               } catch {
                   print("Error decoding JSON: \(error)")
               }
           }.resume()
       }
       //Ui업데이트 함수
       func updateUI(with masterpiece: MasterPiece) {
           //이미지 넣기
           if let imageUrlString = masterpiece.imageUrl, let imageUrl = URL(string: imageUrlString) {
               downloadImage(from: imageUrl)
           }
           //작품 정보
           masterPieceName.text = masterpiece.title
           artist.text = "화가명: \(masterpiece.artist)"
           productionYear.text = "제작년도: \(masterpiece.yearOfCreation)"
           materPieceDescription.text = masterpiece.description
       }
       //이미지 다운로드 함수
       func downloadImage(from url: URL) {
           URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
               guard let self = self else { return }
               
               if let error = error {
                   print("Error downloading image: \(error)")
                   return
               }
               
               guard let data = data, let image = UIImage(data: data) else {
                   print("Invalid image data")
                   return
               }
               
               DispatchQueue.main.async {
                   self.masterPieceImage.image = image
               }
           }.resume()
       }
       
       /*
       // MARK: - Navigation

       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           // Prepare for navigation
       }
       */
   }
