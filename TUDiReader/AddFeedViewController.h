//
//  AddFeedViewController.h
//  TUDiReader
//
//  Created by Martin Weissbach on 10/27/14.
//  Copyright (c) 2014 Martin Weissbach. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddFeedViewControllerDelegate;
@class Feed;

@interface AddFeedViewController : UIViewController

@property (weak) id<AddFeedViewControllerDelegate> delegate;

@end

@protocol AddFeedViewControllerDelegate <NSObject>

- (void)feedCreated:(Feed *)feed;

@end