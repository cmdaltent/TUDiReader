//
//  AddGroupTableViewController.h
//  TUDiReader
//
//  Created by Martin Weissbach on 11/3/14.
//  Copyright (c) 2014 Martin Weissbach. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Group;

typedef void (^AddGroupCompletionBlock)(Group *);

@interface AddGroupTableViewController : UIViewController

@property (copy) AddGroupCompletionBlock completionBlock;

@end
