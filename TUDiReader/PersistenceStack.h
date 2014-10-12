//
//  PersistenceStack.h
//  TUDiReader
//
//  Created by Martin Weissbach on 06/01/14.
//  Copyright (c) 2014 Technische Universität Dresden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface PersistenceStack : NSObject

@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

- (id)initWithStoreURL:(NSURL *) storeURL modelURL:(NSURL *)modelURL;

@end
