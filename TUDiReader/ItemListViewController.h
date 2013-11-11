//
//  ItemListViewController.h
//  TUDiReader
//
//  Created by Martin Weißbach on 11/11/13.
//  Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Feed;

@interface ItemListViewController : UITableViewController

@property (nonatomic) Feed *feed;

@end
