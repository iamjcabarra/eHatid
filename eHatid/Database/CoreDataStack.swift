//
//  CoreDataStack.swift
//  eHatid
//
//  Created by Julius Abarra on 2/14/20.
//  Copyright © 2020 eXzeptional. All rights reserved.
//

import CoreData
import Foundation

public class CoreDataStack {
    
    // MARK: - Stored Properties
    public var store: NSPersistentStore?
    public var masterContext: NSManagedObjectContext!
    public var mainContext: NSManagedObjectContext!
    public var workerContext: NSManagedObjectContext!
    
    // MARK: - Initializer
    public init(name: String) {
        // STEP 1
        // Managed object model
        guard let model = self.getManagedObjectModel(withName: name) else {
            fatalError("Can't find managed object model \"\(name)\" from application bundle.")
        }
        
        // STEP 2
        // Persistent store coordinator
        let psc = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        // STEP 3
        // Create directory for store
        guard
            let url = self.getPersistentStoreFileURL(forSQLFileWithName: "\(name).sqlite")
        else {
            fatalError("Can't find persistent store file url or it's not compatible.")
        }
        
        // STEP 4
        // Managed object model compatibility test
        self.checkCompatibility(storeFileUrl: url, coordinator: psc)
        
        // DATA FLUSHER
        // Core data stack for the master thread
        // [MASTER] -> [STORE]
        self.masterContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        self.masterContext.persistentStoreCoordinator = psc
        self.masterContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyStoreTrumpMergePolicyType)
        self.masterContext.name = "MasterContext"
        
        // UI-RELATED CONTEXT
        // Core data stack for the main thread
        // [MAIN] -> [MASTER]
        self.mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.mainContext.parent = self.masterContext
        self.mainContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyStoreTrumpMergePolicyType)
        self.mainContext.name = "MainContext"
        
        // BACKGROUND CONTEXT
        // Core data stack for the worker thread
        // [WORKER] -> [MAIN]
        self.workerContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        self.workerContext.parent = self.mainContext
        self.workerContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyStoreTrumpMergePolicyType)
        self.workerContext.name = "WorkerContext"
        
        /// PERSISTENT STORE
        /// Adding to persistent coordinator
        let sqliteConfig: [String: String] = ["journal_mode": "DELETE"]
        let options: [AnyHashable: Any] = [
            NSMigratePersistentStoresAutomaticallyOption: true,
            NSInferMappingModelAutomaticallyOption: true,
            NSSQLitePragmasOption: sqliteConfig
        ]
        do {
            try self.store = psc.addPersistentStore(
                ofType: NSSQLiteStoreType,
                configurationName: nil,
                at: url, options: options
            )
            logger.info("Successful adding local persistent store to coordinator.")
        } catch let error {
            fatalError("Can't add local persistent store to coordinator: \(error)")
        }
    }
    
}

// MARK: - Utility Methods
extension CoreDataStack {
    
    /// Searches managed object model with a name supplied from the application's bundle.
    ///
    /// - Parameter name: A `String` identifying managed object model's name
    /// - Returns: A managed object model if it is found; otherwise, nil
    private func getManagedObjectModel(withName name: String) -> NSManagedObjectModel? {
        guard
            let modelURL = Bundle.main.url(forResource: name, withExtension: "momd"),
            let model = NSManagedObjectModel(contentsOf: modelURL)
        else {
            logger.error("Can't retrieve managed object model \"\(name)\".")
            return nil
        }
        return model
    }
    
    /// Searches the path of the local persistent store at the documents directory. If found, then it returns
    /// the path; otherwise, it creates directory for local persistent store and returns the created path.
    ///
    /// - Parameter name: A `String` identifying local persistent store's name
    /// - Returns: A `URL` if it is created; otherwise, nil
    private func getPersistentStoreFileURL(forSQLFileWithName name: String) -> URL? {
        let fileManager: FileManager = FileManager.default
        let documentsDirectoryPath: String = NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.documentDirectory,
            FileManager.SearchPathDomainMask.userDomainMask,
            true)[0]
        let storesDirectoryPath: String = (documentsDirectoryPath as NSString).appendingPathComponent("Stores")
        
        if fileManager.fileExists(atPath: storesDirectoryPath) == false {
            do {
                try fileManager.createDirectory(
                    atPath: storesDirectoryPath,
                    withIntermediateDirectories: true,
                    attributes: nil
                )
                logger.info("Successful creating a directory for local persistent store.")
            } catch let error {
                logger.error("Can't create a directory for local persistent store: \(error)")
                return nil
            }
        }
        
