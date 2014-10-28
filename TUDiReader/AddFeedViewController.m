//
//  AddFeedViewController.m
//  TUDiReader
//
//  Created by Martin Weissbach on 10/27/14.
//  Copyright (c) 2014 Martin Weissbach. All rights reserved.
//

#import "AddFeedViewController.h"

#import "Feed.h"

@interface AddFeedViewController ()

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *urlStringTextField;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end

@implementation AddFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender
{
    NSString *title = self.titleTextField.text;
    NSURL *url = [NSURL URLWithString:self.urlStringTextField.text];
    
    Feed *feed = [[Feed alloc] initWithTitle:title andURL:url];
    
    if ( [self.delegate respondsToSelector:@selector(feedCreated:)] )
        [self.delegate feedCreated:feed];
    
    [self cancel:self];
}

@end
