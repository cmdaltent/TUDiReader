//
//  Group.swift
//  TUDiReader
//
//  Created by Martin Weissbach on 1/20/15.
//  Copyright (c) 2015 Martin Weissbach. All rights reserved.
//

import Foundation
import CoreData

class Group : NSManagedObject {
    
    @NSManaged var name: String
    @NSManaged var feeds : NSSet
    
}