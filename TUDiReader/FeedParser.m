//
//  FeedParser.m
//  TUDiReader
//
//  Created by Martin Weissbach on 11/24/14.
//  Copyright (c) 2014 Martin Weissbach. All rights reserved.
//

#import "FeedParser.h"

#import "Item.h"
#import "PersistenceStack.h"

@interface FeedParser () <NSXMLParserDelegate>
{
    NSXMLParser *_parser;
    Item *_currentItem;
    NSMutableArray *_items;
    NSMutableString *_nodeText;
    
    BOOL _processingItem;
}

@end

@implementation FeedParser

- (instancetype)initWithData:(NSData *)data
{
    if ( ( self = [super init] ) )
    {
        _parser = [[NSXMLParser alloc] initWithData:data];
        _parser.delegate = self;
    }
    return self;
}

- (void)main
{
    [_parser parse];
}

#pragma mark - NSXMLParserDelegate

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    _items = [[NSMutableArray alloc] initWithCapacity:10];
    _processingItem = NO;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if ( self.parsingFinishedBlock )
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.parsingFinishedBlock(_items);
        }];
    }
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ( [elementName isEqualToString:@"item"] )
    {
        _currentItem = [[Item alloc] initWithEntity:[NSEntityDescription entityForName:@"Item"
                                                                inManagedObjectContext:[PersistenceStack sharedPersistenceStack].managedObjectContext]
                     insertIntoManagedObjectContext:[PersistenceStack sharedPersistenceStack].managedObjectContext];
        _processingItem = YES;
    }
    if ( _processingItem )
    {
        _nodeText = nil;
        _nodeText = [NSMutableString new];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ( [elementName isEqualToString:@"item"] )
    {
        [_items addObject:_currentItem];
        _currentItem = nil;
        _processingItem = NO;
    }
    if (_processingItem && [elementName isEqualToString:@"title"] )
    {
        _currentItem.title = [_nodeText stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
    }
    if (_processingItem && [elementName isEqualToString:@"pubDate"] )
    {
        _currentItem.dateString = [_nodeText stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    }
    if (_processingItem && [elementName isEqualToString:@"guid"] )
    {
        _currentItem.guid = [_nodeText stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    }
    if (_processingItem && [elementName isEqualToString:@"content:encoded"] )
    {
        _currentItem.summary = [_nodeText stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    }
    if (_processingItem && ([elementName isEqualToString:@"author"] || [elementName isEqualToString:@"dc:creator"]) )
    {
        _currentItem.author = [_nodeText stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (_processingItem)
    {
        [_nodeText appendString:string];
    }
}

@end
