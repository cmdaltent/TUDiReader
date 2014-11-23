//
//  CreateGroupViewController.m
//  TUDiReader
//
//  Created by Martin Weissbach on 11/3/14.
//  Copyright (c) 2014 Martin Weissbach. All rights reserved.
//

#import "CreateGroupViewController.h"

#import "PersistenceStack.h"
#import "Group.h"

@interface CreateGroupViewController ()
@property (weak, nonatomic) IBOutlet UITextField *groupNameTextField;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end

@implementation CreateGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender
{
    NSManagedObjectContext *managedObjectContext = [PersistenceStack sharedPersistenceStack].managedObjectContext;
    
    Group *group = [[Group alloc] initWithEntity:[NSEntityDescription entityForName:@"Group" inManagedObjectContext:managedObjectContext]
                  insertIntoManagedObjectContext:managedObjectContext];
    
    group.name = self.groupNameTextField.text;
    
    NSError *saveError = nil;
    [managedObjectContext save:&saveError];
    if (saveError)
    {
        NSLog(@"Could not save Group.");
    }
    
    [self cancel:self];
}
























@end
