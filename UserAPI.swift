import Foundation

struct User: Codable {
    let kakaoId: String
    let userName: String
    let userPassword: String
    let userAddress: String
    let dailyVisitCount: Int?
}

enum APIError: Error {
    case networkError
    case invalidResponse
    case serverError(String) // 서버에서 에러 메시지를 받을 경우
}

class UserAPI {
    static let shared = UserAPI()
    private let baseURL = "http://15.164.219.39:8079/api/users"
    
    private init() {}
    
    //유저 등록
    func registerUser(kakaoId: String, userName: String, userPassword: String, userAddress: String, completion: @escaping (Result<User, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/register")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let bodyData = "kakaoId=\(kakaoId)&userName=\(userName)&userPassword=\(userPassword)&userAddress=\(userAddress)"
        request.httpBody = bodyData.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(APIError.serverError("Server Error")))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.invalidResponse))
                return
            }
            
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    //유저 로그인
    func loginUser(kakaoId: String, userPassword: String, completion: @escaping (Result<User, Error>) -> Void) {
           let url = URL(string: "\(baseURL)/login")!
           var request = URLRequest(url: url)
           request.httpMethod = "POST"
           let bodyData = "kakaoId=\(kakaoId)&userPassword=\(userPassword)"
           request.httpBody = bodyData.data(using: .utf8)
           request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
           
           URLSession.shared.dataTask(with: request) { data, response, error in
               if let error = error {
                   completion(.failure(error))
                   return
               }
               
               guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                   completion(.failure(APIError.serverError("Server Error")))
                   return
               }
               
               guard let data = data else {
                   completion(.failure(APIError.invalidResponse))
                   return
               }
               
               do {
                   let user = try JSONDecoder().decode(User.self, from: data)
                   //서버 응답 데이터 출력-로그인 디버그
                   print("서버 응답 데이터: \(String(data: data, encoding: .utf8) ?? "데이터 없음")")
                   //파싱된 사용자 정보 출력-로그인 디버그
                   print("파싱된 사용자 정보: \(user)")
                   completion(.success(user))
               } catch {
                   completion(.failure(error))
               }
           }.resume()
       }
}
