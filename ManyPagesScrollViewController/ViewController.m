//
//  ViewController.m
//  ManyPagesScrollViewController
//
//  Created by Yuichi Fujiki on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

#define kDataSize 4096
#define kContentControllerSize 3 // Has to be odd number

@implementation ViewController

@synthesize scrollView = _scrollView;
@synthesize data = _data;
@synthesize currentPage = _currentPage;
//@synthesize prevViewController = _prevViewController, currentViewController = _currentViewController, postViewController = _postViewController;
@synthesize contentControllers;

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
    self.contentControllers = [[NSMutableArray alloc] initWithCapacity:kContentControllerSize];

    for(int i=0; i<kContentControllerSize; i++)
    {
        ContentViewController * contentViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"ContentViewController"];
        contentViewController.delegate = self;        
        
        [self.contentControllers addObject:contentViewController];
    }
    
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

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.x;
    int pageOffset = (int)(offset/self.view.frame.size.width);
    [self loadPage:pageOffset];
}

#pragma mark - loading Page View
- (void)loadPage : (int) pageNum {
    
    int numberOfPrePostPages = (int)((kContentControllerSize - 1) / 2);
    
    if(pageNum >= numberOfPrePostPages)
    {
        // Preload one pages before
        for(int i=1; i<=numberOfPrePostPages; i++)
        {
            [self loadPageBody:pageNum - i];
        }
    }
        
    [self loadPageBody:pageNum];
    
    if(pageNum < kDataSize - numberOfPrePostPages)
    {
        // Preload one pages after
        for(int i=1; i<=numberOfPrePostPages; i++)
        {
            [self loadPageBody:pageNum + i];
        }
    }
    
    self.currentPage = pageNum;
}

- (void)loadPageBody:(int) pageNum {
    // Clear content view controller that is going to be reused for this page.
    // Remove its view from superview and remove itself from parent view controller.
    ContentViewController * pageContentController = [self.contentControllers objectAtIndex:(pageNum % kContentControllerSize)];
    [pageContentController removeFromParentViewController];
    [pageContentController.view removeFromSuperview];

    // Set content specific to the page
    pageContentController.imageView.image = [UIImage imageNamed:[self.data objectAtIndex:(pageNum % 3)]];
    pageContentController.pageLabel.text = [NSString stringWithFormat:@"Page : %d", pageNum];
    if(pageNum > 0 && pageNum < kDataSize - 1)
        [pageContentController.prevButton setEnabled:YES];
    else
        [pageContentController.prevButton setEnabled:NO];        
    
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
@end
