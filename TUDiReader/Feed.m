//
//  Feed.m
//  TUDiReader
//
//  Created by Martin Weissbach on 10/20/14.
//  Copyright (c) 2014 Martin Weissbach. All rights reserved.
//

#import "Feed.h"

@implementation Feed

/**
* The @dynamic directive does not generate accessor method, in contrast to @synthesize.
* It ensures the compiler that there will be appropriate accessor methods available at runtime.
* CoreData handles the message dispatch at runtime.
*/
@dynamic title;
@dynamic url;

@dynamic group;
@dynamic items;

- (void)addItems:(NSArray *)items
{
    NSMutableSet *set = [NSMutableSet setWithSet:self.items];
    [set addObjectsFromArray:items];
    self.items = [NSSet setWithSet:set];
}

@end