        return URL(fileURLWithPath: storesDirectoryPath).appendingPathComponent(name)
    }
    
    /// Checks if local persistent store (if exists) is compatible or not.
    ///
    /// - Parameters:
    ///     - url: A local persistent store path
    ///     - coordinator: A local persistent store coordinator
    /// - Returns: None
    private func checkCompatibility(storeFileUrl: URL, coordinator: NSPersistentStoreCoordinator) {
        let fileManager: FileManager = FileManager.default
        let path: String = storeFileUrl.path
        
        guard fileManager.fileExists(atPath: path) else {
            logger.error("Local persistent store at \"\(path)\" does not exist.")
            return
        }
        
        do {
            let metadata: [String: Any] = try NSPersistentStoreCoordinator.metadataForPersistentStore(
                ofType: NSSQLiteStoreType,
                at: storeFileUrl,
                options: nil
            )
            
            if coordinator.managedObjectModel.isConfiguration(withName: nil, compatibleWithStoreMetadata: metadata) {
                logger.info("Local persistent store is compatible.")
            } else {
                logger.info("Local persistent store at \"\(path)\" is not compatible.")
                
                do {
                    try fileManager.removeItem(atPath: path)
                    logger.info("It has been removed.")
                } catch let error {
                    logger.error("It can't remove: \(error)")
                }
            }
        } catch let error {
            logger.error("Checking for local persistent store compatibility: \(error)")
        }
    }
    
}

// MARK: - Public APIs
extension CoreDataStack {
    
    /// Creates an exact predicate based on the given key path and value.
    ///
    /// - Parameters:
    ///     - keyPath: A `String` identifiying the name of entity's property
    ///     - exactValue: A  `String` identifying the value to look for
    /// - Returns: An instance of `NSPredicate`
    public func createPredicate(forKeyPath keyPath: String, exactValue: String) -> NSPredicate {
        let predicate: NSComparisonPredicate = NSComparisonPredicate(
            leftExpression: NSExpression(forKeyPath: keyPath),
            rightExpression: NSExpression(forConstantValue: exactValue),
            modifier: NSComparisonPredicate.Modifier.direct,
            type: NSComparisonPredicate.Operator.equalTo,
            options: [
                NSComparisonPredicate.Options.diacriticInsensitive,
                NSComparisonPredicate.Options.caseInsensitive
            ]
        )
        return predicate
    }
    
    /// Saves the changes made with objects in the context.
    ///
    /// - Parameter context: An instance of `NSManagedObjectContext`
    /// - Returns: `true` if saving is successful; otherwise, `false`
    public func saveManagedObjectContext(_ context: NSManagedObjectContext) -> Bool {
        var isSuccess = false

        do {
            try context.save()
            isSuccess = true
        } catch let error {
            logger.error("Saving tree context because: \(error)")
        }
        
        if let parent = context.parent {
            isSuccess = self.saveManagedObjectContext(parent)
        }
        
        return isSuccess
    }
    
    /// Retrieves an item of entity from core data.
    ///
    /// - Parameters:
    ///     - name: A `String` identiying entity's name
    ///     - context: An instance of `NSManagedObjectContext`
    ///     - predicate: An instance of `NSPredicate` or `nil`
    /// - Returns: An instance of `NSManagedObject`
    public func retrieveEntity(
        name: String,
        fromContext context: NSManagedObjectContext,
        filteredBy predicate: NSPredicate?
    ) -> NSManagedObject {
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: name)
        fetchRequest.predicate = predicate
        
        do {
            let items = try context.fetch(fetchRequest)
            if items.count > 0, let item = items.last {
                return item
            }
        } catch let error {
            logger.error("Retrieving entity \"\(name)\" because: \(error)")
        }
        
        return NSEntityDescription.insertNewObject(forEntityName: name, into: context)
    }
    
    /// Retrieves items of entity from core data.
    ///
    /// - Parameters:
    ///     - name: A `String` identiying entity's name
    ///     - predicate: An instance of `NSPredicate` or `nil`
    /// - Returns: An array of `NSManagedObject` instances or `nil`
    public func retrieveItemsOfEntity(name: String, filteredBy predicate: NSPredicate? = nil) -> [NSManagedObject]? {
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest<NSManagedObject>(entityName: name)
        fetchRequest.predicate = predicate
        
        do {
            let items = try self.workerContext.fetch(fetchRequest)
            if items.count > 0 {
                return items
            }
        } catch let error {
            logger.error("Retrieving items from \"\(name)\" error: \(error)")
        }
        
        return nil
    }
    
}
