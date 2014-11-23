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

@interface FeedsListTableViewController ()
{
    BOOL _isViewDisplayed;
}

@property NSArray *groups;

@end

@implementation FeedsListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _isViewDisplayed = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateTableView:(id)sender
{
    NSManagedObjectContext *managedObjectContext = [PersistenceStack sharedPersistenceStack].managedObjectContext;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Group"];
    NSError *fetchError = nil;
    
    self.groups = [managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"])
    {
        /**
         Set the default 'Master'-Button on the Detail's View NavigationBar.
         */
        UIViewController *controller = [[segue destinationViewController] topViewController];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
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

@end
