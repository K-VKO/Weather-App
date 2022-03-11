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
    
    
    enum CodingKeys: String, CodingKey {
        case weather
        case weatherNumbers = "main"
    }
}

struct Main: Decodable {
    var temp: Double
}

struct WeatherDescription: Decodable {
    var description: String
}
