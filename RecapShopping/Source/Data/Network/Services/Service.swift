//
//  Service.swift
//  RecapShopping
//
//  Created by 이병현 on 2023/09/10.
//

import Foundation
import Combine

protocol Service {
    func request<T: Decodable>(target: TargetType, type: T.Type) -> AnyPublisher<T, NetworkError>
}

final class ServiceImpl: Service {
    
    static let shared = ServiceImpl()
    
    private let session: URLSession
    
    private init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<T: Decodable>(target: TargetType, type: T.Type) -> AnyPublisher<T, NetworkError> {
        print(target.request)
        print(target.request.url!)
        return session.dataTaskPublisher(for: target.request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw URLError(.unknown)
                }
                print("📭 Request \(target.request.url!)")
                print("🚩 Response \(httpResponse.statusCode)")
                
                switch httpResponse.statusCode {
                case 200..<300:
                    print("✅ Success", data)
                    return data
                case 400..<500:
                    print("❌ Failure", String(data: data, encoding: .utf8)!)
                    throw NetworkError.clientError
                case 500..<599:
                    print("❌ Failure", String(data: data, encoding: .utf8)!)
                    throw NetworkError.serverError
                case _:
                    print("❌ Failure", String(data: data, encoding: .utf8)!)
                    throw NetworkError.internalError
                }
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .map { $0 }
            .mapError { $0 as! NetworkError }
            .eraseToAnyPublisher()
    }
    
}
