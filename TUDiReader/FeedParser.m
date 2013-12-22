//
//  FeedParser.m
//  TUDiReader
//
//  Created by Martin Weißbach on 11/18/13.
//  Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//

#import "FeedParser.h"

#import "Item.h"

@interface FeedParser () <NSXMLParserDelegate>

@end

@implementation FeedParser
{
    // Private Instance Variables, Getter & Setter are not generated for them.
    NSXMLParser *_parser;
    Item *_currentItem;
    NSMutableArray *_items;
    NSMutableString *_nodeText;
    
    BOOL _processingItem;
}

- (id)initWithData:(NSData *)data
{
    if (self = [super init]) {
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
    if (self.parsingFinishedBlock) {
        /*!
            The parsing was dispatched from the main queue to a background queue.
            All parser events are dispatched to this background queue. To make sure UI operations are scheduled to the correct
            queue, the execution of the callback block is scheduled to the application's main queue.
         */
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.parsingFinishedBlock([NSArray arrayWithArray:_items]);
        }];
    }
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"item"]) {
        _currentItem = [Item new];
        _processingItem = YES;
    }
    if (_processingItem) {
        _nodeText = nil;
        _nodeText = [NSMutableString new];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"item"]) {
        [_items addObject:_currentItem];
        _currentItem = nil;
        _processingItem = NO;
    }
    if (_processingItem && [elementName isEqualToString:@"pubDate"]) {
        _currentItem.dateString = _nodeText;
    }
    if (_processingItem && [elementName isEqualToString:@"guid"]) {
        _currentItem.guid = [_nodeText stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    }
    if (_processingItem && [elementName isEqualToString:@"content:encoded"]) {
        _currentItem.summary = [_nodeText stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    }
    if (_processingItem && ([elementName isEqualToString:@"author"] || [elementName isEqualToString:@"dc:creator"])) {
        _currentItem.author = [_nodeText stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    }
    if (_processingItem && [elementName isEqualToString:@"title"]) {
        _currentItem.title = [_nodeText stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (_processingItem) {
        [_nodeText appendString:string];
    }
}

@end









