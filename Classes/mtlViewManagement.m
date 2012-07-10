//
//  mtlViewManagement.m
//  mtliOSUtils
//
//  Created by Elie Zananiri on 12-06-08.
//  Copyright (c) 2012 Departement. All rights reserved.
//

#import "mtlViewManagement.h"
#import <QuartzCore/QuartzCore.h>

static UIViewController *_savedViewController = nil;

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
    _savedViewController = navController.visibleViewController;
    
    [navController pushViewController:viewControllerToPush 
                             animated:animated];
}

//--------------------------------------------------------------
+ (void)popToSavedViewController:(UINavigationController *)navController
                        animated:(BOOL)animated
{
    if (_savedViewController != nil) {
        [navController popToViewController:_savedViewController animated:animated];
    }
    else {
        NSLog(@"[mtlViewManagement popToSavedViewControllerModalStyle:] WARNING, No saved UIViewController found!");
        [navController popViewControllerAnimated:animated];
    }
}

@end
