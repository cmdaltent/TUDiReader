//
//  Group.h
//  TUDiReader
//
//  Created by Martin Weissbach on 21/12/13.
//  Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Feed;

@interface Group : NSObject

@property (readonly, nonatomic) NSString *title;
@property (readonly, nonatomic) NSArray *feeds;

- (id)initWithTitle:(NSString *)title;

- (void)addFeed:(Feed *)feed;

@end
