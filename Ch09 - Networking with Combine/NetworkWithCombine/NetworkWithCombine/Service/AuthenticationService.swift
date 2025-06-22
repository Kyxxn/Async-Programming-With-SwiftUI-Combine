import Foundation
import Combine
import UIKit

// 사용자 이름 사용 가능 여부 응답 모델
struct UserNameAvailableMessage: Codable {
    var isAvailable: Bool
    var userName: String
}

// 네트워크 관련 오류 정의
enum NetworkError: Error {
    case transportError(Error)               // 네트워크 전송 오류
    case serverError(statusCode: Int)        // HTTP 상태 코드 오류
    case noData                              // 응답 데이터 없음
    case decodingError(Error)                // 디코딩 실패
    case encodingError(Error)                // 인코딩 실패
}

class AuthenticationService {
    
    /// 1: Combine 없이 URLSession을 직접 사용하여 사용자 이름 중복 확인
    func checkUserNameAvailableWithClosure(userName: String, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        let url = URL(string: "http://127.0.0.1:8080/isUserNameAvailable?userName=\(userName)")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // 네트워크 오류 처리
            if let error = error {
                completion(.failure(.transportError(error)))
                return
            }
            
            // 서버 상태 코드 확인
            if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                completion(.failure(.serverError(statusCode: response.statusCode)))
                return
            }
            
            // 데이터 없음 처리
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            // JSON 디코딩 시도
            do {
                let decoder = JSONDecoder()
                let userAvailableMessage = try decoder.decode(UserNameAvailableMessage.self, from: data)
                completion(.success(userAvailableMessage.isAvailable))
            }
            catch {
                completion(.failure(.decodingError(error)))
            }
        }
        
        task.resume()
    }
    
    /// 2: 위 메서드와 동일한 동작을 Combine을 이용해 단순하게 구현한 버전 (아직 최적화되지 않음)
    func checkUserNameAvailableNaive(userName: String) -> AnyPublisher<Bool, Never> {
        guard let url = URL(string: "http://127.0.0.1:8080/isUserNameAvailable?userName=\(userName)") else {
            return Just(false).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { data, response in
                do {
                    let decoder = JSONDecoder()
                    let userAvailableMessage = try decoder.decode(UserNameAvailableMessage.self, from: data)
                    return userAvailableMessage.isAvailable
                }
                catch {
                    return false
                }
            }
            .replaceError(with: false)
            .eraseToAnyPublisher()
    }
    
    /// 3: Combine의 기능을 적극 활용해 사용자 이름 중복 확인을 구현한 최종 버전
    func checkUserNameAvailable(userName: String) -> AnyPublisher<Bool, Never> {
        guard let url = URL(string: "http://127.0.0.1:8080/isUserNameAvailable?userName=\(userName)") else {
            return Just(false).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data) // 응답 데이터만 추출
            .decode(type: UserNameAvailableMessage.self, decoder: JSONDecoder()) // JSON -> 모델 디코딩
            .map(\.isAvailable) // 사용 가능 여부만 추출
            .replaceError(with: false) // 실패 시 false 반환
            .eraseToAnyPublisher()
    }
}
