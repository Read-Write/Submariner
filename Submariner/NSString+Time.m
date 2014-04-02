//
//  NSString+Time.m
//  Play
//
//  Created by nark on 14/02/11.
//  Copyright 2011 Read-Write.fr. All rights reserved.
//

#import "NSString+Time.h"


@implementation NSString (Time)

+ (NSString *)stringWithTime:(double)time {
	
	if(time == 0)
		return @"0:00";
	
	NSMutableString *_string = [NSMutableString stringWithCapacity:2];
	int minutes = 0;
	int seconds = 0;
	BOOL isNegative = NO;
	
	if(time < 0) {
		
		isNegative = YES;
		time = fabs(time);
		
		minutes = time / 60;
		seconds = (int)time % 60;
		
	} else {
		
		minutes = time / 60;
		seconds = (int)time % 60;
		
	}
	
	NSString *minutesString = [NSString stringWithFormat:@"%d", minutes];
	NSString *secondsString = [NSString stringWithFormat:@"%d", seconds];
	
	if([minutesString length] == 1)
		minutesString = [@"0" stringByAppendingString:minutesString];
	
	if([secondsString length] == 1)
		secondsString = [@"0" stringByAppendingString:secondsString];
	
	if(isNegative) {
		[_string appendFormat:@"-%@:%@", minutesString, secondsString];

	} else {
		[_string appendFormat:@"%@:%@", minutesString, secondsString];

	}
	
	return _string;
	
}

@end
