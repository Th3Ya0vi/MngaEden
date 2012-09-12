//
//  MoManga+Extra.h
//  quickmanga
//
//  Created by hieu.tran on 3/6/11.
//  Copyright 2011 Not A Basement Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppConfig.h"
#import "MoManga.h"

@interface MoManga (Extra)

- (BOOL) isNeedToDownloadMangaDetail;
- (BOOL) isNeedToDownloadMangaThumbnail;
- (BOOL) isNeedToUpdate;

- (NSString *)statusString;
- (NSString *)directionString;

- (NSString *)constructThumbnailPath;
- (UIImage *)UIImageForThumbnail;
- (int)totalDownloadedChapters;
- (MoChapter *)recentChapter;
- (NSString *)sourceName;
@end
