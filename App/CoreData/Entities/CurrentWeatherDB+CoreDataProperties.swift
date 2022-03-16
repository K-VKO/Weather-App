//
//  CurrentWeatherDB+CoreDataProperties.swift
//  App
//
//  Created by Константин Вороненко on 16.03.22.
//
//

import Foundation
import CoreData


extension CurrentWeatherDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrentWeatherDB> {
        return NSFetchRequest<CurrentWeatherDB>(entityName: "CurrentWeatherDB")
    }

    @NSManaged public var temp: String?
    @NSManaged public var cityName: String?
    @NSManaged public var weatherDescription: String?

}

extension CurrentWeatherDB : Identifiable {

}
