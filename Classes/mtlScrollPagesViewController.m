//
//  mtlScrollPagesViewController.m
//  mtliOSUtils
//
//  Created by Elie Zananiri on 12-06-14.
//  Copyright (c) 2012 Departement. All rights reserved.
//

#import "mtlScrollPagesViewController.h"

//--------------------------------------------------------------
//--------------------------------------------------------------
@interface mtlScrollPagesViewController ()
{
    NSMutableSet *_recycledPageViewControllers;
    NSMutableSet *_visiblePageViewControllers;
    
    CGFloat _offsetPos;
    BOOL _rotationLock;
    
    NSInteger _firstVisiblePageIndexBeforeRotation;
    CGFloat _percentScrolledIntoFirstVisiblePage;
}

- (mtlPageViewController *)dequeueRecycledCover;
- (CGRect)frameForPageAtIndex:(NSUInteger)index;
- (BOOL)isDisplayingPageAtIndex:(NSUInteger)index;
- (void)tilePages:(BOOL)shouldSetCurrPage;
- (void)setCurrPage;

@end

//--------------------------------------------------------------
//--------------------------------------------------------------
@implementation mtlScrollPagesViewController

@synthesize pagesScrollView;
@synthesize currPageViewController;

@synthesize pageCount = _pageCount;
@synthesize startIndex = _startIndex;
@synthesize scrollsHorizontally = _scrollsHorizontally;

#pragma mark - Initialization

//--------------------------------------------------------------
- (id)initWithPageCount:(NSInteger)pageCount 
             startIndex:(NSInteger)startIndex 
    scrollsHorizontally:(BOOL)scrollsHorizontally
{
    self = [super init];
    if (self) {
        [self setPageCount:pageCount];
        [self setStartIndex:startIndex];
        [self setScrollsHorizontally:scrollsHorizontally];
    }
    return self;
}

#pragma mark - View Lifecycle

//--------------------------------------------------------------
- (void)refreshScrollView
{
    // Clear the UIScrollView
    for (mtlPageViewController *vc in _visiblePageViewControllers) {
        [_recycledPageViewControllers addObject:vc];
        [vc.view removeFromSuperview];
    }
    [_visiblePageViewControllers minusSet:_recycledPageViewControllers];
    
    [self tilePages:YES];
}

//--------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];

    _recycledPageViewControllers = [[NSMutableSet alloc] init];
    _visiblePageViewControllers = [[NSMutableSet alloc] init];
    
    _offsetPos = -1;
    _rotationLock = NO;
}

//--------------------------------------------------------------
- (void)viewDidUnload
{
    [self setPagesScrollView:nil];
    [self setCurrPageViewController:nil];
    
    _recycledPageViewControllers = nil;
    _visiblePageViewControllers = nil;
    
    [super viewDidUnload];
}

//--------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated 
{
    // Use the paging scrollView's bounds to calculate the contentSize.
    CGRect scrollBounds = pagesScrollView.bounds;
    if (_scrollsHorizontally) {
        if (_pageCount == 1)
            [pagesScrollView setContentSize:CGSizeMake(scrollBounds.size.width * _pageCount + 1, scrollBounds.size.height)];
        else 
            [pagesScrollView setContentSize:CGSizeMake(scrollBounds.size.width * _pageCount, scrollBounds.size.height)];
    }
    else {
        if (_pageCount == 1)
            [pagesScrollView setContentSize:CGSizeMake(scrollBounds.size.width, scrollBounds.size.height * _pageCount + 1)];
        else
            [pagesScrollView setContentSize:CGSizeMake(scrollBounds.size.width, scrollBounds.size.height * _pageCount)];
    }
    
    // Adjust the frame of each visible Cover view.
    for (mtlPageViewController *vc in _visiblePageViewControllers) {
        [vc.view setFrame:[self frameForPageAtIndex:[vc index]]];
    }
    
    if (_offsetPos == -1) {
        if (_scrollsHorizontally) {
            _offsetPos = scrollBounds.size.width * _startIndex;
            [pagesScrollView setContentOffset:CGPointMake(_offsetPos, 0)];
        }
        else {
            _offsetPos = scrollBounds.size.height * _startIndex;
            [pagesScrollView setContentOffset:CGPointMake(0, _offsetPos)];
        }
    }
    
    [self tilePages:YES];
}

