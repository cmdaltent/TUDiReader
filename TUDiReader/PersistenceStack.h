//
//  PersistenceStack.h
//  TUDiReader
//
//  Created by Martin Weissbach on 11/10/14.
//  Copyright (c) 2014 Martin Weissbach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface PersistenceStack : NSObject

@property (readonly) NSManagedObjectContext *managedObjectContext;

+ (instancetype)sharedPersistenceStack;

@end
