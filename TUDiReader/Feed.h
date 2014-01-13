//
//  Feed.h
//  TUDiReader
//
//  Created by Martin Weißbach on 11/4/13.
//  Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Group;

/*!
    Keeps all information on a given RSS feed.
 */
@interface Feed : NSManagedObject

/// User-specific title of the RSS feed.
@property (nonatomic) NSString *title;
/// String representation of the URL used to fetch new RSS articles.
@property (nonatomic) NSURL *url;   // change the type of 'url' to 'Transformable' in the Model.xcdatamodeld to keep this property of type NSURL
/// The Group the feed belongs to.
@property (nonatomic) Group *group;

+ (instancetype)insertWithTitle:(NSString *)title url:(NSURL *)url group:(Group *)group inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

+ (NSString *)entityName;

@end
