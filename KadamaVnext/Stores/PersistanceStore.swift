//
//  PersistanceStore.swift
//  KadamaVnext
//
//  Created by mobile on 21/07/21.
//

import Foundation
import CoreData


public class PersistanceStore {
    
    static let shared = PersistanceStore()
    
    //MARK: - Variables
    lazy var persistentContainer: NSPersistentContainer = {
        
        let momdName = "KadamaVnext"
       // let groupName = CONSTANTS.IDENTIFIERS.EXTENSION_GROUP_ID
        
        
        let fileName = "demo.sqlite"
        
        guard let modelURL = Bundle(for: type(of: self)).url(forResource: momdName, withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        
//        guard let baseURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupName) else {
//            fatalError("Error creating base URL for \(groupName)")
//        }
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
             print(urls[urls.count-1] as URL)
           // print("Core data path ",modelURL)
//        let storeUrl = baseURL.appendingPathComponent(fileName)
        
        let container = NSPersistentContainer(name: momdName, managedObjectModel: mom)
        
//        let description = NSPersistentStoreDescription()
//
//        description.url = storeUrl
//
//        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    public var context: NSManagedObjectContext {
        self.persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return self.persistentContainer.viewContext
    }
    
    
    //MARK: - Constructor
    public init() {
        
    }
    
    
    // MARK: - Core Data Saving support
    public func saveContext () {
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
    
     func savePokemon(pokemon:Pokemon) {
        
        guard let entity = NSEntityDescription.entity(forEntityName: "PokemonDetail", in: context) else { return }
        
        let contact = NSManagedObject(entity: entity, insertInto: context)
        contact.setValue(Date(), forKey: "entryUpdated")
        contact.setValue(pokemon.name, forKey: "name")
       
        contact.setValue(pokemon.sprites?.other?.officialArtwork?.frontDefault, forKey: "image")
        contact.setValue(pokemon.url, forKey: "url")
        contact.setValue(nil, forKey: "abilities")
        let string = pokemon.abilities?.map({$0.ability.name.capitalized}).joined(separator: ", ")
        contact.setValue(string, forKey: "abilities")
        if let id = parsePokemonURL(url: pokemon.url ?? "") {
        contact.setValue(id, forKey: "id")
        }
        else if let id = pokemon.id {
            contact.setValue("\(id)", forKey: "id")
        }
        do {
            try context.save()
        } catch let error {
            print("Could not save contacts into CoreData, Error: \(error.localizedDescription)")
        }
    }
    
    
    func parsePokemonURL(url:String) -> Substring? {
        let splits = url.split(separator: "/")
        return splits.last
    }
    
    
    public func removeAllPokemons() {
        let request = NSFetchRequest<PokemonDetail>(entityName: "PokemonDetail")
        do {
            let result = try context.fetch(request)
            let contacts = result as [NSManagedObject]
            
            for contact in contacts {
                context.delete(contact)
            }
            
            do { try context.save() }
            catch let error {
                print("Unable to save after deleting, Error: \(error.localizedDescription)")
            }
        } catch let error {
            print("Could not delete contacts from CoreData, Error: \(error.localizedDescription)")
        }
    }
    
}

extension PersistanceStore {
    
    
    
    public func fetchAllPokemons() -> [PokemonDetail] {
        let fetchedRequest: NSFetchRequest<PokemonDetail> = PokemonDetail.fetchRequest()
        do {
            let results = try context.fetch(fetchedRequest)
            return results
        } catch let error {
            print("Unable to update label in coreData, Error: \(error.localizedDescription)")
            return []
        }
    }
    
    
     func fetchPokemon(id: String) -> PokemonDetail? {
        let fetchedRequest: NSFetchRequest<PokemonDetail> = PokemonDetail.fetchRequest()
        fetchedRequest.predicate = NSPredicate(format: "id == %@", id)
       fetchedRequest.fetchLimit = 1
        do {
            
            let results = try context.fetch(fetchedRequest)
            if results.count > 0 {
                return results[0]
            }
        } catch let error {
            print("Unable to update label in coreData, Error: \(error.localizedDescription)")
            return nil
        }
        return nil
    }
    
    
    public func doesPokemonExist(id: String) -> Bool {
        let fetchedRequest: NSFetchRequest<PokemonDetail> = PokemonDetail.fetchRequest()
        fetchedRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let results = try context.fetch(fetchedRequest)
            if results.count > 0 {
                let pokemon = results[0]
                return (pokemon.image != nil)
            }
            return results.count > 0
        } catch let error {
            print("Unable to update label in coreData, Error: \(error.localizedDescription)")
            return true
        }
    }
    
    public func removePokemon(with number:String) {
        let fetchedRequest: NSFetchRequest<PokemonDetail> = PokemonDetail.fetchRequest()
        fetchedRequest.predicate = NSPredicate(format: "id == %@", number)
        do {
            let result = try context.fetch(fetchedRequest)
            let contacts = result as [NSManagedObject]
            
            for contact in contacts {
                context.delete(contact)
            }
            do { try context.save() }
            catch let error {
                print("Unable to save after deleting, Error: \(error.localizedDescription)")
            }
        } catch let error {
            print("Could not delete contacts from CoreData, Error: \(error.localizedDescription)")
        }
    }
    
    public func removeAllPokemonDetail() {
        let request = NSFetchRequest<PokemonDetail>(entityName: "PokemonDetail")
        do {
            let result = try context.fetch(request)
            let contacts = result as [NSManagedObject]
            
            for contact in contacts {
                context.delete(contact)
            }
            
            do { try context.save() }
            catch let error {
                print("Unable to save after deleting, Error: \(error.localizedDescription)")
            }
        } catch let error {
            print("Could not delete contacts from CoreData, Error: \(error.localizedDescription)")
        }
    }
    
}
