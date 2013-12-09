//
//  NewFeedViewController.m
//  TUDiReader
//
//  Created by Martin Weißbach on 10/28/13.
//  Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//

#import "NewFeedViewController.h"

#import "Feed.h"
#import "FeedListViewController.h"
#import "NewFeedSupportViewController.h"

@interface NewFeedViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *feedTitleTextField;
@property (weak, nonatomic) IBOutlet UITextField *feedURLTextField;
@property (weak, nonatomic) IBOutlet UIView *feedTitleContainerView;
@property (weak, nonatomic) IBOutlet UIView *feedURLContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *groupTableViewHeight;

@property (nonatomic) NSArray *groups;

- (void)saveFeed:(id)sender;

@end

@implementation NewFeedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.groups = [NSArray array];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveFeed:)];
    
    [self.feedURLContainerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openSupportViewController:)]];
    [self.feedTitleContainerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openSupportViewController:)]];
    
    self.groupTableViewHeight.constant = 44.0 + (44.0 * self.groups.count);
    
    [self.view needsUpdateConstraints];
}

- (NSString *)title
{
    return @"New Feed";
}

#pragma mark - Custom Actions

- (void)saveFeed:(id)sender {
    Feed *feed = [[Feed alloc] initWithTitle:self.feedTitleTextField.text
                                      andURL:[NSURL URLWithString:self.feedURLTextField.text]];
    /*!
        The saveFeed: method here is known from the NewFeedViewControllerDelegate.
     */
    [self.delegate saveFeed:feed];
    [self cancel:self];
}

- (void)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)openSupportViewController:(UITapGestureRecognizer *)sender
{
    NewFeedSupportViewController *newFeedSuppoortViewController = nil;
    /*!
        Compare
     */
    if (sender.view == self.feedTitleContainerView) {
        newFeedSuppoortViewController = [[NewFeedSupportViewController alloc] initWithTitle:@"Feed Title"
                                                                            predefinedValue:self.feedTitleTextField.text
                                                                            completionBlock:^(NSString *title) {
                                                                                self.feedTitleTextField.text = title;
                                                                            }];
    } else if (sender.view == self.feedURLContainerView) {
        newFeedSuppoortViewController = [[NewFeedSupportViewController alloc] initWithTitle:@"Feed Address"
                                                                            predefinedValue:self.feedURLTextField.text
                                                                            completionBlock:^(NSString *url) {
                                                                                self.feedURLTextField.text = url;
                                                                            }];
    } else return;
    [self.navigationController pushViewController:newFeedSuppoortViewController animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1 + (self.groups ? self.groups.count : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GroupCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (!indexPath.row) {
        cell.textLabel.text = @"Add Group";
    } else {
        // Cell set Group Name here.
    }
    return cell;
}

@end
