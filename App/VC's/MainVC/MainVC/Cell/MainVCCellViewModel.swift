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
    func loadWeather(longtitude: Double, latitude: Double)
}

final class MainVCCellViewModel: MainVCCellViewModelProtocol {
    var weather = PublishSubject<Weather>()
    var article = PublishSubject<Article>()
    var cityNameToDisplay = PublishSubject<String>()
    
    
    func loadWeather(longtitude: Double, latitude: Double) {
        WeatherNetworkService.shared.loadWeather(longtitude: longtitude, latitude: latitude) { [weak self] weather, error in
            guard error == nil else { return }
            if let weather = weather {
                self?.weather.onNext(weather)
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
    
    func saveCurrentWeatherToDB() {
        
    }
    
    init() {
        UserLocationService.shared.delegate = self
    }
}

extension MainVCCellViewModel: UserLocationServiceDelegate {
    func updatedLocation(longtitute: Double, latitude: Double, cityName: String?) {
        loadWeather(longtitude: longtitute, latitude: latitude)
        guard let cityName = cityName else { return }
        cityNameToDisplay.onNext(cityName)
    }
}
