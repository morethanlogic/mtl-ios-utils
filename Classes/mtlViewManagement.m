//
//  mtlViewManagement.m
//  mtliOSUtils
//
//  Created by Elie Zananiri on 12-06-08.
//  Copyright (c) 2012 Departement. All rights reserved.
//

#import "mtlViewManagement.h"
#import <QuartzCore/QuartzCore.h>

static NSMutableArray *_savedViewControllerStack = nil;

//--------------------------------------------------------------
//--------------------------------------------------------------
@implementation mtlViewManagement

//--------------------------------------------------------------
+ (void)pushViewControllerModalStyle:(UINavigationController *)navController 
                      viewController:(UIViewController *)viewControllerToPush
{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    [navController.view.layer addAnimation:transition forKey:nil];        
    [navController pushViewController:viewControllerToPush animated:NO];
}

//--------------------------------------------------------------
+ (void)popViewControllerModalStyle:(UINavigationController *)navController
{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    [navController.view.layer addAnimation:transition forKey:nil];    
    [navController popViewControllerAnimated:NO];
}

//--------------------------------------------------------------
+ (void)popViewControllerModalStyle:(UINavigationController *)navController
                   toViewController:(UIViewController *)viewControllerToPopTo
{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    [navController.view.layer addAnimation:transition forKey:nil];  
    [navController popToViewController:viewControllerToPopTo animated:NO];
}

//--------------------------------------------------------------
+ (void)saveAndPushViewController:(UINavigationController *)navController 
                   viewController:(UIViewController *)viewControllerToPush
                         animated:(BOOL)animated
{
    // Push the current view controller on top of the stack.
    if (_savedViewControllerStack == nil) {
        _savedViewControllerStack = [NSMutableArray arrayWithCapacity:1];
    }
    [_savedViewControllerStack addObject:navController.visibleViewController];
    
    [navController pushViewController:viewControllerToPush 
                             animated:animated];
}

//--------------------------------------------------------------
+ (void)popToSavedViewController:(UINavigationController *)navController
                        animated:(BOOL)animated
{
    UIViewController *savedViewController = [mtlViewManagement popSavedViewController];
    if (savedViewController != nil) {
        [navController popToViewController:savedViewController
                                  animated:animated];
    }
    else {
        NSLog(@"[mtlViewManagement popToSavedViewController:animated:] WARNING, No saved UIViewController found!");
        [navController popViewControllerAnimated:animated];
    }
}

//--------------------------------------------------------------
+ (UIViewController *)popSavedViewController
{
    if (_savedViewControllerStack != nil && [_savedViewControllerStack count] > 0) {
        // Pop the last view controller saved to the stack.
        UIViewController *savedViewController = [_savedViewControllerStack lastObject];
        [_savedViewControllerStack removeLastObject];

        return savedViewController;
    }

    return nil;
}

//--------------------------------------------------------------
+ (void)presentModalViewController:(UIViewController *)presentingViewController
                    viewController:(UIViewController *)viewControllerToPresent
                          animated:(BOOL)animated
{
    if ([presentingViewController respondsToSelector:@selector(presentViewController:animated:completion:)]) {
        [presentingViewController presentViewController:viewControllerToPresent
                                               animated:animated
                                             completion:nil];
    }
    else {
        [presentingViewController presentModalViewController:viewControllerToPresent
                                                    animated:animated];
    }
}

//--------------------------------------------------------------
+ (void)dismissModalViewController:(UIViewController *)viewControllerToDismiss
                          animated:(BOOL)animated
{
    if ([viewControllerToDismiss respondsToSelector:@selector(presentingViewController)]) {
        [[viewControllerToDismiss presentingViewController] dismissViewControllerAnimated:animated
                                                                               completion:nil];
    }
    else {
        [viewControllerToDismiss dismissModalViewControllerAnimated:animated];
    }
}

@end
