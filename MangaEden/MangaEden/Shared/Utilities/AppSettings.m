//
//  AppSettings.m
//  quickmanga
//
//  Created by Luong Thanh Khanh on 3/28/10.
//  Copyright 2010 NotAbasement.com. All rights reserved.
//

#import "AppSettings.h"


@implementation AppSettings

+(NSString *)countryName{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	if ([defaults stringForKey:@"country_name"] != nil) {
		return [defaults stringForKey:@"country_name"];	
	} else {
		NSLocale *locale = [NSLocale currentLocale];
		NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];
		
		NSString *countryName = [locale displayNameForKey: NSLocaleCountryCode value: countryCode];
		
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		[defaults setObject:countryName forKey:@"country_name"];
		[NSUserDefaults resetStandardUserDefaults];
		
		return countryName;
	}
}

+(NSDate*)lastUpdateDate{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSDate *date = (NSDate*)[defaults objectForKey:@"last_update_date"];
	
	if (date == nil) {
		date = [NSDate date];
		[defaults setObject:date forKey:@"last_update_date"];
		[NSUserDefaults resetStandardUserDefaults];
	}
	return date;
}
+(void)setLastUpdateDate:(NSDate *)date{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:date forKey:@"last_update_date"];
	[NSUserDefaults resetStandardUserDefaults];
}

+(BOOL)autoUpdateMangaList{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults boolForKey:@"auto_update_manga_list"];
}
+(void)setAutoUpdateManagaList:(BOOL)isAuto{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	[defaults setBool:isAuto forKey:@"auto_update_manga_list"];
 	[NSUserDefaults resetStandardUserDefaults];
}

+(int)lastLocalMangaId{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults integerForKey:@"last_local_manga_id"];
}
+(void)setLastLocalMangaId:(int)lastId{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger:lastId forKey:@"last_local_manga_id"];
	[NSUserDefaults resetStandardUserDefaults];
}

+(int)totalUncheckFav{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults integerForKey:@"total_uncheck_fav"];
}
+(void)setTotalUncheckFav:(int)total{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger:total forKey:@"total_uncheck_fav"];
	[NSUserDefaults resetStandardUserDefaults];
}

+(BOOL)soundOn{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	return [defaults boolForKey:@"sound_on"]; 	
}
+(void)setSoundOn:(BOOL)isSoundOn{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	[defaults setBool:isSoundOn forKey:@"sound_on"];
 	[NSUserDefaults resetStandardUserDefaults];
}

+(BOOL)autoHideMenu{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	return [defaults boolForKey:@"auto_hide_menu"]; 
}
+(void)setAutoHideMenu:(BOOL)isAutoHideMenu{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	[defaults setBool:isAutoHideMenu forKey:@"auto_hide_menu"];
 	[NSUserDefaults resetStandardUserDefaults];
}

+(BOOL)autoDeleteChapter{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	return [defaults boolForKey:@"auto_delete_chapter"]; 
}
+(void)setAutoDeleteChapter:(BOOL)isAutoDeleteChapter{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	[defaults setBool:isAutoDeleteChapter forKey:@"auto_delete_chapter"];
 	[NSUserDefaults resetStandardUserDefaults];
}

+(BOOL)disableAutoPhoneLock{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	return [defaults boolForKey:@"disable_auto_phone_lock"]; 
}
+(void)setDisableAutoPhoneLock:(BOOL)isDisableAutoPhoneLock{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	[defaults setBool:isDisableAutoPhoneLock forKey:@"disable_auto_phone_lock"];
 	[NSUserDefaults resetStandardUserDefaults];
}

+(BOOL)reset{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	return [defaults boolForKey:@"is_reset"]; 	
}
+(void)setReset:(BOOL)isReset{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	[defaults setBool:isReset forKey:@"is_reset"];
 	[NSUserDefaults resetStandardUserDefaults];
}

+(BOOL)needToMigrateDB{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	return [defaults boolForKey:@"need_to_migratedb"]; 	
}
+(void)setNeedToMigrateDB:(BOOL)isNeedToMigrateDB{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	[defaults setBool:isNeedToMigrateDB forKey:@"need_to_migratedb"];
 	[NSUserDefaults resetStandardUserDefaults];
}


