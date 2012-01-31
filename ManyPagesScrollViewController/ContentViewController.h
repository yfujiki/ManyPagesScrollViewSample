//
//  ContentViewController.h
//  ManyPagesScrollViewController
//
//  Created by Yuichi Fujiki on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ContentViewControllerDelegate

- (void)nextButtonPressed;
- (void)prevButtonPressed;

@end

@interface ContentViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *pageLabel;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet UIButton *prevButton;
@property (assign, nonatomic) id<ContentViewControllerDelegate> delegate;

- (IBAction)next:(id)sender;
- (IBAction)previous:(id)sender;

@end
