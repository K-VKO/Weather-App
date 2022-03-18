//
//  MainVCCellViewModel.swift
//  App
//
//  Created by Константин Вороненко on 15.03.22.
//
import UIKit
import RxSwift
import RxCocoa

protocol MainVCCellViewModelProtocol {
    var weather: PublishSubject<Weather> { get }
    var article: PublishSubject<Article> { get }
    var cityNameToDisplay: PublishSubject<String> { get }
    
    func getUserLocation()
    
    func loadArticle()
    func loadWeatherFromDB()
    func loadWeather(longtitude: Double, latitude: Double, completion: @escaping (Weather) -> Void)
}

final class MainVCCellViewModel: MainVCCellViewModelProtocol {
    var weather = PublishSubject<Weather>()
    var article = PublishSubject<Article>()
    var cityNameToDisplay = PublishSubject<String>()
    
    
    func loadWeather(longtitude: Double, latitude: Double, completion: @escaping (Weather) -> Void) {
        WeatherNetworkService.shared.loadWeather(longtitude: longtitude, latitude: latitude) { weather, error in
            guard error == nil else { return }
            if let weather = weather {
//                self?.weather.onNext(weather)
                completion(weather)
            }
        }
    }
    func getUserLocation() {
        UserLocationService.shared.getUserLocation()
    }
    func loadArticle() {
        NewsNetworkService.shared.loadArticle { [weak self] grabbedArticle, error in
            guard error == nil else { return }
            if let grabbedArticle = grabbedArticle {
                self?.article.onNext(grabbedArticle)
            }
        }
    }
    

    
    func loadWeatherFromDB() {
        CoreDataService.getCurrentWeatherFromDB {[weak self]  weatherDB in
            if let weatherDB = weatherDB,
               let weatherDescription = weatherDB.weatherDescription,
               let icon = weatherDB.icon {
                let weatherDescription = WeatherDescription(description: weatherDescription, icon: icon)
                let main = Main(temp: 18.9)
                let weather = Weather(weather: [weatherDescription], weatherNumbers: main, cityName: weatherDB.cityName)
                self?.weather.onNext(weather)
            }
        }
    }
    
    init() {
        UserLocationService.shared.delegate = self
    }
}

extension MainVCCellViewModel: UserLocationServiceDelegate {
    func updatedLocation(longtitute: Double, latitude: Double, cityName: String?) {
        loadWeather(longtitude: longtitute, latitude: latitude) {[weak self] grabbedWeather in
            guard let cityName = cityName else { return }
            var weather = grabbedWeather
            weather.cityName = cityName
            self?.weather.onNext(weather)
            CoreDataService.saveCurrentWeatherToDB(weather: weather)
        }
        
    }
}
