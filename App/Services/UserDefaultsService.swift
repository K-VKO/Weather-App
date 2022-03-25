//
//  UserDefaultsService.swift
//  App
//
//  Created by Константин Вороненко on 22.03.22.
//
import Foundation


enum CurrentDate: String {
    case weatherUpdateDate = "weatherUpdateDate"
}

final class UserDefaultsService {
    static let shared = UserDefaultsService()
    
    private init() {}
    
    let defaults = UserDefaults.standard
    
    lazy var currentDateAndTime: String = {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "MM/dd HH:mm"
        let formattedDate = format.string(from: date)
        
        return formattedDate
    }()
    

    
    func weatherUpdateDateChanged() {
        defaults.set(currentDateAndTime, forKey: CurrentDate.weatherUpdateDate.rawValue)
    }
    
    func getWeatherUpdateDate() -> String? {
        return defaults.object(forKey: CurrentDate.weatherUpdateDate.rawValue) as? String
    }
}
