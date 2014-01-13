//
//  Group.h
//  TUDiReader
//
//  Created by Martin Weissbach on 21/12/13.
//  Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Feed;

@interface Group : NSManagedObject

@property (readonly, nonatomic) NSString *title;
@property (nonatomic) NSArray *feeds;

+ (instancetype)insertWithTitle:(NSString *)title inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

+ (NSString *)entityName;

@end
