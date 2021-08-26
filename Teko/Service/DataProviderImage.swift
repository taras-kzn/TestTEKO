//
//  DataProvider.swift
//  Teko
//
//  Created by admin on 23.08.2021.
//

import UIKit

class DataProviderImage {
//MARK: Properties
    private var imageCashe = NSCache<NSString, UIImage>()
//MARK: - Function
    func dowlandImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        
        if let casheImage = imageCashe.object(forKey: url.absoluteString as NSString) {
            completion(casheImage)
        } else {
            let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 0)
            let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                guard error == nil,
                      data != nil,
                      let response = response as? HTTPURLResponse,
                      response.statusCode == 200,
                      let self = self else { return }
                guard let imageTest = UIImage.gifImageWithData(data!) else { return }
                
                self.imageCashe.setObject(imageTest, forKey: url.absoluteString as NSString)
                
                DispatchQueue.main.async {
                    completion(imageTest)
                }
            }
            dataTask.resume()
        }
    }
}
