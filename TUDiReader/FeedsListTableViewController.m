//
//  FeedsListTableViewController.m
//  TUDiReader
//
//  Created by Martin Weissbach on 10/20/14.
//  Copyright (c) 2014 Martin Weissbach. All rights reserved.
//

#import "FeedsListTableViewController.h"

#import "Feed.h"
#import "PersistenceStack.h"
#import "AddFeedViewController.h"
#import "FeedItemsTableViewController.h"

@interface FeedsListTableViewController ()
{
    /**
    * Just an instance variable without generated accessor methods.
    */
    BOOL _isViewDisplayed;
}

@property NSArray *groups; // Property: Strong, Atomic, readwrite (-groups and -setGroups: generated)

@end

@implementation FeedsListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    /**
    * Whenever an NSManagedObjectContext instance receives a -save: message, it will emit this Notification to the
    * NSNotificationCenter.
    * When the notification center receives such a notification it will send the selector message to all registered
    * observers.
    * In this case this instance will receive the -updateTableView: message.
    */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateTableView:)
                                                 name:NSManagedObjectContextDidSaveNotification object:nil];
    
    [self updateTableView:self];
    
    _isViewDisplayed = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _isViewDisplayed = YES;

    /**
    * When the view appears, we want to highlight and select the feed that was last opened by the user.
    * The following LOC determine the last feed read and the position in the table view hierarchy to highlight and select.
    */
    int section = 0, row = 0;
    BOOL found = NO;
    NSError *fetchError = nil;
    NSManagedObjectID *objectID = [[PersistenceStack sharedPersistenceStack] preselectedFeedID];
    if ( objectID == nil )
        return;
    Feed *preselectedFeed = (Feed *)[[PersistenceStack sharedPersistenceStack].managedObjectContext existingObjectWithID:objectID error:&fetchError];
    if ( preselectedFeed == nil || fetchError != nil )
        return;
    
    for ( Group *groups in self.groups )
    {
        for ( Feed *feed in [groups orderedFeeds] )
        {
            if ( [feed isEqual:preselectedFeed] )
            {
                found = YES;
                break;
            }
            row += 1;
        }
        if ( found ) break;
        section += 1;
    }
    if ( found )
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        [self performSegueWithIdentifier:@"showFeedItems" sender:self];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _isViewDisplayed = NO;
}

- (void)updateTableView:(id)sender
{
    NSManagedObjectContext *managedObjectContext = [PersistenceStack sharedPersistenceStack].managedObjectContext;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Group"];
    NSError *fetchError = nil;
    
    self.groups = [managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
    if( _isViewDisplayed )
    {
        [self.tableView reloadData];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    /**
    * The -prepareForSegue:sender: method provides the possibility to pass information to destination view controllers
    * before they are displayed.
    * The data will be set before the view controller receives the -viewDidLoad message.
    */
    if ([[segue identifier] isEqualToString:@"showFeedItems"])
    {
        /**
         Set the default 'Master'-Button on the Detail's View NavigationBar.
         */
        FeedItemsTableViewController *controller = (FeedItemsTableViewController *)[[segue destinationViewController] topViewController];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        controller.feed = [(Group *)self.groups[indexPath.section] orderedFeeds][indexPath.row];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [(Group *)self.groups[section] feeds].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedCell" forIndexPath:indexPath];
    
    Feed *feed = [(Group *)self.groups[indexPath.section] orderedFeeds][indexPath.row];
    cell.textLabel.text = feed.title;
    cell.detailTextLabel.text = [feed.url absoluteString];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.groups[section] name];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Feed *feed = [self.groups[indexPath.section] orderedFeeds][indexPath.row];
    [[PersistenceStack sharedPersistenceStack] setPreselectedFeedID:feed.objectID];
}

@end
