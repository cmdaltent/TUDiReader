//
//  Feed.h
//  TUDiReader
//
//  Created by Martin Weissbach on 10/20/14.
//  Copyright (c) 2014 Martin Weissbach. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Feed : NSObject

@property NSString *title;
@property NSURL *url;

- (instancetype)initWithTitle:(NSString *)title andURL:(NSURL *)url;

@end
