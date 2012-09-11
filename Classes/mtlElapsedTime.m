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
+ (NSString *)updatedOn:(NSDate *)fromUTCDate prefixString:(NSString *)prefixString;
{
    static NSDateComponents *comps;
    if (comps == nil) {
        comps = [[NSDateComponents alloc] init];
        [comps setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    }
    
    // Get the system date.
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    NSDate* sourceDate = [sysCalendar dateByAddingComponents:comps
                                                      toDate:[NSDate date]
                                                     options:0];
    
    // Get the date interval conversion.
    unsigned int unitFlags = NSSecondCalendarUnit | NSMinuteCalendarUnit | NSHourCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    NSDateComponents *conversionInfo = [sysCalendar components:unitFlags
                                                      fromDate:fromUTCDate
                                                        toDate:sourceDate
                                                       options:0];

    // Return the formatted date string.    
    if ([conversionInfo month] > 0 || [conversionInfo day] > 3) {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        if ([conversionInfo year] > 1) {
            // Older than 1 year, display "Updated in June 2012"
            [format setDateFormat:@"MMM yyyy"];
            return [NSString stringWithFormat:@"%@ in %@", prefixString, [format stringFromDate:fromUTCDate]];
        }

        // Older than 3 days but less than 1 year, display "Updated on June 3"
        [format setDateFormat:@"MMM d"];
        return [NSString stringWithFormat:@"%@ on %@", prefixString, [format stringFromDate:fromUTCDate]];
    }
    else if ([conversionInfo day] > 0) {
        // Older than 1 day, display "Updated 3 days ago"
        return [NSString stringWithFormat:@"%@ %d day%@ ago", prefixString, [conversionInfo day], ([conversionInfo day] == 1)? @"":@"s"];
    }
    else if ([conversionInfo hour] > 0) {
        // Older than 1 hour, display "Updated 3 hours ago"
        return [NSString stringWithFormat:@"%@ %d hour%@ ago", prefixString, [conversionInfo hour], ([conversionInfo hour] == 1)? @"":@"s"];
    }
    else if ([conversionInfo minute] > 0) {
        // Older than 1 minute, display "Updated 3 minutes ago"
        return [NSString stringWithFormat:@"%@ %d minute%@ ago", prefixString, [conversionInfo minute], ([conversionInfo minute] == 1)? @"":@"s"];
    }

    // Less than 1 minute old, display "Updated 3 seconds ago"
    return [NSString stringWithFormat:@"%@ %d second%@ ago", prefixString, [conversionInfo second], ([conversionInfo second] == 1)? @"":@"s"];
}

@end
