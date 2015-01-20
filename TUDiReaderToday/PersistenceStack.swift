//
//  PersistenceStack.swift
//  TUDiReader
//
//  Created by Martin Weissbach on 1/19/15.
//  Copyright (c) 2015 Martin Weissbach. All rights reserved.
//

import Foundation
import CoreData

class PersistenceStack {
    
    init() {}
    
    var managedObjectContext: NSManagedObjectContext {
        get {
            if _managedObjectContext == nil {
                _managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
                _managedObjectContext?.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel!)
                _managedObjectContext?.persistentStoreCoordinator?.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: self.storeURL, options: nil, error: nil)
            }
            return _managedObjectContext!
        }
    }
    
    var preselecteFeedID: NSManagedObjectID? {
        get {
            if let url = defaultSuite.URLForKey("PSDefaults_PreselectedFeed") {
                return self.managedObjectContext.persistentStoreCoordinator?.managedObjectIDForURIRepresentation(url)
            } else {
                return nil
            }
        }
        set(objectID) {
            if objectID == nil {
                self.defaultSuite.removeObjectForKey("PSDefaults_PreselectedFeed")
            } else {
                let url = objectID!.URIRepresentation()
                self.defaultSuite.setURL(url, forKey: "PSDefaults_PreselectedFeed")
            }
        }
    }
    
    func feedForFeedID(preselectedFeedID: NSManagedObjectID) -> Feed? {
        return managedObjectContext.existingObjectWithID(preselectedFeedID, error: nil) as? Feed
    }
    
    private var defaultSuite: NSUserDefaults {
        get {
            return NSUserDefaults(suiteName: "group.de.tu-dresden.inf.rn.TUDiReader")!
        }
    }
    
    private var managedObjectModel: NSManagedObjectModel? {
        get {
            if let groupFolder = NSBundle.mainBundle().URLForResource("Model", withExtension: "momd") {
                return NSManagedObjectModel(contentsOfURL: groupFolder)
            }
            return nil
            
        }
    }
    
    private var storeURL: NSURL? {
        get {
            if let groupFolder = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.de.tu-dresden.inf.rn.TUDiReader") {
                return groupFolder.URLByAppendingPathComponent("db.sqlite")
            }
            return nil
            
        }
    }
    
    private var _managedObjectContext: NSManagedObjectContext?
}