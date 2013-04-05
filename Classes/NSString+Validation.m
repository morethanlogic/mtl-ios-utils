//
//  mtlStringValidation.m
//  mtliOSUtils
//
//  Created by Elie Zananiri on 12-03-14.
//  Copyright (c) 2012 Departement. All rights reserved.
//

#import "NSString+Validation.h"

//--------------------------------------------------------------
//--------------------------------------------------------------
@implementation NSString (Validation)

//--------------------------------------------------------------
- (BOOL)validateNotEmpty
{
    return ([self length] != 0);
}

//--------------------------------------------------------------
- (BOOL)validateMinimumLength:(NSInteger)length
{
    return ([self length] >= length);
}

//--------------------------------------------------------------
- (BOOL)validateMaximumLength:(NSInteger)length
{
    return ([self length] <= length);
}

//--------------------------------------------------------------
- (BOOL)validateMatchesConfirmation:(NSString *)confirmation 
{
    return [self isEqualToString:confirmation];
}

//--------------------------------------------------------------
- (BOOL)validateInCharacterSet:(NSMutableCharacterSet *)characterSet
{
    return ([self rangeOfCharacterFromSet:[characterSet invertedSet]].location == NSNotFound);
}

//--------------------------------------------------------------
- (BOOL)validateAlpha
{
    return [self validateInCharacterSet:[NSCharacterSet letterCharacterSet]];
}

//--------------------------------------------------------------
- (BOOL)validateAlphanumeric
{
    return [self validateInCharacterSet:[NSCharacterSet alphanumericCharacterSet]];
}

//--------------------------------------------------------------
- (BOOL)validateNumeric
{
    return [self validateInCharacterSet:[NSCharacterSet decimalDigitCharacterSet]];
}

//--------------------------------------------------------------
- (BOOL)validateAlphaSpace
{
    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet letterCharacterSet];
    [characterSet addCharactersInString:@" "];
    return [self validateInCharacterSet:characterSet];
}

//--------------------------------------------------------------
- (BOOL)validateAlphanumericSpace
{
    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet alphanumericCharacterSet];
    [characterSet addCharactersInString:@" "];
    return [self validateInCharacterSet:characterSet];
}

//--------------------------------------------------------------
// Alphanumeric characters, underscore (_), and period (.)
- (BOOL)validateUsername 
{
    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet alphanumericCharacterSet];
    [characterSet addCharactersInString:@"'_."];
    return [self validateInCharacterSet:characterSet];
}

//--------------------------------------------------------------
// http://stackoverflow.com/questions/3139619/check-that-an-email-address-is-valid-on-ios
// http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
- (BOOL)validateEmail:(BOOL)stricterFilter
{
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

//--------------------------------------------------------------
- (BOOL)validatePhoneNumber
{
    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet decimalDigitCharacterSet];
    [characterSet addCharactersInString:@"'-*+#,;. "];
    return [self validateInCharacterSet:characterSet];
}

@end
