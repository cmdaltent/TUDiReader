//
//  Item.m
//  TUDiReader
//
//  Created by Martin Weißbach on 11/18/13.
//  Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//

#import "Item.h"

@implementation Item

- (NSString *)htmlSummary
{
    NSMutableString *htmlString = [NSMutableString new];
    [htmlString appendString:@"<!DOCTYPE html><html><head><meta name=\"viewport\" content=\"initial-scale=1.0\"/>"];
    [htmlString appendString:@"<style type=\"text/css\">img {max-width:100%%;width:auto;height:auto;}"];
    [htmlString appendString:@"body {margin:0px 10px 10px;line-height:1.5; font-family:'Helvetica Neue';}</style></head>"];
    [htmlString appendFormat:@"<body>%@</body></html>", self.summary];
    
    return [NSString stringWithString:htmlString];
}

@end
