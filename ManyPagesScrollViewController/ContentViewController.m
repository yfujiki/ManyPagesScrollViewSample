//
//  ContentViewController.m
//  ManyPagesScrollViewController
//
//  Created by Yuichi Fujiki on 1/30/12.
//  Copyright (c) 2012 Yuichi Fujiki. All rights reserved.
//

#import "ContentViewController.h"

@implementation ContentViewController
@synthesize imageView;
@synthesize pageLabel;
@synthesize nextButton;
@synthesize prevButton;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setPageLabel:nil];
    [self setNextButton:nil];
    [self setPrevButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)next:(id)sender {
    [self.delegate nextButtonPressed];
}

- (IBAction)previous:(id)sender {
    [self.delegate prevButtonPressed];
}
@end
