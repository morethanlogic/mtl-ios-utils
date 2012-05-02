//
//  mtlScrollFormViewController.m
//  mtliOSUtils
//
//  Created by Elie Zananiri on 12-01-12.
//  Copyright (c) 2012 Departement. All rights reserved.
//

#import "mtlScrollFormViewController.h"

//--------------------------------------------------------------
//--------------------------------------------------------------
@interface mtlScrollFormViewController ()

@end

//--------------------------------------------------------------
//--------------------------------------------------------------
@implementation mtlScrollFormViewController

@synthesize scrollView;
@synthesize entryFields;

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

//--------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Register for keyboard notifications.
    [[NSNotificationCenter defaultCenter] addObserver:self  
                                             selector:@selector(keyboardWillShow:)  
                                                 name:UIKeyboardWillShowNotification  
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self  
                                             selector:@selector(keyboardWillHide:)  
                                                 name:UIKeyboardWillHideNotification  
                                               object:nil];
}

//--------------------------------------------------------------
- (void)viewDidUnload
{
    // Unregister for keyboard notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self setEntryFields:nil];
    [self setScrollView:nil];
    
    [super viewDidUnload];
}

#pragma mark - Form Scrolling

//--------------------------------------------------------------
// Returns an array of all data entry fields in the view.
// Fields are ordered by tag, and only fields with tag > 0 are included.
// Returned fields are guaranteed to be a subclass of UIResponder.
- (NSArray *)entryFields 
{
	if (!entryFields) {
		self.entryFields = [[NSMutableArray alloc] init];
		NSInteger tag = 1;
		UIView *aView;
		while ((aView = [self.view viewWithTag:tag])) {
			if (aView && [[aView class] isSubclassOfClass:[UIResponder class]]) {
				[entryFields addObject:aView];
			}
			tag++;
		}
	}
	return entryFields;
}

//--------------------------------------------------------------
- (void)scrollViewToCenterOfScreen:(UIView *)theView 
{  
    CGFloat viewCenterY = theView.center.y;  
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];  
    
    CGFloat availableHeight = applicationFrame.size.height - keyboardBounds.size.height;    // Remove area covered by keyboard  
    
    CGFloat y = viewCenterY - availableHeight / 2.0;  
    if (y < 0) {  
        y = 0;  
    }  
    scrollView.contentSize = CGSizeMake(applicationFrame.size.width, applicationFrame.size.height + keyboardBounds.size.height);  
    [scrollView setContentOffset:CGPointMake(0, y) animated:YES];  
}

//--------------------------------------------------------------
- (void)scrollViewToTopOfScreen:(UIView *)theView 
{  
    CGFloat viewTopY = theView.center.y - theView.bounds.size.height / 2.0; //theView.center.y;  
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];  
    
    CGFloat availableHeight = applicationFrame.size.height - keyboardBounds.size.height;    // Remove area covered by keyboard  
    
    CGFloat y = viewTopY - availableHeight / 2.0;  
    if (y < 0) {  
        y = 0;  
    }  
    scrollView.contentSize = CGSizeMake(applicationFrame.size.width, applicationFrame.size.height + keyboardBounds.size.height);  
    [scrollView setContentOffset:CGPointMake(0, y) animated:YES];  
}

#pragma mark UIKeyboardView methods 

//--------------------------------------------------------------
- (void)keyboardWillShow:(NSNotification*)notification 
{  
    NSValue *keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey];  
    [keyboardBoundsValue getValue:&keyboardBounds];  
}

//--------------------------------------------------------------
- (void)keyboardWillHide:(NSNotification*)notification 
{
	[self scrollViewToTopOfScreen:scrollView];
}

#pragma mark UITextFieldDelegate methods

//--------------------------------------------------------------
- (void)textFieldDidBeginEditing:(UITextField *)textField 
{
	[self scrollViewToCenterOfScreen:textField];
}

//--------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
    // Find the next entry field.
    BOOL bFound = NO;
	for (UIView *aView in [self entryFields]) {
		if (aView.tag == (textField.tag + 1)) {
            [aView becomeFirstResponder];
            bFound = true;
			break;
		}
	}
    
    // If there are no more fields to fill, hide the keyboard.
    if (bFound == NO) {
        [textField resignFirstResponder];  
    }
    
	return NO;
}

@end
