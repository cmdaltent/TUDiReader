//
//  ItemListViewController.m
//  TUDiReader
//
//  Created by Martin Weißbach on 11/11/13.
//  Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//

#import "ItemListViewController.h"

#import "Feed.h"

@interface ItemListViewController ()

@property (nonatomic) NSArray *items;

@end

@implementation ItemListViewController

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
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
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
    static NSString *CellIdentifier = @"Cell";
    // FIXME: App will crash at this line. Fix it.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

@end
