//
//  mtlStringValidation.h
//  mtliOSUtils
//
//  Created by Elie Zananiri on 12-03-14.
//  Copyright (c) 2012 Departement. All rights reserved.
//

#import <Foundation/Foundation.h>

//--------------------------------------------------------------
//--------------------------------------------------------------
@interface StringValidation : NSObject

+ (BOOL)validateNotEmpty:(NSString *)candidate;
+ (BOOL)validateMinimumLength:(NSString *)candidate 
                    parameter:(int)length;
+ (BOOL)validateMaximumLength:(NSString *)candidate 
                    parameter:(int)length;

+ (BOOL)validateMatchesConfirmation:(NSString *)candidate 
                          parameter:(NSString *)confirmation;
+ (BOOL)validateStringInCharacterSet:(NSString *)string 
                        characterSet:(NSMutableCharacterSet *)characterSet;

+ (BOOL)validateAlpha:(NSString *)candidate;
+ (BOOL)validateAlphanumeric:(NSString *)candidate;
+ (BOOL)validateNumeric:(NSString *)candidate;
+ (BOOL)validateAlphaSpace:(NSString *)candidate;
+ (BOOL)validateAlphanumericSpace:(NSString *)candidate;

+ (BOOL)validateUsername:(NSString *)candidate;
+ (BOOL)validateEmail:(NSString *)candidate
       stricterFilter:(BOOL)stricterFilter;

@end
