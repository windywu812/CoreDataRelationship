//
//  CoreDataService.swift
//  CoreDataRelationship
//
//  Created by Windy on 19/08/21.
//

import UIKit
import CoreData

class CoreDataService {
    
    let appDelegate: AppDelegate!
    let moc: NSManagedObjectContext!
    
    init() {
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        moc = appDelegate.persistentContainer.viewContext
    }
    
    func retrieveData(completion: @escaping ([GameModel]) -> ()) {
       
        let request: NSFetchRequest = NSFetchRequest<Game>(entityName: "Game")
                        
        do {
            let result = try moc.fetch(request)
            let games: [GameModel] = result.map({
                let publishers = $0.publishers?.allObjects.map { publisher -> PublisherModel in
                    let publisher = publisher as! Publisher
                    return PublisherModel(
                        id: publisher.id ?? UUID(),
                        name: publisher.name ?? "")
                }
                return GameModel(
                    id: $0.id ?? UUID(),
                    name: $0.name ?? "",
                    publishers: publishers ?? [])
            })
            
            completion(games)
        } catch let err {
            print(err.localizedDescription)
        }
        
    }
    
    func addToCoreData(game: GameModel, completion: @escaping () -> ()) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let moc = appDelegate.persistentContainer.viewContext
       
        let gameToSave = Game(context: moc)
        gameToSave.id = game.id
        gameToSave.name = game.name
        
        let publishers: [Publisher] = game.publishers.map({
            let publisher = Publisher(context: moc)
            publisher.id = $0.id
            publisher.name = $0.name
            return publisher
        })
        gameToSave.publishers = NSSet(array: publishers)
                
        do {
            moc.insert(gameToSave)
            try moc.save()
            completion()
        } catch let err {
            print(err)
        }
    }
    
    func deletaData(with id: UUID, completion: @escaping () -> ()) {
        
        let fetchRequest = NSFetchRequest<Game>(entityName: "Game")
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)
        fetchRequest.predicate = predicate
        
        guard let object = try? moc.fetch(fetchRequest).first else { return }
        moc.delete(object)
        
        do {
            try moc.save()
            completion()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
}
