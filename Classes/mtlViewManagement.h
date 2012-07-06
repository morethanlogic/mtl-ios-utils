//
//  mtlViewManagement.h
//  mtliOSUtils
//
//  Created by Elie Zananiri on 12-06-08.
//  Copyright (c) 2012 Departement. All rights reserved.
//

#import <UIKit/UIKit.h>

//--------------------------------------------------------------
//--------------------------------------------------------------
@interface mtlViewManagement : NSObject

+ (void)pushViewControllerModalStyle:(UINavigationController *)navController 
                      viewController:(UIViewController *)viewControllerToPush;

+ (void)popViewControllerModalStyle:(UINavigationController *)navController;

+ (void)popViewControllerModalStyle:(UINavigationController *)navController
                   toViewController:(UIViewController *)toViewController;

@end
