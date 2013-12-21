//
//  Group.m
//  TUDiReader
//
//  Created by Martin Weissbach on 21/12/13.
//  Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//

#import "Group.h"

@interface Group ()

@property (readwrite, nonatomic) NSString *title;
@property (readwrite, nonatomic) NSArray *feeds;

@end

@implementation Group

- (id)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        self.title = title;
    }
    
    return self;
}

- (void)addFeed:(Feed *)feed
{
    if ([self.feeds containsObject:feed]) {
        return;
    }
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.feeds];
    [tempArray addObject:feed];
    self.feeds = [NSArray arrayWithArray:tempArray];
}

#pragma mark - Object Comparison

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[Group class]]) {
        return NO;
    } else if ([self hash] == [object hash]) {
        return YES;
    } else return NO;
}

- (NSUInteger)hash
{
    return [self.title hash];
}

@end
