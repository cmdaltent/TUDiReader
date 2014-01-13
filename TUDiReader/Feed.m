//
//  Feed.m
//  TUDiReader
//
//  Created by Martin Weißbach on 11/4/13.
//  Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//

#import "Feed.h"

@implementation Feed

+ (instancetype)insertWithTitle:(NSString *)title url:(NSURL *)url group:(Group *)group inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    Feed *feed = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:managedObjectContext];
    feed.title = title;
    feed.url = url;
    feed.group = group;
    
    return feed;
}

+ (NSString *)entityName
{
    return @"Feed";
}


@end
