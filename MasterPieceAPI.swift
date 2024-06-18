//
//  MasterPieceAPI.swift
//  ios_final
//
//  Created by ios프로젝트 on 6/16/24.
//

//
//  MasterPieceAPI.swift
//  cheermessage
//
//  Created by ios프로젝트 on 6/16/24.
//

import Foundation

struct MasterPiece: Codable {
    let id: Int?
    let title: String
    let artist: String
    let yearOfCreation: Int
    let genre: String
    let description: String
    let imageUrl: String?
    let joayuCount: Int?
}

class MasterPieceAPI {
    static let shared = MasterPieceAPI()
    private let baseURL = "http://15.164.219.39:8079/api/masterpieces"

    private init() {}

    //무작위 명작 추천받기
    func getRandomMasterpiece(completion: @escaping (Result<MasterPiece, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/random")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
                return
            }
            do {
                let masterpiece = try JSONDecoder().decode(MasterPiece.self, from: data)
                completion(.success(masterpiece))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    //명작에 좋아요 처리
    func likeMasterpiece(masterpieceId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/\(masterpieceId)/like")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }.resume()
    }
}
