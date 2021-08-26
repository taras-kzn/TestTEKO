//
//  NetworkService.swift
//  Teko
//
//  Created by admin on 18.08.2021.
//

import Foundation

class NetworkService {
//MARK: - Functions
    func request(completion: @escaping (Data?, Error?) -> Void) {
        let parametrs = self.parametrs()
        let url = self.url(params: parametrs)
        var request = URLRequest(url: url)
        request.httpMethod = "get"
        let task = createDataTask(from: request, completion: completion)
        task.resume()
        
    }
    
    private func parametrs() -> [String: String] {
        var parameters = [String: String]()
        parameters["api_key"] = "HYDgHIhvoo31ira7TgeLxNoy8eJi4Ijh"
        parameters["limit"] = String(24)
       parameters["random_id"] = "6XE1zYTNiofDW1bNXr"
        return parameters
    }
    
    private func url(params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.giphy.com"
        components.path = "/v1/gifs/trending"
        components.queryItems = params.map({ URLQueryItem(name: $0, value: $1) })
        return components.url!
    }
    
    private func createDataTask(from request: URLRequest,  completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
}
