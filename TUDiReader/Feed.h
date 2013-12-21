//
//  Feed.h
//  TUDiReader
//
//  Created by Martin Weißbach on 11/4/13.
//  Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Group;

/*!
    Keeps all information on a given RSS feed.
 */
@interface Feed : NSObject

/// User-specific title of the RSS feed.
@property (nonatomic) NSString *title;
/// URL used to fetch new RSS articles.
@property (nonatomic) NSURL *url;
/// The Group the feed belongs to.
@property (nonatomic) Group *group;

/*!
    Designated initializer used to set the feed's title and URL right on instanziation.
    
    @param title    The user-specific title of the feed.
    @param url      URL used to fetch new RSS articles.
    @param group    The Group the new feed instance belongs to.
    
    @return         A new instance of Feed storing the above specified information.
 */
- (id)initWithTitle:(NSString *)title andURL:(NSURL *)url belongsToGroup:(Group *)group;

@end
