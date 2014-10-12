//
//  NewFeedSupportViewController.h
//  TUDiReader
//
//  Created by Martin Weißbach on 12/9/13.
//  Copyright (c) 2013 Technische Universität Dresden. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewFeedSupportViewController : UIViewController

- (id)initWithTitle:(NSString *)title predefinedValue:(NSString *)value completionBlock:(void (^)(NSString *))completionBlock;

@end
