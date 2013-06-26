//
//  NSDateAdditions+EX.m
//  Domo Depression
//
//  Created by Harish Kamath on 3/10/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "NSDateAdditions+EX.h"

@implementation NSDate (NSDateAdditions_EX)

- (NSDate *)dateAtMidnight {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    NSDateComponents *dateComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self];
    [dateComponents setHour:0];
    [dateComponents setMinute:0];
    [dateComponents setSecond:0];
    
    NSDate *midnightUTC = [calendar dateFromComponents:dateComponents];
    
    return midnightUTC;
}
@end
