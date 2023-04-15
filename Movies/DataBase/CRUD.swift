//
//  CRUD.swift
//  Movies
//
//  Created by shadab sheikh on 2023-04-13.
//

import Foundation
import UIKit
import CoreData


class CoreDataManager {
    static let shared = CoreDataManager()
    private init () {}
    
    //MARK:  (Note: Return function is missing bcoz don't what kind of data need to show api isn't working.)
    
    // MARK: Create
    func createData(movies: MoviesData, store_path: Data) {
         DispatchQueue.main.async {
             guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
             let managedContext = appDelegate.persistentContainer.viewContext
             let userEntity = NSEntityDescription.entity(forEntityName: "Movies", in: managedContext)!
             do {
                      let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
                     user.setValue(movies.adult, forKeyPath: "adult")
                     user.setValue(movies.id, forKeyPath: "id")
                     user.setValue(movies.original_language, forKeyPath: "original_language")
                     user.setValue(movies.original_title, forKeyPath: "original_title")
                     user.setValue(movies.overview, forKeyPath: "overview")
                     user.setValue(movies.popularity, forKeyPath: "popularity")
                     user.setValue(store_path, forKeyPath: "poster_path")                 
                     user.setValue(movies.release_date, forKeyPath: "release_date")
                     user.setValue(movies.title, forKeyPath: "title")
                     user.setValue(movies.video, forKeyPath: "video")
                     user.setValue(movies.vote_average, forKeyPath: "vote_average")
                     user.setValue(movies.vote_count, forKeyPath: "vote_count")
                     user.setValue(movies.like, forKeyPath: "like")
                 try managedContext.save()
                 
             } catch let error as NSError {
                 print("Could not save. \(error), \(error.userInfo)")
             }
         }
    }
    
    // MARK: Retrieve
    func retrieveData(completionHandler: @escaping ([MoviesData])->Void) {
        var moviestore = [MoviesData]()
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Movies")
            do {
                let result = try managedContext.fetch(fetchRequest)
                var model = MoviesData(dataObject: [:])
                for data in result as! [NSManagedObject] {
                    model.adult = data.value(forKey: "adult") as? Bool ?? false
                    model.id = data.value(forKey: "id") as? Int ?? 0
                    model.original_language = data.value(forKey: "original_language") as? String ?? ""
                    model.original_title = data.value(forKey: "original_title") as? String ?? ""
                    model.overview = data.value(forKey: "overview") as? String ?? ""
                    model.popularity = data.value(forKey: "popularity") as? Double ?? 0.0
                    model.stored_path = data.value(forKey: "poster_path") as? Data ?? Data()
                    model.release_date = data.value(forKey: "release_date") as? String ?? ""
                    model.title = data.value(forKey: "title") as? String ?? ""
                    model.video = data.value(forKey: "video") as? Int ?? 0
                    model.vote_average = data.value(forKey: "vote_average") as? Float ?? 0.0
                    model.vote_count = data.value(forKey: "vote_count") as? Int ?? 0
                    model.like = data.value(forKey: "like") as? Bool ?? false
                    moviestore.append(model)
                }
                completionHandler(moviestore)
            } catch {
                
                print("Failed")
            }
        }
    }
    
    
    // MARK: Update
    func updateData(original_title: String, like: Int) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Movies")
        fetchRequest.predicate = NSPredicate(format: "original_title = %@", original_title )
        
        do {
            
            let test = try managedContext.fetch(fetchRequest)
            
            if test.count != 0 {
                let objectUpdate = test[0] as! NSManagedObject
                objectUpdate.setValue(like, forKeyPath: "like")
                do {
                    try managedContext.save()
                    NotificationCenter.default.post(name: Notification.Name("reloadData"), object: nil)
                } catch {
                    print(error)
                }
            }
        } catch {
            print(error)
        }
    }
    
    // MARK: Delete
    func deleteData(original_title: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Movies")
        fetchRequest.predicate = NSPredicate(format: "original_title = %@", original_title)
        
        do {
            let test = try managedContext.fetch(fetchRequest)
            let objectToDelete = test[0] as! NSManagedObject
            managedContext.delete(objectToDelete)
            do{
                try managedContext.save()
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
}
