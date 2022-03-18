//
//  CoreDataService.swift
//  App
//
//  Created by Константин Вороненко on 16.03.22.
//
import Foundation
import CoreData
import UIKit

final class CoreDataService: NSManagedObjectContext {
    
    static var managedObjectContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Core Data stack
    static var persistentContainer: NSPersistentCloudKitContainer = {
        
        let container = NSPersistentCloudKitContainer(name: "App")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    static func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
extension CoreDataService {
    static func saveCurrentWeatherToDB(weather: Weather) {
        let weatherDB = CurrentWeatherDB(context: CoreDataService.managedObjectContext)
        guard let cityName = weather.cityName else { return }
        weatherDB.cityName = cityName
        weatherDB.icon = weather.weather[0].icon
        weatherDB.temp = "\(weather.weatherNumbers.temp) °C"
        weatherDB.weatherDescription = weather.weather[0].description
        
        CoreDataService.saveContext()
    }
    
    static func getCurrentWeatherFromDB(completion: @escaping (Weather?) -> Void) {
        let request = CurrentWeatherDB.fetchRequest()
        if let weatherDB = try? CoreDataService.managedObjectContext
            .fetch(request)
            .first {
            if let weatherDescription = weatherDB.weatherDescription,
               let icon = weatherDB.icon {
                let weatherDescription = WeatherDescription(description: weatherDescription, icon: icon)
                let main = Main(temp: 18.9)
                let weather = Weather(weather: [weatherDescription], weatherNumbers: main, cityName: weatherDB.cityName)
                completion(weather)
            } else {
                completion(nil)
            }
        }
    }
}
    
    
    //
    //extension CoreDataService {
    //   static func getProductDetailsFromDB(asin: String, completion: @escaping (ProductDetails?) -> Void) {
    //        let request = ProductDB.fetchRequest()
    //        if let productDB = try? CoreDataService.managedObjectContext
    //            .fetch(request)
    //            .filter({ $0.asin == asin }).first {
    //            if let localImages = productDB.images?.compactMap({ ($0 as! ImageDB).name }) {
    //                completion(ProductDetails(description: productDB.productDescription ?? "", localImages: localImages))
    //            }
    //        } else {
    //          completion(nil)
    //      }
    //    }
