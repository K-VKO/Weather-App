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
    var weather: PublishSubject<LoadedWeather> { get }
    var article: PublishSubject<Article> { get }
    var cityNameToDisplay: PublishSubject<String> { get }
    var weatherUpdateDate: PublishSubject<String> { get }
    var isAccessDenied: PublishSubject<Bool> { get }
    
    func getUserLocationAndLoadWeather()
    func getWeatherUpdateDate()
    
    func loadArticle()
    func loadWeatherFromDB()
    func loadWeather(longtitude: Double, latitude: Double, completion: @escaping (LoadedWeather) -> Void)
}

final class MainVCCellViewModel: MainVCCellViewModelProtocol {
    var weather = PublishSubject<LoadedWeather>()
    var article = PublishSubject<Article>()
    var cityNameToDisplay = PublishSubject<String>()
    var weatherUpdateDate = PublishSubject<String>()
    var isAccessDenied = PublishSubject<Bool>()
    
    
    func loadWeather(longtitude: Double, latitude: Double, completion: @escaping (LoadedWeather) -> Void) {
        WeatherNetworkService.shared.loadWeather(longtitude: longtitude, latitude: latitude) { weather, error in
            guard error == nil else { return }
            if let weather = weather {
                completion(weather)
            }
        }
    }
    
    func getUserLocationAndLoadWeather() {
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
        CoreDataService.getWeatherFromDB {[weak self] grabbedWeather in
            guard let weather = grabbedWeather else { return }
            print("found weather: \(weather.current?.temp)")
//            self?.weather.onNext(weather)
        }
    }
    
    func getWeatherUpdateDate() {
        if let updateDate = UserDefaultsService.shared.getWeatherUpdateDate() {
            weatherUpdateDate.onNext(updateDate)
        }
    }
    
    init() {
        UserLocationService.shared.delegate = self
    }
}

extension MainVCCellViewModel: UserLocationServiceDelegate {
    func updatedLocation(longtitute: Double, latitude: Double, cityName: String?) {
        isAccessDenied.onNext(false)
        
        loadWeather(longtitude: longtitute, latitude: latitude) {[weak self] grabbedWeather in
            guard let cityName = cityName else { return }
            var weather = grabbedWeather
            weather.cityName = cityName
            
            self?.weather.onNext(weather)
            
            UserDefaultsService.shared.weatherUpdateDateChanged()
            self?.getWeatherUpdateDate()
            
            CoreDataService.saveCurrentWeatherToDB(weather: weather)
        }
        
    }
    
    func deniedLocationAccess() {
        isAccessDenied.onNext(true)
    }
}
