//
//  Item.h
//  TUDiReader
//
//  Created by Martin Weißbach on 11/18/13.
//  Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *author;
@property (nonatomic) NSString *dateString;
@property (nonatomic) NSString *summary;
@property (nonatomic) NSString *guid;

- (NSString *)htmlSummary;

@end
