//
//  AppDelegate.m
//  TUDiReader
//
//  Created by Martin Weissbach on 10/20/14.
//  Copyright (c) 2014 Martin Weissbach. All rights reserved.
//

#import "AppDelegate.h"
#import "PersistenceStack.h"
#import "Feed.h"
#import "FeedParser.h"

@interface AppDelegate () <UISplitViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /**
    * Set the AppDelegate as delegate for the SplitView so that the default button to show the Master view can be
    * properly displayed on orientation changes of the device.
    */
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    /**
    * The window's root view controller is set by the system.
    * The initial view controller of the main storyboard file is assigned as root view controller.
    * The main storyboard file can be set on the Target's overview page in Xcode.
    */
    UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
    navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
    splitViewController.delegate = self;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    /**
    * The app will be sent this message whenever the system grants background execution time to the application.
    * In our example, we fetch the latest feed items of the last read feed.
    */
    NSError *fetchError = nil;
    PersistenceStack *persistenceStack = [PersistenceStack sharedPersistenceStack];
    Feed *feed = (Feed *)[persistenceStack.managedObjectContext existingObjectWithID:[persistenceStack preselectedFeedID] error:&fetchError];
    if ( feed == nil || fetchError != nil )
    {
        completionHandler(UIBackgroundFetchResultNoData);
        return;
    }
    else
    {
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
        NSURLSessionTask *task = [session dataTaskWithURL:feed.url
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            if ( ((NSHTTPURLResponse *)response).statusCode != 200 )
                                            {
                                                completionHandler(UIBackgroundFetchResultFailed);
                                                return ;
                                            }
                                            if ( data.length == 0)
                                            {
                                                completionHandler(UIBackgroundFetchResultNoData);
                                                return;
                                            }
                                            FeedParser *parser = [[FeedParser alloc] initWithData:data];
                                            parser.parsingFinishedBlock = ^(NSArray *items) {
                                                [feed addItems:items];
                                                completionHandler(UIBackgroundFetchResultNewData);
                                            };
                                        }];
        [task resume];
    }
}

#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    return [secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[UIViewController class]];
}

@end
