//
//  WeatherNetworkService.swift
//  App
//
//  Created by Константин Вороненко on 11.03.22.
//

import Foundation
import Alamofire


final class WeatherNetworkService {
    static let shared = WeatherNetworkService()
    
    private init() {}
    
    func loadWeather(longtitude: Double, latitude: Double, completion: @escaping (Weather?, Error?) -> Void) {
        let longtitudeInt = Int(longtitude)
        let latitudeInt = Int(latitude)
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitudeInt)&lon=\(longtitudeInt)&appid=cf1866fe88f904ceafead4524782325c&units=metric"
        
        
        AF.request(url).responseDecodable(of: Weather.self) { response in
            guard let weather = response.value else {
                print("error: \(String(describing: response.error))")
                completion(nil, response.error)
                return
            }
            completion(weather, nil)
        }
    }
}
