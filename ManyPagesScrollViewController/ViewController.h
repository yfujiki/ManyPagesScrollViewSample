//
//  ViewController.h
//  ManyPagesScrollViewController
//
//  Created by Yuichi Fujiki on 1/30/12.
//  Copyright (c) 2012 Yuichi Fujiki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentViewController.h"

@interface ViewController : UIViewController <UIScrollViewDelegate, ContentViewControllerDelegate>

@property (nonatomic, assign) IBOutlet UIScrollView * scrollView;
@property (nonatomic, retain) NSMutableArray * data;
@property (nonatomic) int currentPage;
@property (nonatomic, retain) NSMutableSet * visibleContentControllers;
@property (nonatomic, retain) NSMutableSet * recycleContentControllers;

- (void)loadPage:(int)pageNum;

@end
