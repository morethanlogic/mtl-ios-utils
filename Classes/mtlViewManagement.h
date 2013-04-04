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

+ (void)pushModalStyle:(UINavigationController *)navController 
        viewController:(UIViewController *)viewControllerToPush;

+ (void)popModalStyle:(UINavigationController *)navController;

+ (void)popModalStyleToRootViewController:(UINavigationController *)navController;

+ (void)popModalStyle:(UINavigationController *)navController
     toViewController:(UIViewController *)viewControllerToPopTo;

+ (void)saveAndPush:(UINavigationController *)navController 
     viewController:(UIViewController *)viewControllerToPush
           animated:(BOOL)animated;

+ (void)popToSaved:(UINavigationController *)navController
          animated:(BOOL)animated;

+ (UIViewController *)popSavedViewControllerStack;

@end
