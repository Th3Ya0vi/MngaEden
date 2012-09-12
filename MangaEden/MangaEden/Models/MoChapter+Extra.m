//
//  MoChapter+Extra.m
//  quickmanga
//
//  Created by hieu.tran on 3/6/11.
//  Copyright 2011 Not A Basement Studio. All rights reserved.
//

#import "MoChapter+Extra.h"
#import "ChapterPathUtility.h"
#import "MoManga+Extra.h"
#import "ImportersConfig.h"
@implementation MoChapter(Extra)
- (NSString *)chapterNumberSection 
{	
	if ([self.chapter_number intValue] < 10) {
		return @"1";
	} else {
		int number = floor([self.chapter_number intValue]/10) * 10;
		return [NSString stringWithFormat:@"%d",number];
	}
}

- (void)eraseChapterFromDisk{
	NSError *error = nil;
	[[NSFileManager defaultManager] removeItemAtPath:[ChapterPathUtility constructPathForChapterWithMangaId:[self.manga_id intValue] andChapterId:[self.chapter_id intValue]] error:&error];
}

- (NSURL *)urlForPageNo:(int)pageNo{
	if ([ChapterPathUtility isJSONFileExistedForChapterWithMangaId:[self.manga_id intValue] andChapterId:[self.chapter_id intValue]]) {
		NSData *data = [NSData dataWithContentsOfFile:[ChapterPathUtility constructPathForChapterPlistFileWithMangaId:[self.manga_id intValue] andChapterId:[self.chapter_id intValue]]];
		if (data == nil) {
			return nil;
		}
		//parse plist data
		NSPropertyListFormat format;
		id plist;
		
		NSString *desc;
		plist = [NSPropertyListSerialization propertyListFromData:data mutabilityOption:0 format:&format errorDescription:&desc];	
		
		NSArray *pagesList = (NSArray *)plist;
		
		return [NSURL URLWithString:[pagesList objectAtIndex:pageNo]];
	}
	return nil;
}

- (MoChapter *)nextChapter{
	if ([self.chapter_number intValue] == [[self.moManga.moChapters allObjects] count]) {
		return nil;
	} else {
		int nextChapterNumber = [self.chapter_number intValue] + 1;
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"chapter_number = %d", nextChapterNumber];

		NSArray *result = [[self.moManga.moChapters allObjects] filteredArrayUsingPredicate:predicate];
		
		if ([result count] >0) {
			return [result objectAtIndex:0];
		} else {
			return nil;
		}
	}
}
- (MoChapter *)previousChapter{
	if ([self.chapter_number intValue] == 1) {
		return nil;
	} else {
		int previousChapterNumber = [self.chapter_number intValue] - 1;
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"chapter_number = %d", previousChapterNumber];
		
		NSArray *result = [[self.moManga.moChapters allObjects] filteredArrayUsingPredicate:predicate];
		
		if ([result count] >0) {
			return [result objectAtIndex:0];
		} else {
			
			return nil;
		}
	}
}

@end
