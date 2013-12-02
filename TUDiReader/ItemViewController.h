//
//  ItemViewController.h
//  TUDiReader
//
//  Created by Martin Weißbach on 12/2/13.
//  Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Item;

@interface ItemViewController : UIViewController

@property (nonatomic, readonly) Item *item;

- (id)initWitItem:(Item *)item;

@end