#pragma mark - Rotation Callback Methods

//--------------------------------------------------------------
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{    
    _rotationLock = YES;
    
    // Our scrollView bounds have not yet been updated for the new interface orientation.
    // So this is a good place to calculate the content offset that we will need in the new orientation.
    CGFloat offset = pagesScrollView.contentOffset.x;
    CGFloat pageSize = pagesScrollView.bounds.size.width;
    
    if (offset >= 0) {
        _firstVisiblePageIndexBeforeRotation = floorf(offset / pageSize);
        _percentScrolledIntoFirstVisiblePage = (offset - (_firstVisiblePageIndexBeforeRotation * pageSize)) / pageSize;
    } 
    else {
        _firstVisiblePageIndexBeforeRotation = 0;
        _percentScrolledIntoFirstVisiblePage = offset / pageSize;
    }
}

//--------------------------------------------------------------
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{    
    // Use the paging scrollView's bounds to calculate the contentSize.
    CGRect scrollBounds = pagesScrollView.bounds;
    if (_scrollsHorizontally) {
        [pagesScrollView setContentSize:CGSizeMake(scrollBounds.size.width * _pageCount, scrollBounds.size.height)];
    }
    else {
        [pagesScrollView setContentSize:CGSizeMake(scrollBounds.size.width, scrollBounds.size.height * _pageCount)];
    }
    
    // Adjust the frame of each visible page.
    for (mtlPageViewController *vc in _visiblePageViewControllers) {
        [vc.view setFrame:[self frameForPageAtIndex:vc.index]];
    }
    
    // Adjust the contentOffset to preserve the page location based on values collected prior to rotation.
    CGFloat pageSize;
    if (_scrollsHorizontally) {
        pageSize = pagesScrollView.bounds.size.width;
    }
    else {
        pageSize = pagesScrollView.bounds.size.height;
    }
    CGFloat newOffset = (_firstVisiblePageIndexBeforeRotation * pageSize) + (_percentScrolledIntoFirstVisiblePage * pageSize);
    if (_scrollsHorizontally) {
        [pagesScrollView setContentOffset:CGPointMake(newOffset, 0)];
    }
    else {
        [pagesScrollView setContentOffset:CGPointMake(0, newOffset)];
    }
    
    _rotationLock = NO;
}

#pragma mark - Tiling Methods

//--------------------------------------------------------------
- (mtlPageViewController *)dequeueRecycledCover
{
    mtlPageViewController *vc = [_recycledPageViewControllers anyObject];
    if (vc) {
        [_recycledPageViewControllers removeObject:vc];
    }
    return vc;
}

//--------------------------------------------------------------
- (CGRect)frameForPageAtIndex:(NSUInteger)index 
{
    CGRect scrollBounds = pagesScrollView.bounds;
    CGRect pageFrame = scrollBounds;
    if (_scrollsHorizontally) {
        pageFrame.origin.x = (scrollBounds.size.width * index);
    }
    else {
        pageFrame.origin.y = (scrollBounds.size.height * index);
    }
    return pageFrame;
}

//--------------------------------------------------------------
- (BOOL)isDisplayingPageAtIndex:(NSUInteger)index
{
    BOOL foundPage = NO;
    for (mtlPageViewController *vc in _visiblePageViewControllers) {
        if (vc.index == index) {
            foundPage = YES;
            break;
        }
    }
    return foundPage;
}

