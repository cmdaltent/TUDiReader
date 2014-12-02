//
//  Item.h
//  TUDiReader
//
//  Created by Martin Weissbach on 11/24/14.
//  Copyright (c) 2014 Martin Weissbach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Feed;

@interface Item : NSManagedObject

@property NSString *title;
@property NSString *author;
@property NSString *dateString;
@property NSString *summary;
@property NSString *guid;
@property BOOL read;

@property Feed *feed;

@end
