//
//  Feed.swift
//  TUDiReader
//
//  Created by Martin Weissbach on 1/19/15.
//  Copyright (c) 2015 Martin Weissbach. All rights reserved.
//

import Foundation
import CoreData

class Feed : NSManagedObject {
    
    @NSManaged var title: String
    @NSManaged var url: NSURL
    
    @NSManaged var group: Group
    @NSManaged var items: NSSet
}
