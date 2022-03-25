//
//  Weather.swift
//  App
//
//  Created by Константин Вороненко on 10.03.22.
//

import UIKit

struct Weather: Decodable {
    var weather: [WeatherDescription]
    var weatherNumbers: Main
    var cityName: String?
    
    
    enum CodingKeys: String, CodingKey {
        case weather
        case weatherNumbers = "main"
        case cityName
    }
}

struct Main: Decodable {
    var temp: String?
    
    enum CodingKeys: String, CodingKey {
        case temp
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        temp = try "\(Int(container.decode(Double.self, forKey: .temp)))"
    }
    
    init() {
        self.temp = nil
    }
}

struct WeatherDescription: Decodable {
    var description: String
    var icon: String
}