//--------------------------------------------------------------
- (void)tilePages:(BOOL)shouldSetCurrPage 
{    
    // Calculate which pages are visible.
    CGRect scrollBounds = pagesScrollView.bounds;
    NSInteger firstVisiblePageIndex, lastVisiblePageIndex;
    if (_scrollsHorizontally) {
        firstVisiblePageIndex = floorf(CGRectGetMinX(scrollBounds) / CGRectGetWidth(scrollBounds));
        lastVisiblePageIndex = floorf((CGRectGetMaxX(scrollBounds) - 1) / CGRectGetWidth(scrollBounds));
    }
    else {
        firstVisiblePageIndex = floorf(CGRectGetMinY(scrollBounds) / CGRectGetHeight(scrollBounds));
        lastVisiblePageIndex = floorf((CGRectGetMaxY(scrollBounds) - 1) / CGRectGetHeight(scrollBounds));
    }
    firstVisiblePageIndex = MAX(firstVisiblePageIndex, 0);
    lastVisiblePageIndex  = MIN(lastVisiblePageIndex, _pageCount - 1);
    
    // Recycle no-longer-visible pages. 
    for (mtlPageViewController *vc in _visiblePageViewControllers) {
        if (vc.index < firstVisiblePageIndex || vc.index > lastVisiblePageIndex) {
            [_recycledPageViewControllers addObject:vc];
            [vc.view removeFromSuperview];
        }
    }
    [_visiblePageViewControllers minusSet:_recycledPageViewControllers];
    
    // Add missing pages to the view.
    for (NSInteger index = firstVisiblePageIndex; index <= lastVisiblePageIndex; index++) {
        if (![self isDisplayingPageAtIndex:index]) {
            mtlPageViewController *vc = [self dequeueRecycledCover];
            if (vc == nil) {
                vc = [self newPageViewController];
            }
            [vc setIndex:index];
            [self refreshPageViewController:vc atIndex:index];
            
            [vc.view setFrame:[self frameForPageAtIndex:index]];
            [pagesScrollView addSubview:vc.view];
            [_visiblePageViewControllers addObject:vc];
        }
    }
    
    if (shouldSetCurrPage) {
        [self setCurrPage];
    }
}

//--------------------------------------------------------------
- (void)setCurrPage
{    
    CGFloat pageSize;
    NSInteger currPageIndex;
    if (_scrollsHorizontally) {
        pageSize = pagesScrollView.frame.size.width;
        currPageIndex = floor((pagesScrollView.contentOffset.x - pageSize / 2) / pageSize) + 1;
    }
    else {
        pageSize = pagesScrollView.frame.size.height;
        currPageIndex = floor((pagesScrollView.contentOffset.y - pageSize / 2) / pageSize) + 1;
    }
    
    for (mtlPageViewController *vc in _visiblePageViewControllers) { 
        if (vc.index == currPageIndex) {
            
            if (currPageViewController != vc) {
                [self setCurrPageViewController:vc];
            } else if (currPageIndex == 0 && _scrollsHorizontally) {
                [self pulledBeginning];
            }
            
            [self newPageReached];
        }
    }
}

#pragma mark - UIScrollView delegate methods

//--------------------------------------------------------------
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (_rotationLock) return;
    [self tilePages:NO];
}

//--------------------------------------------------------------
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView 
{
    [self setCurrPage];
}

#pragma mark - mtlPageViewController Management (to be overridden)

//--------------------------------------------------------------
- (mtlPageViewController *)newPageViewController
{
    NSLog(@"[mtlScrollPagesViewController newPageViewController] should be overridden!");
    mtlPageViewController *vc = [[mtlPageViewController alloc] init];
    return vc;
}

//--------------------------------------------------------------
- (void)refreshPageViewController:(mtlPageViewController *)pageViewController atIndex:(NSInteger)index
{
    NSLog(@"[mtlScrollPagesViewController refreshPageViewController:atIndex:] should be overridden!");
}

//--------------------------------------------------------------
- (void)newPageReached
{
    NSLog(@"[mtlScrollPagesViewController newPageReached] should be overridden!");
}

//--------------------------------------------------------------
- (void)pulledBeginning
{
    NSLog(@"[mtlScrollPagesViewController pulledBeginning] should be overridden!");
}

@end
