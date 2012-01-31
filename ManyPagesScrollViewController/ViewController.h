//
//  ViewController.h
//  ManyPagesScrollViewController
//
//  Created by Yuichi Fujiki on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentViewController.h"

@interface ViewController : UIViewController <UIScrollViewDelegate, ContentViewControllerDelegate>

@property (nonatomic, assign) IBOutlet UIScrollView * scrollView;
@property (nonatomic, retain) NSMutableArray * data;
@property (nonatomic) int currentPage;
@property (nonatomic, retain) NSMutableArray * contentControllers;

//@property (nonatomic, retain) ContentViewController * prevViewController;
//@property (nonatomic, retain) ContentViewController * currentViewController;
//@property (nonatomic, retain) ContentViewController * postViewController;

- (void)loadPage:(int)pageNum;
- (void)loadPageBody:(int)pageNum;
@end
