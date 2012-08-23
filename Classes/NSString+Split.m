//
//  NSString+Split.m
//  mtliOSUtils
//
//  Created by Elie Zananiri on 2012-08-23.
//  Copyright (c) 2012 Departement. All rights reserved.
//

#import "NSString+Split.h"

//--------------------------------------------------------------
//--------------------------------------------------------------
@implementation NSString (Split)

//--------------------------------------------------------------
- (NSArray *)splitForFont:(UIFont *)font
                maxLength:(NSInteger)maxLength
{
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:1];
    NSArray *wordArray = [self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSInteger numberOfWords = [wordArray count];
    NSInteger currIndex = 0;

	while (currIndex < numberOfWords) {
        CGSize lineSize = CGSizeZero;
        CGSize sizeOfNextWord = CGSizeZero;
		NSMutableString *line = [NSMutableString stringWithCapacity:1];
        while (((lineSize.width + sizeOfNextWord.width) <= maxLength) && (currIndex < numberOfWords)) {
	        [line appendString:[NSString stringWithFormat:@"%@ ", [wordArray objectAtIndex:currIndex]]];
            lineSize = [line sizeWithFont:font];
            currIndex++;

            if (currIndex < numberOfWords) {
                sizeOfNextWord = [[wordArray objectAtIndex:currIndex] sizeWithFont:font];
            }
	    }
		[tempArray addObject:[line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
	}
    
    return tempArray;
}

@end
