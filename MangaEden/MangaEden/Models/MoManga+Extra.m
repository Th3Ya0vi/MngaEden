//
//  MoManga+Extra.m
//  quickmanga
//
//  Created by hieu.tran on 3/6/11.
//  Copyright 2011 Not A Basement Studio. All rights reserved.
//

#import "MoManga+Extra.h"
#import "MoChapter.h"
#import "ImportersConfig.h"
@implementation MoManga (Extra)
#pragma mark -
#pragma mark check if need to download anything
// comment  ------------------
- (BOOL) isNeedToDownloadMangaDetail
{
    /*
	if (UIAppDelegateIphone.currentNetworkStatus == NotReachable) {
		return NO;
	}
	*/
	if ([self.new_updated_total intValue] > 0) {
		return YES;
	}
	
	if ([[self.moChapters allObjects] count] != [self.total_chapter intValue]) {
		return YES;
	}
	
	if (self.last_browsed_date == nil) {
		return YES;
	} else {
		NSDate *currentDate = [NSDate date];
		
		NSTimeInterval lastDiff = [self.last_browsed_date timeIntervalSinceNow];
		NSTimeInterval currentDiff = [currentDate timeIntervalSinceNow];
		NSTimeInterval dateDiff = lastDiff - currentDiff;
		
		int hourDiff = dateDiff/3600;
		
		if (hourDiff < 2) {
			return NO;
		} else {
			return YES;
		}
	}	
	return YES;
}	
- (BOOL) isNeedToDownloadMangaThumbnail
{
	if (UIAppDelegate.currentNetworkStatus == NotReachable) {
		return NO;
	}
	if (self.thumbnail_url == nil) {
		return NO;
	}
	
	return ![[NSFileManager defaultManager] fileExistsAtPath:self.thumbnail_path];	
}

- (BOOL) isNeedToUpdate
{
	if (UIAppDelegate.currentNetworkStatus == NotReachable) {
		return NO;
	}	
	return YES;
}

#pragma mark -
#pragma mark others
-(NSString *)statusString{
	if ([self.completed boolValue] == YES) {
		return @"Completed";
	}
	return @"Ongoing";
}

-(NSString *)directionString{
	if (self.direction == [NSNumber numberWithInt:0]) {
		return @"Unknown";
	}
	if (self.direction == [NSNumber numberWithInt:1]) {
		return @"Left to Right";
	}
	
	return @"Right to Left";
}

#pragma mark -
#pragma mark thumbnail
- (NSString *)constructThumbnailPath{
	//this method, beside returns the actual path of thumbnail image, it also creates all nesscary folders and assign value for thumbnail_path in coredata
	NSString *path;
	NSString *filename = @"thumbnail.jpg";
	NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	
	if (self.manga_id == nil) {
		return nil;
	}
	
	path = [docsDirectory stringByAppendingPathComponent:MANGA_MAIN_DIRECTORY];
	
	DLog(@"PATH =%@",path);
	BOOL isDir;
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir]) {
		[[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil]; 
		
		path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%d",[self.manga_id intValue]]];
		DLog(@"path = %@",path);
		
		[[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil]; 
	} else {
		DLog(@"create manga_id folder");
		path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%d",[self.manga_id intValue]]];
		DLog(@"path = %@",path);
		if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir] && isDir) { 
			[[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil]; 
		}
	}
	path = [path stringByAppendingPathComponent:filename];
	self.thumbnail_path = path;
	
	NSLog(@"thumbnail_path = %@",path);
	return path;
}

- (UIImage *)UIImageForThumbnail{
	DLog(@"- UIImageForThumbnail ***** %@",self.thumbnail_path);
	if ([[NSFileManager defaultManager] fileExistsAtPath:self.thumbnail_path]) {
		DLog(@"thumbnail path = %@",self.thumbnail_path);
		UIImage *img = [UIImage imageWithContentsOfFile:self.thumbnail_path];
		return img;
	}
	return nil;
}

- (int)totalDownloadedChapters{
	NSArray *array = [self.moChapters allObjects];
	NSArray *downloadedArray = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"download_status = %d",DMDownloadedStatus]];
	return [downloadedArray count];
}

- (NSString *)sourceName{

	if ([self.host_id intValue] == MangableSource) {
		return @"Mangable";
	}
	return @"MangaFox";
}

- (MoChapter *)recentChapter{
	if ([self.last_opened_chapter_id intValue] == 0) {
		return nil;
	}
	
	NSArray *array = [self.moChapters allObjects];
	for (MoChapter *c in array){
		if ([c.chapter_id intValue] == [self.last_opened_chapter_id intValue]) {
			return c;
		}
	}
	return nil;
}
@end
