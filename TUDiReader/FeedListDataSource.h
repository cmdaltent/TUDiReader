//
//  FeedListDataSource.h
//  TUDiReader
//
//  Created by Martin Weissbach on 13/01/14.
//  Copyright (c) 2014 Technische Universität Dresden. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Feed;

@protocol FeedListDataSourceDelegate;

@interface FeedListDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, weak) id<FeedListDataSourceDelegate> delegate;

- (id)initWithTableView:(UITableView *)tableView cellReuseIdentifier:(NSString *)reuseIdentifier managedObjectContext:(NSManagedObjectContext *)managedObjectContext;

- (Feed *)feedAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol FeedListDataSourceDelegate <NSObject>

- (void)configureCell:(UITableViewCell * __autoreleasing *)cell withFeed:(Feed *)feed;

@end