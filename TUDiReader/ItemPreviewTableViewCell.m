//
//  ItemPreviewTableViewCell.m
//  TUDiReader
//
//  Created by Martin Weißbach on 11/25/13.
//  Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//

#import "ItemPreviewTableViewCell.h"

@implementation ItemPreviewTableViewCell

+ (CGFloat)expectedHeightWithTitle:(NSString *)title
{
    CGFloat expectedHeight = 20.0;
    
    expectedHeight += [title boundingRectWithSize:CGSizeMake(247.0, CGFLOAT_MAX)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17.f]}
                                          context:nil].size.height;
    
    return expectedHeight;
}

@end
