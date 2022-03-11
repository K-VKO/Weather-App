//
//  UserLocationService.swift
//  App
//
//  Created by Константин Вороненко on 10.03.22.
//

import MapKit
import CoreLocation

protocol UserLocationServiceDelegate {
    func updatedLocation(longtitute: Double, latitude: Double)
}

final class UserLocationService: NSObject {
    static let shared = UserLocationService()

    let locationManager = CLLocationManager()
    
    var delegate: UserLocationServiceDelegate?
    
    func getUserLocation() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension UserLocationService: CLLocationManagerDelegate {  
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Found user's location: \(location.coordinate.latitude)")
            delegate?.updatedLocation(longtitute: location.coordinate.longitude, latitude: location.coordinate.latitude)
            locationManager.stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
