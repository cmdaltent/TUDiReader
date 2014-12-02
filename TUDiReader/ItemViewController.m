//
//  ItemViewController.m
//  TUDiReader
//
//  Created by Martin Weissbach on 12/1/14.
//  Copyright (c) 2014 Martin Weissbach. All rights reserved.
//

#import "ItemViewController.h"

#import "Item.h"

@interface ItemViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = self.item.title;
    self.authorLabel.text = self.item.author;
    [self.webView loadHTMLString:self.item.summary baseURL:nil];
}


@end
