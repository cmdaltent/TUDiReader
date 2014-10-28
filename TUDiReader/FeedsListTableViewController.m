//
//  FeedsListTableViewController.m
//  TUDiReader
//
//  Created by Martin Weissbach on 10/20/14.
//  Copyright (c) 2014 Martin Weissbach. All rights reserved.
//

#import "FeedsListTableViewController.h"

#import "Feed.h"
#import "AddFeedViewController.h"

@interface FeedsListTableViewController () <AddFeedViewControllerDelegate>
{
    BOOL _isViewDisplayed;
}

@property NSArray *feeds;

@end

@implementation FeedsListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.feeds = @[ [[Feed alloc] initWithTitle:@"Test" andURL:[NSURL URLWithString:@"http://localhost"]] ];
    
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

    if ( [[segue identifier] isEqualToString:@"AddFeedSegue"])
    {
        AddFeedViewController *controller = (AddFeedViewController *)[[segue destinationViewController] topViewController];
        controller.delegate = self;
    }
}

- (void)feedCreated:(Feed *)feed
{
    NSMutableArray *tmp = [self.feeds mutableCopy];
    if (feed)
        [tmp addObject:feed];
    self.feeds = [tmp copy];
    
    if (_isViewDisplayed)
        [(UITableView *)self.view reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.feeds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedCell" forIndexPath:indexPath];
    
    Feed *feed = [self.feeds objectAtIndex:indexPath.row];
    cell.textLabel.text = feed.title;
    cell.detailTextLabel.text = [feed.url absoluteString];
    
    return cell;
}

@end
