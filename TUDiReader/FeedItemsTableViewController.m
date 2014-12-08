//
//  FeedItemsTableViewController.m
//  TUDiReader
//
//  Created by Martin Weissbach on 11/24/14.
//  Copyright (c) 2014 Martin Weissbach. All rights reserved.
//

#import "FeedItemsTableViewController.h"

#import "Feed.h"
#import "FeedParser.h"
#import "Item.h"
#import "ItemViewController.h"
#import "PersistenceStack.h"

@interface FeedItemsTableViewController ()

@property NSArray *items;

@property NSURLSession *session;

@property UIRefreshControl *refreshControl;

@end

@implementation FeedItemsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = self.feed.title;

    if ( self.feed.items.count > 0 )
    {
        self.items = [self.feed.items allObjects];
    }
    else
    {
        [self fetchItems:nil];
    }
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchItems:) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [segue.identifier isEqualToString:@"showItemSegue"] )
    {
        ItemViewController *itemViewController = (ItemViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        itemViewController.item = self.items[indexPath.row];
        itemViewController.item.read = YES;
        
        [[PersistenceStack sharedPersistenceStack].managedObjectContext save:nil];

        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)fetchItems:(UIRefreshControl *)sender
{
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
    NSURLSessionTask *task = [self.session dataTaskWithURL:self.feed.url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        FeedParser *parser = [[FeedParser alloc] initWithData:data];
        parser.parsingFinishedBlock = ^(NSArray *items) {
            [self.feed addItems:items];
            self.items = [self.feed.items allObjects];
            [[PersistenceStack sharedPersistenceStack].managedObjectContext save:nil];
            
            if ( sender )
            {
                [sender endRefreshing];
            }
            
            [self.tableView reloadData];
        };
        NSOperationQueue *queue = [NSOperationQueue new];
        queue.qualityOfService = NSOperationQualityOfServiceUtility;
        queue.maxConcurrentOperationCount = 1;
        [queue addOperation:parser];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [task resume];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Item *item = (Item *)self.items[indexPath.row];
    NSString *identifier = @"feedItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:( (item.read) ? [identifier stringByAppendingString:@"Read"] : identifier )
                                                            forIndexPath:indexPath];
    
    cell.textLabel.text = item.title;
    return cell;
}

@end
