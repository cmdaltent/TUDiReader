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

@end

@implementation Group

@dynamic title, feeds;

+ (instancetype)insertWithTitle:(NSString *)title inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    Group *group = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:managedObjectContext];
    group.title = title;
    
    return group;
}

+ (NSString *)entityName
{
    return @"Group";
}

@end
