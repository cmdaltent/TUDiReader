//
//  Feed.m
//  TUDiReader
//
//  Created by Martin Weißbach on 11/4/13.
//  Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//

#import "Feed.h"

@implementation Feed

- (id)initWithTitle:(NSString *)title andURL:(NSURL *)url
{
    self = [super init];
    if (self) {
        self.title = title;
        self.url = url;
    }
    
    return self;
}

@end
