//
//  mtlElapsedTime.m
//  mtliOSUtils
//
//  Created by Hugues Brueyre on 12-09-10.
//  Copyright (c) 2012 Departement. All rights reserved.
//

#import "mtlElapsedTime.h"

//--------------------------------------------------------------
//--------------------------------------------------------------
@implementation mtlElapsedTime

//--------------------------------------------------------------
+ (NSString*)updatedOn:(NSDate *)fromUTCDate
{
    
    // Date
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"] ];
    
    // Get the system calendar
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    NSDate* sourceDate = [sysCalendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
    
    // Get conversion to months, days, hours, minutes
    unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    
    NSDateComponents *conversionInfo = [sysCalendar components:unitFlags fromDate:fromUTCDate  toDate:sourceDate  options:0];
    
    NSString *dateString;
    NSString *prefixString = @"Updated";
    
    if([conversionInfo month] > 0 || [conversionInfo day] > 3) {
        // Older than 3 days - let's display the date
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        if([conversionInfo year] > 1) {
            dateString = [prefixString stringByAppendingString:@" in "];
            [format setDateFormat:@"MMM yyyy"];
        } else {
            dateString = [prefixString stringByAppendingString:@" on "];
            [format setDateFormat:@"MMM dd"];
        }
        NSString *lastPostDateString = [format stringFromDate:fromUTCDate];
        dateString = [dateString stringByAppendingString:lastPostDateString];
        
    } else if([conversionInfo day] > 0) {
        // Older than 1 day - display "x day ago"
        dateString = [prefixString stringByAppendingString:[NSString stringWithFormat: @" %.d", [conversionInfo day]]];
        if([conversionInfo day] < 2) {
            dateString = [dateString stringByAppendingString:@" day ago"];
        } else {
            dateString = [dateString stringByAppendingString:@" days ago"];
        }
    } else if([conversionInfo hour] > 0) {
        dateString = [prefixString stringByAppendingString:[NSString stringWithFormat: @" %.d", [conversionInfo hour]]];
        dateString = [dateString stringByAppendingString:@" hours ago"];
    } else if ([conversionInfo minute] > 0) {
        dateString = [prefixString stringByAppendingString:[NSString stringWithFormat: @" %.d", [conversionInfo minute]]];
        dateString = [dateString stringByAppendingString:@" minutes ago"];
    } else if ([conversionInfo second] > 0) {
        dateString = [prefixString stringByAppendingString:[NSString stringWithFormat: @" %.d", [conversionInfo second]]];
        dateString = [dateString stringByAppendingString:@" seconds ago"];
    }
    
    return dateString;
}

@end
