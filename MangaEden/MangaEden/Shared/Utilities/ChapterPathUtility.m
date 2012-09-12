//
//  ChapterPathUtility.m
//  mr_hd
//
//  Created by Luong Thanh Khanh on 11/1/10.
//  Copyright 2010 Not A Basement Studio. All rights reserved.
//

#import "ChapterPathUtility.h"
#import "AppConfig.h"

@implementation ChapterPathUtility

+(NSString *)constructPathForChapterWithMangaId:(int)manga_id andChapterId:(int)chapter_id{
	//NSString *rootDirectory = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:MANGA_MAIN_DIRECTORY];
    NSString *rootDirectory = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"fuckdiredtory"];

	//NSLog(@"rootDirectory = %@",rootDirectory);
	
	NSString *finalPath = [rootDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%d",manga_id]];
	finalPath = [finalPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d",chapter_id]];
	
	//NSLog(@"finalPath = %@",finalPath);
	NSString *path = [rootDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%d",manga_id]]; //point to manga_id folder
	//NSLog(@"path = %@",path);
	BOOL isDir;
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:finalPath]){
		// check if manga folder existed
		if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir] && isDir) {
			//if existed, append chapter_id to path
			path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%d",chapter_id ]];
			//check if chapter folder existed
			if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir] && isDir) {
				
			} else { 
				//create chapter folder
				[[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
			}
		} else{
			[[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil]; //create manga_id directory
			path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%d",chapter_id]];
			[[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil]; //create chapter_id directory	
		}		
	} 
	
	return finalPath;
}

+(NSString *)constructPathForChapterPageWithMangaId:(int)manga_id andChapterId:(int)chapter_id andPagePos:(int)page_pos;{
	NSString *path = [ChapterPathUtility constructPathForChapterWithMangaId:manga_id andChapterId:chapter_id];
	return [path stringByAppendingPathComponent: [NSString stringWithFormat:@"%d.jpg",page_pos]];	
}

+(NSString *)constructPathForChapterPageThumbnailWithMangaId:(int)manga_id andChapterId:(int)chapter_id andPagePos:(int)page_pos{
	NSString *path = [ChapterPathUtility constructPathForChapterWithMangaId:manga_id andChapterId:chapter_id];
	return [path stringByAppendingPathComponent: [NSString stringWithFormat:@"thumbnail%d.jpg",page_pos]];	
}

+(NSString *)constructPathForChapterTempPageWithMangaId:(int)manga_id andChapterId:(int)chapter_id andPagePos:(int)page_pos{
	NSString *path = [ChapterPathUtility constructPathForChapterWithMangaId:manga_id andChapterId:chapter_id];
	return [path stringByAppendingPathComponent: [NSString stringWithFormat:@"temp_%d.jpg",page_pos]];	
}

+(NSString *)constructPathForChapterPlistFileWithMangaId:(int)manga_id andChapterId:(int)chapter_id{
	NSString *chapterPath = [ChapterPathUtility constructPathForChapterWithMangaId:manga_id andChapterId:chapter_id];
	NSString *plist_name = @"chapter.json";
	return [chapterPath stringByAppendingPathComponent:plist_name];
}

+(BOOL)isJSONFileExistedForChapterWithMangaId:(int)manga_id andChapterId:(int)chapter_id{
	return [[NSFileManager defaultManager] fileExistsAtPath: [self constructPathForChapterPlistFileWithMangaId:manga_id andChapterId:chapter_id]];	
}

+(BOOL)isImgFileExitedForChapterWithMangaId:(int)manga_id andChapterId:(int)chapter_id andPagePos:(int)page_pos{
	return [[NSFileManager defaultManager] fileExistsAtPath: [self constructPathForChapterPageWithMangaId:manga_id andChapterId:chapter_id andPagePos:page_pos]];
}

+(BOOL)isImgThumbnailFileExitedForChapterWithMangaId:(int)manga_id andChapterId:(int)chapter_id andPagePos:(int)page_pos{
	return [[NSFileManager defaultManager] fileExistsAtPath: [self constructPathForChapterPageThumbnailWithMangaId:manga_id andChapterId:chapter_id andPagePos:page_pos]];
}

+(void)renameChapterTempPageForChapterWithMangaId:(int)manga_id andChapterId:(int)chapter_id andPagePos:(int)page_pos{
	NSString *oldPath = [self constructPathForChapterTempPageWithMangaId:manga_id andChapterId:chapter_id andPagePos:page_pos];
	NSString *newFilename = [NSString stringWithFormat:@"%d.jpg",page_pos];
	
	NSString *newPath = [[oldPath stringByDeletingLastPathComponent] stringByAppendingPathComponent:newFilename];
	[[NSFileManager defaultManager] moveItemAtPath:oldPath toPath:newPath error:nil];
}
@end
