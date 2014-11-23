//
//  AddGroupTableViewController.m
//  TUDiReader
//
//  Created by Martin Weissbach on 11/3/14.
//  Copyright (c) 2014 Martin Weissbach. All rights reserved.
//

#import "AddGroupTableViewController.h"

#import "Group.h"
#import "PersistenceStack.h"

@interface AddGroupTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property NSArray *groups;

@property (weak, nonatomic) IBOutlet UITableView *groupsTableView;

@end

@implementation AddGroupTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateGroups:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:nil];
    
    [self updateGroups:self];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)updateGroups:(id)sender
{
    NSManagedObjectContext *managedObjectContext = [PersistenceStack sharedPersistenceStack].managedObjectContext;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Group"];
    NSError *fetchError;
    
    self.groups = [managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
    if (fetchError)
    {
        NSLog(@"Could not fetch Groups.");
        return;
    }
    
    [self.groupsTableView reloadData];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddGroupCell" forIndexPath:indexPath];
    
    Group *group = self.groups[indexPath.row];
    cell.textLabel.text = group.name;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Group *group = self.groups[indexPath.row];
    if (self.completionBlock)
    {
        self.completionBlock(group);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
