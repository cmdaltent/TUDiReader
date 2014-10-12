//
//  FeedParser.h
//  TUDiReader
//
//  Created by Martin Weißbach on 11/18/13.
//  Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedParser : NSOperation

@property (nonatomic, copy) void (^parsingFinishedBlock)(NSArray *items);

- (id)initWithData:(NSData *)data;

@end
