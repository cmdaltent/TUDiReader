//
//  PersistenceStack.m
//  TUDiReader
//
//  Created by Martin Weissbach on 06/01/14.
//  Copyright (c) 2014 Technische Universität Dresden. All rights reserved.
//

#import "PersistenceStack.h"

#import "Feed.h"
#import "Group.h"

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
    
    [self prepopulateCoreData];
}

- (void)prepopulateCoreData
{
    if ([self isPrepopulationRequired]) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"DefaultFeeds" ofType:@"plist"];
        NSArray *rawFeeds = [NSArray arrayWithContentsOfFile:filePath];
        Group *defaultsGroup = [Group insertWithTitle:@"DefaultFeeds" inManagedObjectContext:self.managedObjectContext];
        for (NSDictionary *rawFeed in rawFeeds) {
            [Feed insertWithTitle:[rawFeed valueForKey:@"title"]
                              url:[NSURL URLWithString:[rawFeed valueForKey:@"url"]]
                            group:defaultsGroup
           inManagedObjectContext:self.managedObjectContext];
        }
        
        NSError *error = nil;
        [self.managedObjectContext save:&error];
        if (error) {
            NSLog(@"Error storing default feeds: %@", error);
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"alreadyPrepopulated"];
    
}
- (BOOL)isPrepopulationRequired
{
    BOOL required = ![[NSUserDefaults standardUserDefaults] boolForKey:@"alreadyPrepopulated"];
    return required;
}


- (NSManagedObjectModel *)managedObjectModel
{
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:self.modelURL];
}

@end
