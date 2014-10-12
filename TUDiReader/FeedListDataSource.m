//
//  FeedListDataSource.m
//  TUDiReader
//
//  Created by Martin Weissbach on 13/01/14.
//  Copyright (c) 2014 Technische Universität Dresden. All rights reserved.
//

#import "FeedListDataSource.h"

#import "Feed.h"
#import "Group.h"

#import <CoreData/CoreData.h>

@interface FeedListDataSource () <NSFetchedResultsControllerDelegate>

@property (nonatomic) NSFetchedResultsController *resultsController;
@property (nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSString *reuseIdentifier;

@end

@implementation FeedListDataSource

- (id)initWithTableView:(UITableView *)tableView cellReuseIdentifier:(NSString *)reuseIdentifier managedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    self = [super init];
    if (self) {
        self.tableView = tableView;
        self.reuseIdentifier = reuseIdentifier;
        self.managedObjectContext = managedObjectContext;
        
        self.tableView.dataSource = self;
        
        [self setupResultsController];
    }
    
    return self;
}
- (void)setupResultsController
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Group"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    
    self.resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"title" cacheName:nil];
    
    self.resultsController.delegate = self;
    [self.resultsController performFetch:NULL];
}

- (Feed *)feedAtIndexPath:(NSIndexPath *)indexPath
{
    return [[((Group *)[self.resultsController.fetchedObjects objectAtIndex:indexPath.section]).feeds allObjects] objectAtIndex:indexPath.row];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.resultsController performFetch:NULL];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.resultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((Group *)[self.resultsController.fetchedObjects objectAtIndex:section]).feeds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Feed *feed = [[((Group *)[self.resultsController.fetchedObjects objectAtIndex:indexPath.section]).feeds allObjects] objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.reuseIdentifier];
    
    [self.delegate configureCell:&cell withFeed:feed];
    
    return cell;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[self.resultsController.sections objectAtIndex:section] name];
}

@end
