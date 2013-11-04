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

@interface NewFeedViewController ()

@property (weak, nonatomic) IBOutlet UITextField *feedTitleTextField;
@property (weak, nonatomic) IBOutlet UITextField *feedURLTextField;
@property (weak, nonatomic) IBOutlet UIView *contentView;

- (IBAction)saveFeed:(id)sender;

@end

@implementation NewFeedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidLayoutSubviews
{
    /*!
        Check out the iOS Basics II slides for further information on how this works.
        http://www.rn.inf.tu-dresden.de/lectures/iP/03_iOS%20Basics%20II.pdf
     */
    CGRect frame = self.contentView.frame;
    frame.origin.y = self.topLayoutGuide.length;
    self.contentView.frame = frame;
}

- (NSString *)title
{
    return @"New Feed";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction

- (IBAction)saveFeed:(id)sender {
    Feed *feed = [[Feed alloc] initWithTitle:self.feedURLTextField.text
                                      andURL:[NSURL URLWithString:self.feedURLTextField.text]];
    /*!
        The saveFeed: method here is known from the NewFeedViewControllerDelegate.
     */
    [self.delegate saveFeed:feed];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
