//
//  PersistenceStack.m
//  TUDiReader
//
//  Created by Martin Weissbach on 06/01/14.
//  Copyright (c) 2014 Technische Universität Dresden. All rights reserved.
//

#import "PersistenceStack.h"

@interface PersistenceStack ()

@property (nonatomic, readwrite)NSManagedObjectContext *managedObjectContext;

@property (nonatomic)NSURL *storeURL;
@property (nonatomic)NSURL *modelURL;

@end

@implementation PersistenceStack

- (id)initWithStoreURL:(NSURL *)storeURL modelURL:(NSURL *)modelURL
{
    self = [super init];
    if (self) {
        self.storeURL = storeURL;
        self.modelURL = modelURL;
        [self setupPersistenceStack];
    }
    
    return self;
}

- (void)setupPersistenceStack
{
    NSError *error = nil;
    
    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.managedObjectContext.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    [self.managedObjectContext.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                       configuration:nil
                                                                                 URL:self.storeURL
                                                                             options:nil error:&error];
    if (error) {
        NSLog(@"Persistent Stack Error");
    }
    
}

- (NSManagedObjectModel *)managedObjectModel
{
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:self.modelURL];
}

@end
