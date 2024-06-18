//
//  CheerMessageAPI.swift
//  ios_final
//
//  Created by ios프로젝트 on 6/16/24.
//

//
//  CheerMessageAPI.swift
//  cheermessage
//
//  Created by ios프로젝트 on 6/16/24.
//
import Foundation

struct CheerMessage: Codable {
    let id: Int
    let messageContent: String
    let messageAddress: String
    let user: User // User 객체 포함
    var ddabongCount: Int?
    let messageDate: String?
}

class CheerMessageAPI {
    static let shared = CheerMessageAPI()
    private let baseURL = "http://15.164.219.39:8079/api/cheer-messages"

    private init() {}

    //해당 하는 동에 생성된 응원 메시지 전부 가져오기
    func findMessagesBySameDong(userAddress: String, completion: @escaping (Result<[CheerMessage], Error>) -> Void) {
        let url = URL(string: "\(baseURL)/find-messages?user_address=\(userAddress)")!
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
                let messages = try JSONDecoder().decode([CheerMessage].self, from: data)
                completion(.success(messages))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    //따봉 카운트 증가
    func increaseDdabongCount(messageId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/update-ddabong?message_id=\(messageId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                let error = NSError(domain: "", code: statusCode, userInfo: nil)
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }.resume()
    }

    //새로운 응원 메시지 등록
    func registerNewCheerMessage(kakaoId: String, messageContent: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/register")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let parameters = "kakao_id=\(kakaoId)&message_content=\(messageContent)"
        request.httpBody = parameters.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                let error = NSError(domain: "", code: statusCode, userInfo: nil)
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }.resume()
    }
}
