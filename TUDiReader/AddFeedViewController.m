//
//  AddFeedViewController.m
//  TUDiReader
//
//  Created by Martin Weissbach on 10/27/14.
//  Copyright (c) 2014 Martin Weissbach. All rights reserved.
//

#import "AddFeedViewController.h"

#import "AddGroupTableViewController.h"

#import "Feed.h"
#import "PersistenceStack.h"

@interface AddFeedViewController ()

@property Group *selectedGroup;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *urlStringTextField;
@property (weak, nonatomic) IBOutlet UIButton *addGroupButton;
@property (weak, nonatomic) IBOutlet UILabel *selectedGroupLabel;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end

static void *KVOContext = &KVOContext;

@implementation AddFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addObserver:self forKeyPath:@"selectedGroup" options:NSKeyValueObservingOptionNew context:KVOContext];
}

- (void)dealloc
{
    /**
    * Key-Value-Observing (KVO)
    * We must ensure to remove the registered observer from the instances dispatch table before the instance is
    * ultimately deallocated.
    */
    [self removeObserver:self forKeyPath:@"selectedGroup" context:KVOContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (self.selectedGroup)
    {
        [self.addGroupButton setTitle:@"Change Group" forState:UIControlStateNormal];
        self.selectedGroupLabel.text = self.selectedGroup.name;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [segue.identifier isEqualToString:@"AddGroupSegue"] )
    {
        AddGroupTableViewController *destination = (AddGroupTableViewController *)segue.destinationViewController;
        destination.completionBlock = ^(Group *selectedGroup) {
            self.selectedGroup = selectedGroup;
        };
    }
}

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender
{
    NSString *title = self.titleTextField.text;
    NSURL *url = [NSURL URLWithString:self.urlStringTextField.text];
    
    NSManagedObjectContext *managedObjectContext = [PersistenceStack sharedPersistenceStack].managedObjectContext;
    Feed *feed = [[Feed alloc] initWithEntity:[NSEntityDescription entityForName:@"Feed" inManagedObjectContext:managedObjectContext]
               insertIntoManagedObjectContext:managedObjectContext];
    feed.group = self.selectedGroup;
    feed.title = title;
    feed.url = url;
    
    [managedObjectContext save:nil];
    
    [self cancel:self];
}

@end
