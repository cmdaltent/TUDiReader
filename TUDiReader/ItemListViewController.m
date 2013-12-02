//
//  ItemListViewController.m
//  TUDiReader
//
//  Created by Martin Weißbach on 11/11/13.
//  Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//

#import "ItemListViewController.h"

#import "Feed.h"
#import "FeedParser.h"
#import "Item.h"
#import "ItemPreviewTableViewCell.h"
#import "ItemViewController.h"

@interface ItemListViewController ()

@property (nonatomic) NSArray *items;

@end

@implementation ItemListViewController
{
    FeedParser *_parser;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*!
        Default configuration – similar behavior to an NSURLConnectionObject
        e.g. caching policies, timeouts
     */
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //  Initialize a new session with the given default configuration
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    /*!
        Only NSURLSession can create session tasks.
        Data tasks return data directly to the app instead of through a file like a download task would do.
        
        url:        URL to request data from
        handler:    block that is executed when the request completed the block is executed on a serial queue by default
                    the serial queue is created by the sessionWithConfiguration: method
                    consequently, if you'd acces UI objects, you should dispatch operations in the block to the main queue
     */
    NSURLSessionDataTask *sessionTask = [session dataTaskWithURL:self.feed.url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        _parser = [[FeedParser alloc] initWithData:data];
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        /*!
            References in the block body are retained, regardless their declaration outside the block as strong or weak.
            If 'self' would be used in the block's body directly, the block itself would hold a strong reference to 'self' –
            the ItemListViewController instance in this case. Simultaneously the ItemListViewcontroller holds a strong reference
            to the FeedParser instance which owns the property.
            Hence, the block and the ItemListViewController retain each other and would never get released – a retain cycle.
         
            Instead of using 'self' directly in the block body, we create a variable that points weakly to 'self', which is weakSelf.
            weakSelf is now retained by the block, but as it points to the ItemListViewController's 'self' weakly – it's not retaining it,
            a retain cycle is not introduced because weakSelf can be released, when the block is released.
         */
        ItemListViewController *__weak weakSelf = self;
        _parser.parsingFinishedBlock = ^(NSArray *items) {
            weakSelf.items = items;
            [((UITableView *)weakSelf.view) reloadData];
        };
        NSOperationQueue *parserQueue = [NSOperationQueue new];
        parserQueue.maxConcurrentOperationCount = 1;
        [parserQueue addOperation:_parser]; //  When the operation is ready for execution, the NSOperation's main method will be invoked by the system.
    }];
    [sessionTask resume]; // launch the request
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)title
{
    return self.feed.title;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items ? self.items.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ItemCell";
    ItemPreviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ItemPreviewTableViewCell" owner:self options:nil] firstObject];
    }
    
    Item *item = [self.items objectAtIndex:indexPath.row];
    cell.titleLabel.text = item.title;
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Item *item = [self.items objectAtIndex:indexPath.row];
    ItemViewController *itemViewController = [[ItemViewController alloc] initWitItem:item];
    [self.navigationController pushViewController:itemViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Item *item = [self.items objectAtIndex:indexPath.row];
    return [ItemPreviewTableViewCell expectedHeightWithTitle:item.title];
}

@end
