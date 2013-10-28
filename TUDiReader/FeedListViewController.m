//
//  FeedListViewController.m
//  TUDiReader
//
//  Created by Martin Weißbach on 10/28/13.
//  Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//

#import "FeedListViewController.h"

@interface FeedListViewController () <UITableViewDataSource, UITableViewDelegate>

/// Feeds that are stored and displayed in this view.
@property (strong, nonatomic) NSArray *feeds;

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

    self.feeds = [NSArray arrayWithObjects:@"Feed 1", @"Feed 2", @"Feed 3", nil];
    
    /*!
        The navigation item represents the view controller in a parent's view navigation controller.
        It is inherited from UIViewController and only visible when the view was added to a navigation controller's view stack.
     
        The _target_ of the UIBarButton item is the receiver of messages that will be sent when the button reckognizes a touch event.
        The _action_ is the name of the message sent when the button detects a touch event.
     */
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                           target:self
                                                                                           action:@selector(openNewFeedView:)];
    /*!
        Just an example why the dot-syntax for properties is so much nicer than using the actual getter and setter methods ;)
     [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                                target:self
                                                                                                action:@selector(openNewFeedView:)]];
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
/*!
    Implementation of UITableViewDataSource methods.
 
    numberOfSectionsInTableView:
    tableView:numberOfRowsInSection:
    tableView:cellForRowAtIndexPath:
 
    are mandatory.
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*!
        Return the number of rows in the respective section.
        Since we have only one section and a one-dimensional array as a data structure we can simply return the number of
        items in the array.
     */
    return self.feeds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*!
        The _reuseIdentifier_ is used to identify the cell object if it is to be reused.
        If you pass nil as a reuse identifier, the cell will not be reused.
        The same reuse identifier should be used for cells that have the same form. Consequently, multiple different reuse identifiers
        are possible for differently formed cells.
     */
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self.feeds objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Custom Actions

- (void)openNewFeedView:(id)sender
{
    NSLog(@"openNewFeedView: clicked.");
}

@end
