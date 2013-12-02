//
//  WebViewController.m
//  TUDiReader
//
//  Created by Martin Weißbach on 12/2/13.
//  Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewController
{
    NSURL *_url;
}

- (id)initWithURL:(NSURL *)url
{
//    self = [super init]; // Works as well
    self = [super initWithNibName:@"WebView" bundle:nil];
    if (self) {
        _url = url;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:_url]];
}

@end
