//
//  TouristAttractionAPI.swift
//  ios_final
//
//  Created by ios프로젝트 on 6/17/24.
//

import Foundation

struct TouristAttraction: Codable {
    let seoulGu: String
    let name: String
    let location: String
    let description: String
    let imageUrl: String
    var joayuCount: Int
}

class TouristAttractionAPI {
    static let shared = TouristAttractionAPI()
    private let baseURL = "http://15.164.219.39:8079/api/touristattraction"

    private init() {}

    func getTouristAttraction(seoulGu: String, completion: @escaping (Result<TouristAttraction, Error>) -> Void) {
        let urlString = "\(baseURL)/get-gu-tourist?seoul_gu=\(seoulGu)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            do {
                let touristAttraction = try JSONDecoder().decode(TouristAttraction.self, from: data)
                completion(.success(touristAttraction))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func increaseJoayuCount(seoulGu: String, completion: @escaping (Result<TouristAttraction, Error>) -> Void) {
        let urlString = "\(baseURL)/increase-joayo?seoul_gu=\(seoulGu)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            do {
                let updatedTouristAttraction = try JSONDecoder().decode(TouristAttraction.self, from: data)
                completion(.success(updatedTouristAttraction))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
