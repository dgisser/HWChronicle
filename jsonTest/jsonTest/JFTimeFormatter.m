//
//  JFTimeFormatter.m
//  LoudTap
//
//  Created by Jason Fieldman on 11/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "JFTimeFormatter.h"


@implementation JFTimeFormatter

+ (NSString*) relativeDateStringFromTime:(uint64_t)t {
	time_t cur_time = time(0);
	struct tm * time_struct = localtime(&cur_time);
	
	time_t start_of_day = cur_time - (time_struct->tm_sec) - (time_struct->tm_min * 60) - (time_struct->tm_hour * 3600);

	/* DATE FORMAT URL: http://unicode.org/reports/tr35/tr35-4.html#Date_Format_Patterns */
	
	
	if (t > start_of_day) {
		/* We're in today; render HH:MM A */
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"h:mm a"];
		NSDate *date = [NSDate dateWithTimeIntervalSince1970:t];
		return [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
	}
	
	if (t > (start_of_day - 86400)) {
		return [NSString stringWithFormat:@"Yesterday"];
	}
	
	if (t > (start_of_day - (86400*6))) {
		/* We can render the time as a day of the week */
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"EEEE"];
		NSDate *date = [NSDate dateWithTimeIntervalSince1970:t];
		return [dateFormatter stringFromDate:date];
	}
    
    if (t > (start_of_day - (86400*364))) {
        /* Anything else, just print the date */
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //[dateFormatter setDateFormat:@"M/d/yy"];
        [dateFormatter setDateFormat:@"MMM d"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:t];
        return [dateFormatter stringFromDate:date];
    }
	
	/* Anything else, just print the date */
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	//[dateFormatter setDateFormat:@"M/d/yy"];
	[dateFormatter setDateFormat:@"MMM d, yyyy"];
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:t];
	return [dateFormatter stringFromDate:date];
	
}


+ (NSString*) relativeDateShortStringFromTime:(uint64_t)t {
	time_t cur_time = time(0);
	struct tm * time_struct = localtime(&cur_time);
	
	time_t start_of_day = cur_time - (time_struct->tm_sec) - (time_struct->tm_min * 60) - (time_struct->tm_hour * 3600);
	
	/* DATE FORMAT URL: http://unicode.org/reports/tr35/tr35-4.html#Date_Format_Patterns */
	
	
	if (t > start_of_day) {
		/* We're in today; render HH:MM A */
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"h:mm a"];
		NSDate *date = [NSDate dateWithTimeIntervalSince1970:t];
		return [dateFormatter stringFromDate:date];
	}
	
	if (t > (start_of_day - 86400)) {
		/* We can render the time as a day of the week */
		return @"Yesterday";
	}
	
	if (t > (start_of_day - (86400*5))) {
		/* We can render the time as a day of the week */
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"EEEE"];
		NSDate *date = [NSDate dateWithTimeIntervalSince1970:t];
		return [dateFormatter stringFromDate:date];
	}
	
	/* Anything else, just print the date */
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	//[dateFormatter setDateFormat:@"M/d/yy"];
	[dateFormatter setDateFormat:@"MM/d/yy"];
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:t];
	return [dateFormatter stringFromDate:date];
	
}

@end

