//
//  FeedsListTableViewController.m
//  TUDiReader
//
//  Created by Martin Weissbach on 10/20/14.
//  Copyright (c) 2014 Martin Weissbach. All rights reserved.
//

#import "FeedsListTableViewController.h"

#import "Feed.h"

@interface FeedsListTableViewController ()

@property NSArray *feeds;

- (IBAction)addFeed:(id)sender;

@end

@implementation FeedsListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.feeds = @[ [[Feed alloc] initWithTitle:@"Test" andURL:[NSURL URLWithString:@"http://localhost"]] ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        UIViewController *controller = [[segue destinationViewController] topViewController];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
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


- (IBAction)addFeed:(id)sender {
    NSLog(@"Add Button Clicked.");
}

@end