+(float)totalDiskSpace{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	return [defaults floatForKey:@"total_disk_space"];
}
+(void)setTotalDiskSpace:(float)totalDiskSpace{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	[defaults setFloat:totalDiskSpace forKey:@"total_disk_space"];
	[NSUserDefaults resetStandardUserDefaults];
}

+(NSString *)versionNumber{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	return [defaults objectForKey:@"version_number"];
}
+(void)setVersion:(NSString *)versionNumber{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	[defaults setObject:versionNumber forKey:@"version_number"];
	[NSUserDefaults resetStandardUserDefaults];
}

+(int)lastQueueNumber{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults integerForKey:@"last_queue_number"];	
}
+(void)setLastQueueNumber:(int)queueNumber{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger:queueNumber forKey:@"last_queue_number"];
	[NSUserDefaults resetStandardUserDefaults];
}

+(int)hostid{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults integerForKey:@"host_id"];	
}

+(void)setHostid:(int)hostid{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger:hostid forKey:@"host_id"];
	[NSUserDefaults resetStandardUserDefaults];
}

+(long long)lastUpdate{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults integerForKey:@"lastUpdate"];
}

+(void)setLastUpdate:(long long)timestamp{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger:timestamp forKey:@"lastUpdate"];
	[NSUserDefaults resetStandardUserDefaults];	
}
+(BOOL)autoCropImage {
	return NO;
}
+(void)setAutoCropImage:(BOOL)isAutoCropImage {
}

+(int)totalConcurrentDownloadingChapter{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults integerForKey:@"totalConcurrentDownloadingChapter"];
}
+(void)setTotalConcurrentDownloadingChapter:(int)total{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger:total forKey:@"totalConcurrentDownloadingChapter"];
	[NSUserDefaults resetStandardUserDefaults];	
}
+(void)setChapterListOrder:(BOOL)isAccending{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	[defaults setBool:isAccending forKey:@"isAccending"];
 	[NSUserDefaults resetStandardUserDefaults];	
}
+(BOOL)chapterListOrder{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	return [defaults boolForKey:@"isAccending"];	
}

+(int)totalNewsCount{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults integerForKey:@"totalNewsCount"];
}

+(void)setTotalNewsCount:(int)total{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger:total forKey:@"totalNewsCount"];
	[NSUserDefaults resetStandardUserDefaults];	
}

+(int)readingDirection {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	return [defaults integerForKey:@"reading_direction"];
}

+(void)setReadingDirection:(int)readingDirection {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	[defaults setInteger:readingDirection forKey:@"reading_direction"];
	[NSUserDefaults resetStandardUserDefaults];
}

+(int)tapLocation {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	return [defaults integerForKey:@"tap_location"];
}

+(void)setTapLocation:(int)tapLocation {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	[defaults setInteger:tapLocation forKey:@"tap_location"];
	[NSUserDefaults resetStandardUserDefaults];
}

+(BOOL)shouldLaunchViewerWithBookView {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	return [defaults boolForKey:@"launch_viewer_with_book_view"]; 
}

+(void)setShouldLaunchViewerWithBookView:(BOOL)shouldLaunchViewerWithBookView {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	[defaults setBool:shouldLaunchViewerWithBookView forKey:@"launch_viewer_with_book_view"];
 	[NSUserDefaults resetStandardUserDefaults];
}

+(BOOL)autoUpdateAfterLaunch{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	return [defaults boolForKey:@"auto_update_after_launch"]; 	
}
+(void)setAutoUpdateAfterLaunch:(BOOL)isAutoDeleteChapter{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	[defaults setBool:isAutoDeleteChapter forKey:@"auto_update_after_launch"];
 	[NSUserDefaults resetStandardUserDefaults];
}

+(BOOL)shouldShowTipsWhileLoading{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	return [defaults boolForKey:@"should_show_tips_while_loading"]; 	
}

+(void)setShouldShowTipsWhileLoading:(BOOL)isShouldShow{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	[defaults setBool:isShouldShow forKey:@"should_show_tips_while_loading"];
 	[NSUserDefaults resetStandardUserDefaults];
}
@end
