//
//  Group.h
//  TUDiReader
//
//  Created by Martin Weissbach on 11/3/14.
//  Copyright (c) 2014 Martin Weissbach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Group : NSManagedObject

@property NSString *name;
@property NSSet *feeds;

- (NSArray *)orderedFeeds;

+ (NSEntityDescription *)entityDescription;

@end
