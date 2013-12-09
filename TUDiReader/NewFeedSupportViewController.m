//
//  NewFeedSupportViewController.m
//  TUDiReader
//
//  Created by Martin Weißbach on 12/9/13.
//  Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//

#import "NewFeedSupportViewController.h"

@interface NewFeedSupportViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation NewFeedSupportViewController
{
    NSString *_title;
    NSString *_value;
    void (^_completionBlock)(NSString *);
}

- (id)initWithTitle:(NSString *)title predefinedValue:(NSString *)value completionBlock:(void (^)(NSString *))completionBlock
{
    self = [super initWithNibName:@"NewFeedSupportView" bundle:nil];
    if (self) {
        _title = title;
        _value = value;
        _completionBlock = completionBlock;
    }
    
    return self;
}

- (NSString *)title
{
    return _title;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.textField.text = _value;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    _completionBlock(self.textField.text);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /*!
        Text field is made first responder when the view is about to appear.
        Hence, the keyboard is displayed.
     */
    [self.textField becomeFirstResponder];
}



























@end
