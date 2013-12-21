//
//  Groups.m
//  TUDiReader
//
//  Created by Martin Weissbach on 21/12/13.
//  Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//

#import "Groups.h"

@implementation Groups
{
    __strong NSMutableArray *_groups;
}

- (void)dealloc
{
    _groups = nil;
}

- (id)init
{
    self = [super init];
    if (self) {
        _groups = [NSMutableArray arrayWithCapacity:10];
    }
    
    return self;
}

- (void)addGroup:(Group *)group
{
    if (![_groups containsObject:group]) {
        [_groups addObject:group];
    } else return;
}

- (void)addGroups:(NSSet *)groups
{
    [_groups addObjectsFromArray:[groups allObjects]];
}

- (void)removeGroup:(Group *)group
{
    [_groups removeObject:group];
}

- (void)removeGroups:(NSSet *)groups
{
    [_groups removeObjectsInArray:[groups allObjects]];
}

- (Group *)groupAtIndex:(NSUInteger)position
{
    return [_groups objectAtIndex:position];
}

- (NSArray *)allGroups
{
    return [_groups copy];
}

- (NSUInteger)count
{
    return _groups.count;
}

@end
