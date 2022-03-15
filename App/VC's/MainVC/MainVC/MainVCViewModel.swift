//
//  MainVCViewModel.swift
//  App
//
//  Created by Константин Вороненко on 11.03.22.
//

import UIKit
import RxSwift
import RxCocoa

protocol MainVCViewModelProtocol {
    var weather: PublishSubject<Weather> { get }
    var article: PublishSubject<Article> { get }
    
    func getUserLocation()
    
    func loadArticle()
    func loadWeather(longtitude: Double, latitude: Double)
}

final class MainVCViewModel: MainVCViewModelProtocol {
    var weather = PublishSubject<Weather>()
    var article = PublishSubject<Article>()
    
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
    
    init() {
        UserLocationService.shared.delegate = self
    }
}

extension MainVCViewModel: UserLocationServiceDelegate {
    func updatedLocation(longtitute: Double, latitude: Double) {
        loadWeather(longtitude: longtitute, latitude: latitude)
    }
}
