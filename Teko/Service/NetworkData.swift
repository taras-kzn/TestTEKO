//
//  NetworkData.swift
//  Teko
//
//  Created by admin on 19.08.2021.
//

import Foundation

class NetworkData {
//MARK: - Properties
    private var networkService = NetworkService()
//MARK: - Functions
    func fethImages(completion: @escaping (DataUrl?) -> ()) {
        networkService.request { (data, error) in
            if let error = error {
                print("error request data: \(error.localizedDescription) ")
                
                completion(nil)
            }
            
            let decode = self.decodeJson(type: DataUrl.self, from: data)
            completion(decode)
        }
    }
    
    private func decodeJson<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else { return nil }
        
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let jsonError {
            print("error decode json", jsonError)
            return nil
        }
    }
}
