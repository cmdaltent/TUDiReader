//
//  AppDelegate.m
//  TUDiReader
//
//  Created by Martin Weißbach on 10/28/13.
//  Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//

#import "AppDelegate.h"

#import "FeedListViewController.h"
#import "NavigationViewController.h"

#import "PersistenceStack.h"

@interface AppDelegate ()

@property (nonatomic) PersistenceStack *persistenceStack;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /*!
        An application has always one window unless it can present content on external devices.
     */
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.persistenceStack = [[PersistenceStack alloc] initWithStoreURL:[self storeURL] modelURL:[self modelURL]];
    
    FeedListViewController *feedListViewController = [[FeedListViewController alloc] initWithNibName:@"ListView" bundle:nil];
    feedListViewController.managedObjectContext = self.persistenceStack.managedObjectContext;
    /*!
        If ViewController and nib-file had the same file name, you could simply call:
        [[FeedListViewController alloc] init]
     */
    
    /*!
        The NavigationController is a subclass of UINavigationController responsible for navigation bar styling.
        The UINavigationController provides us with all the functionalities we require to navigate from one view to another.
        All views are put on a view stack that grows buttom up and works LIFO.
        The rootViewController is the view initially displayed when the UINavigationController is presented.
     */
    NavigationViewController *navigationController = [[NavigationViewController alloc] initWithRootViewController:feedListViewController];
    
    self.window.rootViewController = navigationController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self.persistenceStack.managedObjectContext save:NULL];
}

- (NSURL *)storeURL
{
    NSURL *documentsDirectory = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                                       inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:NULL];
    return [documentsDirectory URLByAppendingPathComponent:@"db.sqlite"];
}

- (NSURL *)modelURL
{
    return [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
}

@end
