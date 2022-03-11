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
    
    func getUserLocation()
    func loadWeather(longtitude: Double, latitude: Double)
}

final class MainVCViewModel: MainVCViewModelProtocol {
    var weather = PublishSubject<Weather>()
    
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
    
    init() {
        UserLocationService.shared.delegate = self
    }
}

extension MainVCViewModel: UserLocationServiceDelegate {
    func updatedLocation(longtitute: Double, latitude: Double) {
        loadWeather(longtitude: longtitute, latitude: latitude)
    }
}
