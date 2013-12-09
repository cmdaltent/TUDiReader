//
//  WebViewController.m
//  TUDiReader
//
//  Created by Martin Weißbach on 12/2/13.
//  Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//

#import "WebViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface WebViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *activityView;
@property (weak, nonatomic) IBOutlet UIView *grayContainerView;

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
    
    /*!
        QuartzCore/QuartzCore.h required for this line
     */
    self.grayContainerView.layer.cornerRadius = 10.0;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.view addSubview:self.activityView];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:_url]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.activityView removeFromSuperview];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.activityView removeFromSuperview];
}


























@end
