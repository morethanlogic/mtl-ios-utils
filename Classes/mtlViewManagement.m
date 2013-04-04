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
@interface mtlViewManagement ()

+ (CATransition *)presentModalTransition;
+ (CATransition *)dismissModalTransition;

@end

//--------------------------------------------------------------
//--------------------------------------------------------------
@implementation mtlViewManagement

//--------------------------------------------------------------
+ (CATransition *)presentModalTransition
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;

    return transition;
}

//--------------------------------------------------------------
+ (CATransition *)dismissModalTransition
{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;

    return transition;
}

//--------------------------------------------------------------
+ (void)pushModalStyle:(UINavigationController *)navController 
        viewController:(UIViewController *)viewControllerToPush
{
    [navController.view.layer addAnimation:[[self class] presentModalTransition]
                                    forKey:nil];
    [navController pushViewController:viewControllerToPush
                             animated:NO];
}

//--------------------------------------------------------------
+ (void)popModalStyle:(UINavigationController *)navController
{
    [navController.view.layer addAnimation:[[self class] dismissModalTransition]
                                    forKey:nil];
    [navController popViewControllerAnimated:NO];
}

//--------------------------------------------------------------
+ (void)popModalStyleToRootViewController:(UINavigationController *)navController
{
    [navController.view.layer addAnimation:[[self class] dismissModalTransition]
                                    forKey:nil];
    [navController popToRootViewControllerAnimated:NO];
}

//--------------------------------------------------------------
+ (void)popModalStyle:(UINavigationController *)navController
     toViewController:(UIViewController *)viewControllerToPopTo
{

    [navController.view.layer addAnimation:[[self class] dismissModalTransition]
                                    forKey:nil];
    [navController popToViewController:viewControllerToPopTo
                              animated:NO];
}

//--------------------------------------------------------------
+ (void)saveAndPush:(UINavigationController *)navController 
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
+ (void)popToSaved:(UINavigationController *)navController
          animated:(BOOL)animated
{
    UIViewController *savedViewController = [mtlViewManagement popSavedViewControllerStack];
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
+ (UIViewController *)popSavedViewControllerStack
{
    if (_savedViewControllerStack != nil && [_savedViewControllerStack count] > 0) {
        // Pop the last view controller saved to the stack.
        UIViewController *savedViewController = [_savedViewControllerStack lastObject];
        [_savedViewControllerStack removeLastObject];

        return savedViewController;
    }

    return nil;
}

@end
