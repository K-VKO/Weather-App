//
//  UserLocationService.swift
//  App
//
//  Created by Константин Вороненко on 10.03.22.
//

import MapKit
import CoreLocation

protocol UserLocationServiceDelegate {
    func updatedLocation(longtitute: Double, latitude: Double, cityName: String?)
}

final class UserLocationService: NSObject {
    static let shared = UserLocationService()
    
    let geoCoder = CLGeocoder()
    let location = CLLocation(latitude: 40.730610, longitude:  -73.935242) // <- New York

    let locationManager = CLLocationManager()
    
    var delegate: UserLocationServiceDelegate?
    
    func getUserLocation() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func getCityName(location: CLLocation, completion: @escaping (String?) -> Void) {
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, _) -> Void in
            placemarks?.forEach { (placemark) in
                if let city = placemark.locality {
                    completion(city)
                } else {
                    completion(nil)
                }
            }
        })
    }
}

extension UserLocationService: CLLocationManagerDelegate {  
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            getCityName(location: location) { [weak self] cityName in
                self?.delegate?.updatedLocation(longtitute: location.coordinate.longitude, latitude: location.coordinate.latitude, cityName: cityName)
            }
            print("Found user's location: \(location.coordinate.latitude)")
            locationManager.stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
