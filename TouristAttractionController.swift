//
//  TouristAttractionController.swift
//  ios_final
//
//  Created by ios프로젝트 on 6/17/24.
//

import UIKit

class TouristAttractionController: UIViewController {

    @IBOutlet weak var touristImage: UIImageView!
    
    @IBOutlet weak var touristDescription: UITextView!
    
    @IBOutlet weak var attractionName: UILabel!
    
    @IBOutlet weak var guName: UILabel!
    
    @IBOutlet weak var joayoCount: UILabel!
    
    var touristAttractionAPI = TouristAttractionAPI.shared
        var selectedGu: String?
        var currentTouristAttraction: TouristAttraction?

        override func viewDidLoad() {
            super.viewDidLoad()

            //요청하는 구가 존재하는 구에 해당하면 API요청
            if let selectedGu = selectedGu {
                getTouristAttraction(for: selectedGu)
            }
        }
    
    
    @IBAction func joayoClick(_ sender: UIButton) {
        guard let seoulGu = currentTouristAttraction?.seoulGu else {
                   print("Error: No tourist attraction selected")
                   return
               }
                //API요청을 통한 좋아요 카운트 증가
               touristAttractionAPI.increaseJoayuCount(seoulGu: seoulGu) { [weak self] result in
                   switch result {
                   case .success(let updatedAttraction):
                       DispatchQueue.main.async {
                           self?.currentTouristAttraction = updatedAttraction
                           self?.updateUI(with: updatedAttraction)
                       }
                   case .failure(let error):
                       print("Failed to increase joayu count: \(error.localizedDescription)")
                   }
               }
    }
    
    //해당 구의 명소 정보 get
    func getTouristAttraction(for gu: String) {
           touristAttractionAPI.getTouristAttraction(seoulGu: gu) { [weak self] result in
               switch result {
               case .success(let attraction):
                   DispatchQueue.main.async {
                       self?.currentTouristAttraction = attraction
                       self?.updateUI(with: attraction)
                   }
               case .failure(let error):
                   print("Failed to fetch tourist attraction: \(error.localizedDescription)")
               }
           }
       }
        //해당 명소 정보 UI업데이트
       func updateUI(with attraction: TouristAttraction) {
           attractionName.text = attraction.name
           guName.text = attraction.seoulGu
           touristDescription.text = attraction.description
           joayoCount.text = "좋아요 수: \(attraction.joayuCount)"

           // 이미지 로드
           if let imageUrl = URL(string: attraction.imageUrl) {
               downloadImage(from: imageUrl)
           }
       }
        // URL에서 이미지 다운로드하여 표시

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
                   self.touristImage.image = image
               }
           }.resume()
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
