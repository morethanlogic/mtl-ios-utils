//
//  mtlStringValidation.m
//  mtliOSUtils
//
//  Created by Elie Zananiri on 12-03-14.
//  Copyright (c) 2012 Departement. All rights reserved.
//

#import "mtlStringValidation.h"

@implementation StringValidation

//--------------------------------------------------------------
+ (BOOL)validateNotEmpty:(NSString *)candidate
{
    return ([candidate length] != 0);
}

//--------------------------------------------------------------
+ (BOOL)validateMinimumLength:(NSString *)candidate 
                    parameter:(int)length
{
    return ([candidate length] >= length);
}

//--------------------------------------------------------------
+ (BOOL)validateMaximumLength:(NSString *)candidate 
                    parameter:(int)length
{
    return ([candidate length] <= length);
}

//--------------------------------------------------------------
+ (BOOL)validateMatchesConfirmation:(NSString *)candidate 
                          parameter:(NSString *)confirmation 
{
    return [candidate isEqualToString:confirmation];
}

//--------------------------------------------------------------
+ (BOOL)validateStringInCharacterSet:(NSString *)string 
                        characterSet:(NSMutableCharacterSet *)characterSet
{
    return ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location == NSNotFound);
}

//--------------------------------------------------------------
+ (BOOL)validateAlpha:(NSString *)candidate 
{
    return [self validateStringInCharacterSet:candidate characterSet:[NSCharacterSet letterCharacterSet]];
}

//--------------------------------------------------------------
+ (BOOL)validateAlphanumeric:(NSString *)candidate
{
    return [self validateStringInCharacterSet:candidate characterSet:[NSCharacterSet alphanumericCharacterSet]];
}

//--------------------------------------------------------------
+ (BOOL)validateNumeric:(NSString *)candidate
{
    return [self validateStringInCharacterSet:candidate characterSet:[NSCharacterSet decimalDigitCharacterSet]];
}

//--------------------------------------------------------------
+ (BOOL)validateAlphaSpace:(NSString *)candidate
{
    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet letterCharacterSet];
    [characterSet addCharactersInString:@" "];
    return [self validateStringInCharacterSet:candidate characterSet:characterSet];
}

//--------------------------------------------------------------
+ (BOOL)validateAlphanumericSpace:(NSString *)candidate
{
    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet alphanumericCharacterSet];
    [characterSet addCharactersInString:@" "];
    return [self validateStringInCharacterSet:candidate characterSet:characterSet];
}

//--------------------------------------------------------------
// Alphanumeric characters, underscore (_), and period (.)
+ (BOOL)validateUsername:(NSString *)candidate 
{
    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet alphanumericCharacterSet];
    [characterSet addCharactersInString:@"'_."];
    return [self validateStringInCharacterSet:candidate characterSet:characterSet];
}

//--------------------------------------------------------------
// http://stackoverflow.com/questions/3139619/check-that-an-email-address-is-valid-on-ios
// http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
+ (BOOL)validateEmail:(NSString *)candidate
       stricterFilter:(BOOL)stricterFilter
{
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}

@end
