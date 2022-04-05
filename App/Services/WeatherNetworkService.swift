//
//  WeatherNetworkService.swift
//  App
//
//  Created by Константин Вороненко on 11.03.22.
//

import Foundation
import Alamofire

//https://api.openweathermap.org/data/2.5/onecall?lat=51&lon=51&exclude=daily,minutely,alerts&appid=cf1866fe88f904ceafead4524782325c&units=metric


final class WeatherNetworkService {
    static let shared = WeatherNetworkService()
    
    private init() {}
    
    func loadWeather(longtitude: Double, latitude: Double, completion: @escaping (LoadedWeather?, Error?) -> Void) {
        let longtitudeInt = Int(longtitude)
        let latitudeInt = Int(latitude)
        let url = "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitudeInt)&lon=\(longtitudeInt)&exclude=daily,minutely,alerts&appid=cf1866fe88f904ceafead4524782325c&units=metric"
        
        
        AF.request(url).responseDecodable(of: LoadedWeather.self) { response in
            guard let weather = response.value else {
                print("error: \(String(describing: response.error))")
                completion(nil, response.error)
                return
            }
            completion(weather, nil)
        }
    }
    
}
