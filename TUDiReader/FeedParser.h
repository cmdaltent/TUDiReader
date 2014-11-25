//
//  FeedParser.h
//  TUDiReader
//
//  Created by Martin Weissbach on 11/24/14.
//  Copyright (c) 2014 Martin Weissbach. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedParser : NSOperation

@property (copy) void (^parsingFinishedBlock)(NSArray *items);

- (instancetype)initWithData:(NSData *)data;

@end
