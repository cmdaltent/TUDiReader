//
//  Group.m
//  TUDiReader
//
//  Created by Martin Weissbach on 11/3/14.
//  Copyright (c) 2014 Martin Weissbach. All rights reserved.
//

#import "Group.h"
#import "PersistenceStack.h"

@implementation Group

@dynamic feeds;
@dynamic name;

- (NSArray *)orderedFeeds
{
    return [self.feeds sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]]];
}

+ (NSEntityDescription *)entityDescription
{
    return [NSEntityDescription entityForName:@"Group" inManagedObjectContext:[PersistenceStack sharedPersistenceStack].managedObjectContext];
}

@end
