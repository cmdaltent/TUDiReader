//
//  Feed.m
//  TUDiReader
//
//  Created by Martin Weissbach on 10/20/14.
//  Copyright (c) 2014 Martin Weissbach. All rights reserved.
//

#import "Feed.h"

@implementation Feed

- (instancetype)initWithTitle:(NSString *)title andURL:(NSURL *)url
{
    if ( (self = [super init]) )
    {
        self.title = title;
        self.url = url;
    }
    
    return self;
}

@end
