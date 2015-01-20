//
//  PersistenceStack.m
//  TUDiReader
//
//  Created by Martin Weissbach on 11/10/14.
//  Copyright (c) 2014 Martin Weissbach. All rights reserved.
//

#import "PersistenceStack.h"

@interface PersistenceStack ()
{
    NSManagedObjectContext *_managedObjectContext;
}

@end

static NSString *PSDefaults_PreselectedFeed = @"PSDefaults_PreselectedFeed";

@implementation PersistenceStack

+ (instancetype)sharedPersistenceStack
{
    static PersistenceStack *__sharedInstance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        __sharedInstance = [[super allocWithZone:NULL] initUnique];
    });
    
    return __sharedInstance;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedPersistenceStack];
}

- (id)initUnique
{
    return [self init];
}

#pragma mark - CoreData Stack

- (NSManagedObjectContext *)managedObjectContext
{
    if (!_managedObjectContext)
    {
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        NSError *persistentStoreError = nil;
        [coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                  configuration:nil
                                            URL:[self storeURL]
                                        options:nil
                                          error:&persistentStoreError];
        if (persistentStoreError)
        {
            NSLog(@"Could not add PersistentStoreType");
            return nil;
        }
        
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _managedObjectContext.persistentStoreCoordinator = coordinator;
    }
    return _managedObjectContext;
}

- (NSURL *)storeURL
{
    NSError *documentsDirectoryError = nil;
    NSURL *documentsDirectory = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.de.tu-dresden.inf.rn.TUDiReader"];
    if (documentsDirectoryError)
    {
        NSLog(@"Could not get Document directory.");
        return nil;
    }
    
    return [documentsDirectory URLByAppendingPathComponent:@"db.sqlite"];
}

- (NSManagedObjectModel *)managedObjectModel
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
}

#pragma mark - Preselected Feed

- (NSManagedObjectID *)preselectedFeedID
{
    NSURL *representation = [[self defaultSuite] URLForKey:PSDefaults_PreselectedFeed];
    if ( representation == nil )
        return nil;
    
    return [self.managedObjectContext.persistentStoreCoordinator managedObjectIDForURIRepresentation:representation];
}

- (void)setPreselectedFeedID:(NSManagedObjectID *)preselectedFeedID
{
    if ( preselectedFeedID == nil )
    {
        [[self defaultSuite] removeObjectForKey:PSDefaults_PreselectedFeed];
        return;
    }
    
    [[self defaultSuite] setURL:[preselectedFeedID URIRepresentation] forKey:PSDefaults_PreselectedFeed];
}

- (NSUserDefaults *)defaultSuite
{
    return [[NSUserDefaults alloc] initWithSuiteName:@"group.de.tu-dresden.inf.rn.TUDiReader"];
}

@end
