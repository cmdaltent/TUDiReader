//
//  Feed.h
//  TUDiReader
//
//  Created by Martin Weissbach on 10/20/14.
//  Copyright (c) 2014 Martin Weissbach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "Group.h"
#import "Item.h"

@interface Feed : NSManagedObject

@property NSString *title;
@property NSURL *url;

@property Group *group;
@property NSSet *items;

- (void)addItems:(NSArray *)items;

@end
