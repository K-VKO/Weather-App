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
        
        let container = NSPersistentCloudKitContainer(name: "CoreData")
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
    static func saveCurrentWeatherToDB(weather: LoadedWeather) {
        var weatherDB: WeatherDB?
        
        getWeatherFromDB { grabbedWeatherDB in
            if let grabbedWeatherDB = grabbedWeatherDB {
                weatherDB = grabbedWeatherDB
            } else {
                weatherDB = WeatherDB(context: CoreDataService.managedObjectContext)
                weatherDB?.current = CurrentDB(context: CoreDataService.managedObjectContext)
            }
            
        }
        
        guard let weatherDB = weatherDB else { return }
        guard let cityName = weather.cityName else { return }
        
        weatherDB.cityName = cityName
        weatherDB.current?.icon = weather.current.weather[0].icon
        weatherDB.current?.temp = weather.current.temp
        weatherDB.current?.weatherDescription = weather.current.weather[0].description
        
        CoreDataService.saveContext()
    }
    
    static func getWeatherFromDB(completion: @escaping (WeatherDB?) -> Void) {
        let request = WeatherDB.fetchRequest()
        if let weatherDB = try? CoreDataService.managedObjectContext
            .fetch(request)
            .first {
            completion(weatherDB)
        } else {
            completion(nil)
        }
    }
}
