//
//  CreateGroupViewController.m
//  TUDiReader
//
//  Created by Martin Weissbach on 11/3/14.
//  Copyright (c) 2014 Martin Weissbach. All rights reserved.
//

#import "CreateGroupViewController.h"

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
    // TODO:
    
    [self cancel:self];
}
@end
