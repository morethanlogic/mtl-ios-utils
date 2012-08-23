//
//  NSString+Split.h
//  mtliOSUtils
//
//  Created by Elie Zananiri on 2012-08-23.
//  Copyright (c) 2012 Departement. All rights reserved.
//

#import <UIKit/UIKit.h>

//--------------------------------------------------------------
//--------------------------------------------------------------
@interface NSString (Split)

- (NSArray *)splitForFont:(UIFont *)font
                maxLength:(NSInteger)maxLength;\

@end
