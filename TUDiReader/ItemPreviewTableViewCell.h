//
//  ItemPreviewTableViewCell.h
//  TUDiReader
//
//  Created by Martin Weißbach on 11/25/13.
//  Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
    Custom cell displayed in the ItemListView.
 */
@interface ItemPreviewTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/*!
    Return the expected height for the cell.
    
    @param title    String value to set for the titleLabel of the cell.
                    Depending of this string the expected height is calculated.
 
    @return         The calculated height of the cell.
 */
+ (CGFloat)expectedHeightWithTitle:(NSString *)title;

@end
