//
//  ItemViewController.m
//  TUDiReader
//
//  Created by Martin Weißbach on 12/2/13.
//  Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//

#import "ItemViewController.h"

#import "Item.h"
#import "WebViewController.h"

@interface ItemViewController () <UIWebViewDelegate>

/*!
    Explicitely override the item property as read-write, otherwise no assignments are possible in the implementation.
    If not overriden, the instance variable _item is the only way to assign values to the variable.
 */
@property (nonatomic, readwrite) Item *item;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIWebView *contentWebView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentWebViewHeight;

@end

@implementation ItemViewController

- (id)initWitItem:(Item *)item
{
    self = [super initWithNibName:@"ItemView" bundle:nil];
    if (self) {
        /*!
            Outlets are still nil here.
            Store required information in instance variables.
         */
        self.item = item;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titleLabel.text = self.item.title;
    self.authorLabel.text = self.item.author;
    
    /*!
        UITapGestureRecognizer listens for single or multiple touch events on the view, the recognizer was added to.
        It is a concrete subclass of UIGestureRecognizer.
        target:     the object that is supposed to handle touch events on the view
        action:     the message sent to the target when a touch event occured.
     */
    [self.titleLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openItemSource:)]];
    
    self.contentWebView.scrollView.scrollEnabled = NO;  // disable scrolling behavior of UIWebView so it does not interfer with the UIScrollView.
    [self.contentWebView loadHTMLString:[self.item htmlSummary] baseURL:nil]; // start loading an HTML string.
}

#pragma mark - Custom Actions

- (void)openItemSource:(id)sender
{
    /*!
        The sender of this method is the UITapGestureRecognizer instance.
     */
    WebViewController *webViewController = [[WebViewController alloc] initWithURL:[NSURL URLWithString:self.item.guid]];
    [self.navigationController pushViewController:webViewController animated:YES];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *heightString = [webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"];
    self.contentWebViewHeight.constant = [heightString floatValue] + 15.0;
    [self.view needsUpdateConstraints];
}

@end
