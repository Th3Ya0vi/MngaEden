//
//  DateUtil.h
//  quickmanga
//
//  Created by Luong Thanh Khanh on 3/21/10.
//  Copyright 2010 NotAbasement.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DateUtil : NSObject {
	NSDate *today;
	NSDate *yesterday;
	NSDate *lastWeek;
	
	NSDateFormatter* dateFormatter;
	NSDateComponents* todayComponents;
	NSDateComponents* yesterdayComponents;
}

@property (nonatomic, retain) NSDate *today;
@property (nonatomic, retain) NSDate *yesterday;
@property (nonatomic, retain) NSDate *lastWeek;
@property (nonatomic, retain) NSDateFormatter* dateFormatter;
@property (nonatomic, retain) NSDateComponents* todayComponents;
@property (nonatomic, retain) NSDateComponents* yesterdayComponents;


+(id)getSingleton;
-(NSString*)humanDate:(NSDate*)date;
+(NSDate *)datetimeInLocal:(NSDate *)utcDate;
@end