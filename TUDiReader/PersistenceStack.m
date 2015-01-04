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
        __sharedInstance = [(PersistenceStack *) [super allocWithZone:NULL] initUnique];
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
    NSURL *documentsDirectory = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                                       inDomain:NSUserDomainMask
                                                              appropriateForURL:nil
                                                                         create:YES
                                                                          error:&documentsDirectoryError];
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

- (NSManagedObjectID *)preselectedFeedID
{
    NSDictionary *defaults = [[NSDictionary alloc] initWithContentsOfURL:[self defaultsFile]];
    if ( defaults.count == 0 )
    {
        return nil;
    }
    
    return [self.managedObjectContext.persistentStoreCoordinator managedObjectIDForURIRepresentation:[NSURL URLWithString:defaults[PSDefaults_PreselectedFeed]]];
}

- (void)setPreselectedFeedID:(NSManagedObjectID *)preselectedFeedID
{
    NSMutableDictionary *defaults = [[NSMutableDictionary alloc] initWithContentsOfURL:[self defaultsFile]];
    if ( defaults == nil )
    {
        defaults = [NSMutableDictionary new];
    }
    defaults[PSDefaults_PreselectedFeed] = [preselectedFeedID URIRepresentation].absoluteString;
    
    [defaults writeToURL:[self defaultsFile] atomically:YES];
}

- (NSURL *)defaultsFile
{
    NSError *documentsDirectoryError = nil;
    NSURL *documentsDirectory = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                                       inDomain:NSUserDomainMask
                                                              appropriateForURL:nil
                                                                         create:YES
                                                                          error:&documentsDirectoryError];
    if ( documentsDirectoryError )
    {
        return nil;
    }
    
    NSURL *defaultsURL = [documentsDirectory URLByAppendingPathComponent:@"defaults.plist"];
    if ( ! [[NSFileManager defaultManager] fileExistsAtPath:defaultsURL.path] )
    {
        [[NSFileManager defaultManager] createFileAtPath:defaultsURL.path
                                                contents:nil
                                              attributes:nil];
    }
    
    return defaultsURL;
}
























@end
