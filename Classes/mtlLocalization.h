//
//  mtlLocalization.h
//  Exterior
//
//  Created by Elie Zananiri on 2013-01-14.
//
//  http://stackoverflow.com/questions/1669645/how-to-force-nslocalizedstring-to-use-a-specific-language
//

#import <Foundation/Foundation.h>

#define mtlLocalizedString(key, comment) [[mtlLocalization sharedInstance] localizedStringForKey:(key) value:(comment)]

//--------------------------------------------------------------
//--------------------------------------------------------------
@interface mtlLocalization : NSObject

+ (mtlLocalization *)sharedInstance;

- (void)setLanguage:(NSString *)lang;
- (void)resetLanguage;
- (NSString *)preferredLanguage;

- (NSString *)localizedStringForKey:(NSString *)key
                              value:(NSString *)comment;

@end
