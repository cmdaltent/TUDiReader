//
//  FeedListViewController.m
//  TUDiReader
//
//  Created by Martin Weißbach on 10/28/13.
//  Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//

#import "FeedListViewController.h"

#import "Feed.h"
#import "Group.h"

#import "NewFeedViewController.h"
#import "ItemListViewController.h"
#import "NavigationViewController.h"
#import "FeedListTableSectionHeader.h"
#import "FeedListDataSource.h"

@interface FeedListViewController () <FeedListDataSourceDelegate>

@property (nonatomic) FeedListDataSource *feedListDataSource;

/*!
    Displays the NewFeedView to create a new feed for the list.
    
    @param sender   The object who send this message to the receiver.
 */
- (void)openNewFeedView:(id)sender;

@end

@implementation FeedListViewController

- (void)viewDidLoad
{
    [super viewDidLoad]; // Always forward viewDidLoad to the super class. Views will not correctly otherwise.

    
    /*!
        The navigation item represents the view controller in a parent's view navigation controller.
        It is inherited from UIViewController and only visible when the view was added to a navigation controller's view stack.
     
        The _target_ of the UIBarButton item is the receiver of messages that will be sent when the button reckognizes a touch event.
        The _action_ is the name of the message sent when the button detects a touch event.
     */
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                           target:self
                                                                                           action:@selector(openNewFeedView:)];
    
    self.feedListDataSource = [[FeedListDataSource alloc] initWithTableView:self.tableView cellReuseIdentifier:@"FeedCell" managedObjectContext:self.managedObjectContext];
    
    self.feedListDataSource.delegate = self;
    
}

- (NSString *)title
{
    /*!
        Return the title of the View. It will be displayed in the navigation bar in the title field.
        Alternatively you could use (in viewDidLoad):
        [self.navigationItem.title = @"Feeds"];
     */
    return @"Feeds";
}

#pragma mark - FeedListDataSourceDelegate

- (void)configureCell:(UITableViewCell *__autoreleasing *)cell withFeed:(Feed *)feed
{
    /*!
     Since we have a pointer to a pointer, we need to dereference cell to actually modify its pointee.
     */
    if (*cell == nil) {
        *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"FeedCell"];
        (*cell).backgroundColor = [UIColor colorWithRed:205.0/255.0 green:212.0/255.0 blue:226.0/255.0 alpha:1.0];
    }
    (*cell).textLabel.text = feed.title;
    (*cell).detailTextLabel.text = [feed.url absoluteString];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Feed *feed = [self.feedListDataSource feedAtIndexPath:indexPath];
    
    ItemListViewController *itemListViewController = [[ItemListViewController alloc] initWithNibName:@"ListView" bundle:nil];
    itemListViewController.feed = feed;
    
    [self.navigationController pushViewController:itemListViewController animated:YES];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FeedListTableSectionHeader *headerView = [[NSBundle mainBundle] loadNibNamed:@"FeedListTableSectionHeader" owner:self options:nil][0];
    headerView.title.text = [self.feedListDataSource tableView:tableView titleForHeaderInSection:section];
    
    return headerView;
}

#pragma mark - Custom Actions

- (void)openNewFeedView:(id)sender
{
    NewFeedViewController *newFeedViewController = [[NewFeedViewController alloc] initWithNibName:@"NewFeedView" bundle:nil];
    newFeedViewController.managedObjectContext = self.managedObjectContext;
    
    [self presentViewController:[[NavigationViewController alloc] initWithRootViewController:newFeedViewController]
                       animated:YES
                     completion:nil];
}

@end