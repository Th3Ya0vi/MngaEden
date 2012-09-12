//
//  AppSettings.h
//  quickmanga
//
//  Created by Luong Thanh Khanh on 3/28/10.
//  Copyright 2010 NotAbasement.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AppSettings : NSObject {
	

}

+(NSString *)countryName;

+(NSDate*)lastUpdateDate;
+(void)setLastUpdateDate:(NSDate *)date;

+(BOOL)autoUpdateMangaList;
+(void)setAutoUpdateManagaList:(BOOL)isAuto;

+(int)lastLocalMangaId;
+(void)setLastLocalMangaId:(int)lastId;

+(BOOL)soundOn;
+(void)setSoundOn:(BOOL)isSoundOn;

+(BOOL)reset;
+(void)setReset:(BOOL)isReset;

+(float)totalDiskSpace;
+(void)setTotalDiskSpace:(float)totalDiskSpace;

+(int)totalUncheckFav;
+(void)setTotalUncheckFav:(int)total;

+(NSString *)versionNumber;
+(void)setVersion:(NSString *)versionNumber;

+(BOOL)autoHideMenu;
+(void)setAutoHideMenu:(BOOL)isAutoHideMenu;

+(BOOL)autoDeleteChapter;
+(void)setAutoDeleteChapter:(BOOL)isAutoDeleteChapter;

+(BOOL)disableAutoPhoneLock;
+(void)setDisableAutoPhoneLock:(BOOL)isDisableAutoPhoneLock;

+(int)lastQueueNumber;
+(void)setLastQueueNumber:(int)queueNumber;

+(BOOL)needToMigrateDB;
+(void)setNeedToMigrateDB:(BOOL)isNeedToMigrateDB;

+(int)hostid;
+(void)setHostid:(int)hostid;

+(long long)lastUpdate;
+(void)setLastUpdate:(long long)timestamp;

+(BOOL)autoCropImage;
+(void)setAutoCropImage:(BOOL)isAutoCropImage;

+(int)totalConcurrentDownloadingChapter;
+(void)setTotalConcurrentDownloadingChapter:(int)total;

+(void)setChapterListOrder:(BOOL)isAccending;
+(BOOL)chapterListOrder;

+(int)totalNewsCount;
+(void)setTotalNewsCount:(int)total;

+(int)readingDirection;
+(void)setReadingDirection:(int)readingDirection;
+(int)tapLocation;
+(void)setTapLocation:(int)readingDirection;
+(BOOL)shouldLaunchViewerWithBookView;
+(void)setShouldLaunchViewerWithBookView:(BOOL)shouldLaunchViewerWithBookView;

+(BOOL)autoUpdateAfterLaunch;
+(void)setAutoUpdateAfterLaunch:(BOOL)isAutoDeleteChapter;
+(BOOL)shouldShowTipsWhileLoading;
+(void)setShouldShowTipsWhileLoading:(BOOL)isShouldShow;
@end
