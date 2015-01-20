//
//  Item.swift
//  TUDiReader
//
//  Created by Martin Weissbach on 1/20/15.
//  Copyright (c) 2015 Martin Weissbach. All rights reserved.
//

import Foundation
import CoreData

class Item : NSManagedObject {
    
    @NSManaged var title: String
    @NSManaged var author: String
    @NSManaged var dateString: String
    @NSManaged var summary: String
    @NSManaged var guid: String
    @NSManaged var read: Bool
    
    @NSManaged var feed: Feed
    
}