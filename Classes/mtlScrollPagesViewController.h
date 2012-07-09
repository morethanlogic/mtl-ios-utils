//
//  mtlScrollPagesViewController.h
//  mtliOSUtils
//
//  Created by Elie Zananiri on 12-06-14.
//  Copyright (c) 2012 Departement. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "mtlPageViewController.h"

//--------------------------------------------------------------
//--------------------------------------------------------------
@interface mtlScrollPagesViewController : UIViewController <UIScrollViewDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView *pagesScrollView;
@property (unsafe_unretained, nonatomic) mtlPageViewController *currPageViewController;

@property (assign, nonatomic) NSInteger pageCount;
@property (assign, nonatomic) NSInteger startIndex;
@property (assign, nonatomic) BOOL scrollsHorizontally;

- (id)initWithPageCount:(NSInteger)pageCount 
             startIndex:(NSInteger)startIndex
    scrollsHorizontally:(BOOL)scrollsHorizontally;

- (mtlPageViewController *)newPageViewController;
- (void)refreshPageViewController:(mtlPageViewController *)pageViewController atIndex:(NSInteger)index;
- (void)pulledBeginning;

@end
