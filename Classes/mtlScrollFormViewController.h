//
//  mtlScrollFormViewController.h
//  mtliOSUtils
//
//  Created by Elie Zananiri on 12-01-12.
//  Copyright (c) 2012 Departement. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mtlScrollFormViewController : UIViewController <UITextFieldDelegate>
{
    UIScrollView *scrollView;
 
@protected
    NSMutableArray *entryFields;
    CGRect keyboardBounds; 
}

- (NSArray *)entryFields;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableArray *entryFields;

@end
