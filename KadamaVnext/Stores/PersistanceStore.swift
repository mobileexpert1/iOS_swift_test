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
   
