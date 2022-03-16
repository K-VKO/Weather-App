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
        
        let container = NSPersistentCloudKitContainer(name: "Project_v6")
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
        let weatherDB = CurrentWeatherDB()
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
