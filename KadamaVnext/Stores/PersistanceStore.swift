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
    
    //MARK: - Constructor
    public init() {}
    
    
    
    //MARK: - Variables
    lazy var persistentContainer: NSPersistentContainer = {
        
        let momdName = "KadamaVnext"
        let fileName = "demo.sqlite"
        guard let modelURL = Bundle(for: type(of: self)).url(forResource: momdName, withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }

        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let container = NSPersistentContainer(name: momdName, managedObjectModel: mom)
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
    
    // Save single pokemon
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

    
}

extension PersistanceStore {
    
    // Fetch all pokemons from core data
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
    
    // Fetch single pokemon from core data
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
    
    
    // Check if pokemon exists mainly to find if image is there because there can be local pokemons without image
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
    
}
