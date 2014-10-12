//
//  NewFeedViewController.m
//  TUDiReader
//
//  Created by Martin Weißbach on 10/28/13.
//  Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//

#import "NewFeedViewController.h"

#import "Feed.h"
#import "Group.h"

#import "FeedListViewController.h"
#import "NewFeedSupportViewController.h"

typedef enum _GroupSections {
    NewGroupSection,
    CustomGroupSection
} GroupSections;

@interface NewFeedViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *feedTitleTextField;
@property (weak, nonatomic) IBOutlet UITextField *feedURLTextField;
@property (weak, nonatomic) IBOutlet UIView *feedTitleContainerView;
@property (weak, nonatomic) IBOutlet UIView *feedURLContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *groupTableViewHeight;

@property (nonatomic) NSArray *groups;
@property (nonatomic) NSIndexPath *selectedGroupPath;

- (void)saveFeed:(id)sender;
- (void)recalculateGroupTableViewHeight;

@end

@implementation NewFeedViewController

static void *KVOContext = &KVOContext;

- (void)dealloc
{
    [self.feedURLTextField removeObserver:self forKeyPath:@"text"];
    [self.feedTitleTextField removeObserver:self forKeyPath:@"text"];
    [self removeObserver:self forKeyPath:@"selectedGroupPath"];
    
    self.selectedGroupPath = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveFeed:)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [self.feedURLContainerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openSupportViewController:)]];
    [self.feedTitleContainerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openSupportViewController:)]];
    
    [self.feedTitleTextField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:KVOContext];
    [self.feedURLTextField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:KVOContext];
    [self addObserver:self forKeyPath:@"selectedGroupPath" options:NSKeyValueObservingOptionNew context:KVOContext];
    
    [self updateGroups];
    [self recalculateGroupTableViewHeight];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == KVOContext) {
        if (self.selectedGroupPath && ![self.feedURLTextField.text isEqualToString:@""] && ![self.feedURLTextField.text isEqualToString:@""]) {
            self.navigationItem.rightBarButtonItem.enabled = YES;
        } else self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

- (NSString *)title
{
    return @"New Feed";
}

#pragma mark - Custom Actions

- (void)saveFeed:(id)sender {
    Group *group = [self.groups objectAtIndex:self.selectedGroupPath.row];
    [Feed insertWithTitle:self.feedTitleTextField.text url:[NSURL URLWithString:self.feedURLTextField.text] group:group inManagedObjectContext:self.managedObjectContext];
    
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
        Compare memory addresses of the view is sufficient here.
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == NewGroupSection) {
        return 1;
    } else if (section == CustomGroupSection) {
        return self.groups.count;
    } else return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GroupCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section == NewGroupSection) {
        cell.textLabel.text = @"Add Group";
    } else {
        cell.textLabel.text = [[self.groups objectAtIndex:indexPath.row] title];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == CustomGroupSection) {
        [tableView cellForRowAtIndexPath:self.selectedGroupPath].accessoryType = UITableViewCellAccessoryNone;
        self.selectedGroupPath = indexPath;
    }
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == NewGroupSection) {
        NewFeedSupportViewController *supportViewController = [[NewFeedSupportViewController alloc] initWithTitle:@"New Group"
                                                                                                  predefinedValue:nil
                                                                                                  completionBlock:^(NSString *groupName) {
                                                                                                      
                                                                                                      [Group insertWithTitle:groupName inManagedObjectContext:self.managedObjectContext];
                                                              
                                                                                                      [self updateGroups];
                                                                                                      [self recalculateGroupTableViewHeight];
                                                                                                      [tableView reloadData];
                                                                                                  }];
        [self.navigationController pushViewController:supportViewController animated:YES];
    } else {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

#pragma mark - User Interface Helper

- (void)updateGroups
{
    self.groups = [self.managedObjectContext executeFetchRequest:[NSFetchRequest fetchRequestWithEntityName:@"Group"] error:NULL];
}

- (void)recalculateGroupTableViewHeight
{
    self.groupTableViewHeight.constant = 44.0 + (44.0 * self.groups.count);
    
    [self.view needsUpdateConstraints];
}

@end
