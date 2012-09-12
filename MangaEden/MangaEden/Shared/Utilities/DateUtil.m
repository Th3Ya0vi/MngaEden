//
//  DateUtil.m
//  quickmanga
//
//  Created by Luong Thanh Khanh on 3/21/10.
//  Copyright 2010 NotAbasement.com. All rights reserved.
//

#import "DateUtil.h"
#define DATE_UTIL_SECS_PER_DAY 86400

static DateUtil *singletonDate = nil;

@implementation DateUtil

@synthesize today;
@synthesize yesterday;
@synthesize lastWeek;
@synthesize todayComponents;
@synthesize yesterdayComponents;
@synthesize dateFormatter;

-(void)dealloc {
	[today release];
	[yesterday release];
	[lastWeek release];
	
	[todayComponents release];
	[yesterdayComponents release];
	[dateFormatter release];
	
	[super dealloc];
}

-(void)refreshData {
	//TODO(gabor): Call this every hour or so to refresh what today, yesterday, etc. mean
	NSCalendar *gregorian = [NSCalendar currentCalendar];
	self.today = [NSDate date];
	self.yesterday = [today addTimeInterval:-DATE_UTIL_SECS_PER_DAY];
	self.lastWeek = [today addTimeInterval:-6*DATE_UTIL_SECS_PER_DAY];
	self.todayComponents = [gregorian components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:today];
	self.yesterdayComponents = [gregorian components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:yesterday];
	self.dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
}

-(id)init {
    self = [super init];
	if (self != nil) {      
		[self refreshData];
	}
	return self;
}

+(id)getSingleton { //NOTE: don't get an instance of SyncManager until account settings are set!
	@synchronized(self) {
		if (singletonDate == nil) {
			singletonDate = [[self alloc] init];
		}
	}
	return singletonDate;
}

-(NSString*)humanDate:(NSDate*)date {
	
	NSCalendar *gregorian = [NSCalendar currentCalendar];
	
	NSDateComponents *dateComponents = [gregorian components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:date];
	
	if([dateComponents day] == [todayComponents day] && 
	   [dateComponents month] == [todayComponents month] && 
	   [dateComponents year] == [todayComponents year]) {
		[dateFormatter setDateStyle:NSDateFormatterNoStyle];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
		
		return [dateFormatter stringFromDate:date];
	}
	if([dateComponents day] == [yesterdayComponents day] && 
	   [dateComponents month] == [yesterdayComponents month] && 
	   [dateComponents year] == [yesterdayComponents year]) {
		return NSLocalizedString(@"yesterday", nil);
	}
	if([date laterDate:lastWeek] == date) {
		[dateFormatter setDateFormat:@"EEEE"];
		return [dateFormatter stringFromDate:date];
	}
	
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	
	return [dateFormatter stringFromDate:date];
}

+(NSDate *)datetimeInLocal:(NSDate *)utcDate
{
	NSTimeZone *utc = [NSTimeZone timeZoneWithName:@"UTC"];
	
	NSTimeZone *local = [NSTimeZone localTimeZone];
	
	NSInteger sourceSeconds = [utc secondsFromGMTForDate:utcDate];
	NSInteger destinationSeconds = [local secondsFromGMTForDate:utcDate];
	
	NSTimeInterval interval =  destinationSeconds - sourceSeconds;
	NSDate *res = [[[NSDate alloc] initWithTimeInterval:interval sinceDate:utcDate] autorelease];
	return res;
	
}

@end