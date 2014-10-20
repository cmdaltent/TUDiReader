//
//  DetailViewController.h
//  TUDiReader
//
//  Created by Martin Weissbach on 10/20/14.
//  Copyright (c) 2014 Martin Weissbach. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

