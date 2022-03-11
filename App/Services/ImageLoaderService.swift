//
//  ImageLoaderService.swift
//  App
//
//  Created by Константин Вороненко on 11.03.22.
//

import UIKit
import Alamofire


final class ImageLoaderService {
    static let shared = ImageLoaderService()
    
    private init() {}
    
    func loadImage(name: String, completion: @escaping (UIImage?) -> Void) {
        let url = "http://openweathermap.org/img/wn/\(name)@2x.png"
        
        AF.request(url,method: .get).response{ response in
            
            switch response.result {
            case .success(let responseData):
                let image = UIImage(data: responseData!, scale:1)
                DispatchQueue.main.async {
                    completion(image)
                }
                
            case .failure(let error):
                print("error--->",error)
            }
        }
    }
}
