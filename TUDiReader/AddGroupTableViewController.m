//
//  AddGroupTableViewController.m
//  TUDiReader
//
//  Created by Martin Weissbach on 11/3/14.
//  Copyright (c) 2014 Martin Weissbach. All rights reserved.
//

#import "AddGroupTableViewController.h"

#import "Group.h"

@interface AddGroupTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property NSArray *groups;

@property (weak, nonatomic) IBOutlet UITableView *groupsTableView;

@end

@implementation AddGroupTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - Table view data source

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

@end
