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

@interface FeedItemsTableViewController ()

@property NSArray *items;

@property NSURLSession *session;

@end

@implementation FeedItemsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = self.feed.title;

    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
    NSURLSessionTask *task = [self.session dataTaskWithURL:self.feed.url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        // TODO: Parse the returned data.
        FeedParser *parser = [[FeedParser alloc] initWithData:data];
        parser.parsingFinishedBlock = ^(NSArray *items) {
            self.items = [items copy];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"feedItemCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = ((Item *)self.items[indexPath.row]).title;
    
    return cell;
}

@end
