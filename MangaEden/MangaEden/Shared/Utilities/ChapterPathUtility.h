//
//  ChapterPathUtility.h
//  mr_hd
//
//  Created by Luong Thanh Khanh on 11/1/10.
//  Copyright 2010 Not A Basement Studio. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ChapterPathUtility : NSObject {

}

+(NSString *)constructPathForChapterWithMangaId:(int)manga_id andChapterId:(int)chapter_id;
+(NSString *)constructPathForChapterPageWithMangaId:(int)manga_id andChapterId:(int)chapter_id andPagePos:(int)page_pos;
+(NSString *)constructPathForChapterPageThumbnailWithMangaId:(int)manga_id andChapterId:(int)chapter_id andPagePos:(int)page_pos;
+(NSString *)constructPathForChapterTempPageWithMangaId:(int)manga_id andChapterId:(int)chapter_id andPagePos:(int)page_pos;
+(NSString *)constructPathForChapterPlistFileWithMangaId:(int)manga_id andChapterId:(int)chapter_id;

+(BOOL)isJSONFileExistedForChapterWithMangaId:(int)manga_id andChapterId:(int)chapter_id;
+(BOOL)isImgFileExitedForChapterWithMangaId:(int)manga_id andChapterId:(int)chapter_id andPagePos:(int)page_pos;
+(BOOL)isImgThumbnailFileExitedForChapterWithMangaId:(int)manga_id andChapterId:(int)chapter_id andPagePos:(int)page_pos;

+(void)renameChapterTempPageForChapterWithMangaId:(int)manga_id andChapterId:(int)chapter_id andPagePos:(int)page_pos;


@end
