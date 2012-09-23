//
//  ViewController.m
//  ManyPagesScrollViewController
//
//  Created by Yuichi Fujiki on 1/30/12.
//  Copyright (c) 2012 Yuichi Fujiki. All rights reserved.
//

#import "ViewController.h"

#define kDataSize 4096
#define kContentControllerSize 3 // Has to be odd number

@implementation ViewController

@synthesize scrollView = _scrollView;
@synthesize data = _data;
@synthesize currentPage = _currentPage;
@synthesize recycleContentControllers;
@synthesize visibleContentControllers;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{    
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    
    // Load data    
    self.data = [[NSMutableArray alloc] initWithCapacity:kDataSize];
    for(int i=0; i<kDataSize; i++)
    {
        int imageIndex = i % 3 + 1;
        NSString * imageName = [NSString stringWithFormat:@"275x400_%d.jpeg", imageIndex];
        [self.data addObject:imageName];
    }
    
    // Initialize view controllers
    self.visibleContentControllers = [[NSMutableSet alloc] initWithCapacity:kContentControllerSize];
    self.recycleContentControllers = [[NSMutableSet alloc] initWithCapacity:kContentControllerSize];
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * kDataSize, self.view.frame.size.height);
    self.scrollView.scrollEnabled = YES;
    self.scrollView.pagingEnabled = YES;
    
    [self loadPage:0];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - ScrollViewDelegate

//
// scrollViewDidScroll is called every time when scroll starts, and before actual drawing happens.
// So, it is ideal place to load all visible content views.
//
- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGRect visibleRect = scrollView.bounds;
    int firstPageIndex = floorf(CGRectGetMinX(visibleRect) / CGRectGetWidth(visibleRect));
    int lastPageIndex = floorf((CGRectGetMaxX(visibleRect) - 1) / CGRectGetWidth(visibleRect));
    int neededFirstPageIndex = MAX(firstPageIndex, 0);
    int neededLastPageIndex = MIN(lastPageIndex, kDataSize);

//    NSLog(@"Visible page from %d to %d", neededFirstPageIndex, neededLastPageIndex);
    
    for(int i = neededFirstPageIndex; i <= neededLastPageIndex; i++)
    {
        if(![self isPageVisibleAtIndex:i]) // Do not (re)load page if it is already visible.
            [self loadPage:i];
    }
    
    // Reconfigure recycleContentControllers/visibleControllers
    for(ContentViewController * controller in self.visibleContentControllers)
    {
        if(controller.pageIndex < neededFirstPageIndex || controller.pageIndex > neededLastPageIndex)
        {
            [self.recycleContentControllers addObject:controller];
        }
    }
    [self.visibleContentControllers minusSet:self.recycleContentControllers];
}

#pragma mark - loading Page View
- (void)loadPage:(int) pageNum {
    // Clear content view controller that is going to be reused for this page.
    // Remove its view from superview and remove itself from parent view controller.
    ContentViewController * pageContentController = [self dequeueContentController];
    if(!pageContentController)
    {
        pageContentController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"ContentViewController"];
        pageContentController.delegate = self;
    }
    [pageContentController removeFromParentViewController];
    [pageContentController.view removeFromSuperview];
    [self.visibleContentControllers addObject:pageContentController];
    
    // Set content specific to the page
    pageContentController.pageIndex = pageNum;
    pageContentController.imageView.image = [UIImage imageNamed:[self.data objectAtIndex:(pageNum % 3)]];
    pageContentController.pageLabel.text = [NSString stringWithFormat:@"Page : %d", pageNum];
    if(pageNum == 0)
    {
        [pageContentController.prevButton setEnabled:NO];
        [pageContentController.nextButton setEnabled:YES];        
    }
    else if(pageNum == kDataSize - 1)
    {
        [pageContentController.prevButton setEnabled:YES];        
        [pageContentController.nextButton setEnabled:NO];        
    }
    else
    {
        [pageContentController.prevButton setEnabled:YES];        
        [pageContentController.nextButton setEnabled:YES];                
    }
    
    // Set position of the page view
    pageContentController.view.frame = 
        (CGRect){self.view.frame.origin.x + pageNum * self.view.frame.size.width,
            self.view.frame.origin.y,
            self.view.frame.size};
            
    // Add page to the scroll view
    [self addChildViewController:pageContentController];
    [self.scrollView addSubview:pageContentController.view];
    [pageContentController didMoveToParentViewController:self];
}

#pragma mark - ContentViewControllerDelegate
-(void)nextButtonPressed {
    [UIView animateWithDuration:0.8 animations:^{
        [self.scrollView setAlpha:0.1];
    } completion:^(BOOL finished) {
        [self.scrollView setContentOffset:(CGPoint){self.scrollView.contentOffset.x + self.scrollView.frame.size.width, self.scrollView.contentOffset.y}];
        [self loadPage:self.currentPage + 1];        
        [UIView animateWithDuration:0.8 animations:^{
            [self.scrollView setAlpha:1.0];
        }];
    }];
}

- (void)prevButtonPressed {
    [UIView animateWithDuration:0.8 animations:^{
        [self.scrollView setAlpha:0.1];
    } completion:^(BOOL finished) {
        [self.scrollView setContentOffset:(CGPoint){self.scrollView.contentOffset.x - self.scrollView.frame.size.width, self.scrollView.contentOffset.y}];
        [self loadPage:self.currentPage - 1];        
        [UIView animateWithDuration:0.8 animations:^{
            [self.scrollView setAlpha:1.0];
        }];
    }];
}

#pragma mark - Private method for recycling ContentViewControllers
- (BOOL) isPageVisibleAtIndex : (int) pageIndex
{
    for(ContentViewController * pageContentController in self.visibleContentControllers)
    {
        if(pageContentController.pageIndex == pageIndex)
            return YES;
    }
    return NO;
}

- (ContentViewController *) dequeueContentController {
    ContentViewController * controller = [self.recycleContentControllers anyObject];
    if(controller)
        [self.recycleContentControllers removeObject:controller];
    return controller;
}

@end
