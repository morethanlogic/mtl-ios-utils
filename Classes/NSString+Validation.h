//
//  mtlStringValidation.h
//  mtliOSUtils
//
//  Created by Elie Zananiri on 12-03-14.
//  Copyright (c) 2012 Departement. All rights reserved.
//

#import <UIKit/UIKit.h>

//--------------------------------------------------------------
//--------------------------------------------------------------
@interface NSString (Validation)

- (BOOL)validateNotEmpty;
- (BOOL)validateMinimumLength:(NSInteger)length;
- (BOOL)validateMaximumLength:(NSInteger)length;

- (BOOL)validateMatchesConfirmation:(NSString *)confirmation;
- (BOOL)validateInCharacterSet:(NSMutableCharacterSet *)characterSet;

- (BOOL)validateAlpha;
- (BOOL)validateAlphanumeric;
- (BOOL)validateNumeric;
- (BOOL)validateAlphaSpace;
- (BOOL)validateAlphanumericSpace;

- (BOOL)validateUsername;
- (BOOL)validateEmail:(BOOL)stricterFilter;
- (BOOL)validatePhoneNumber;

@end
