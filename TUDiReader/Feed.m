//
//  Feed.m
//  TUDiReader
//
//  Created by Martin Weißbach on 11/4/13.
//  Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//

#import "Feed.h"

@implementation Feed

- (id)initWithTitle:(NSString *)title andURL:(NSURL *)url belongsToGroup:(Group *)group
{
    self = [super init];
    if (self) {
        self.title = title;
        self.url = url;
        self.group = group;
    }
    
    return self;
}

#pragma mark - Object Comparison

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[Feed class]]) {
        return NO;
    } else if ([object hash] == [self hash]) {
        return YES;
    } else return NO;
}

- (NSUInteger)hash
{
    return [self.title hash] | [self.url hash];
}

@end
