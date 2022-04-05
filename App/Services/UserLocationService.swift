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
    
    func deniedLocationAccess()
}

final class UserLocationService: NSObject {
    static let shared = UserLocationService()
    
    let geoCoder = CLGeocoder()

    let locationManager = CLLocationManager()
    
    var delegate: UserLocationServiceDelegate?
    
    func getUserLocation() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func getCityName(location: CLLocation, completion: @escaping (String?) -> Void) {
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
            locationManager.stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied {
            delegate?.deniedLocationAccess()
        }
    }
}
