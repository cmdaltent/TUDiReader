//
//  NewFeedViewController.h
//  TUDiReader
//
//  Created by Martin Weißbach on 10/28/13.
//  Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FeedListViewController;
@class Feed;

@protocol NewFeedViewControllerDelegate;

/*!
    Controls the NewFeedView. 
 */
@interface NewFeedViewController : UIViewController

/// The delegate object will be invoked when a new feed is ready for being stored.
@property (nonatomic,weak) id<NewFeedViewControllerDelegate> delegate;

@end

/*!
    The protocol each object, assigned as a delegate of NewFeedViewController, has to adhere to.
    Instead of using the FeedListViewController directly as type of delegate, we choose this approach to make
    the delegate object easily exchangeable, because any object can take the delegate role as long as it conforms to the protocol.
 */
@protocol NewFeedViewControllerDelegate <NSObject>

/*!
    This method is sent to the delegate when a feed is ready to be stored somewhere.
    This method is mandatory.
    
    @param feed The feed object that contains all information related to a new RSS feed.
    
    @see Feed
 */
- (void)saveFeed:(Feed *)feed;

@end