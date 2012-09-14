//
//  ImportersConfig.h
//  quickmanga
//
//  Created by Luong Ken on 1/23/11.
//  Copyright 2011 Not A Basement Studio. All rights reserved.
//
#import <Foundation/Foundation.h>
extern NSString * const kBaseURL;
extern NSString * const kBaseURLManga;

extern NSString * const kRetrieveListActionName;
extern NSString * const kSyncListActionName;
extern NSString * const kRetrieveMangaInfoActionName;
extern NSString * const kRetrieveChapterListActionName;
extern NSString * const kRetrieveChapterPagesActionName;
extern NSString * const kReloadChapterPagesActionName;
enum MangaSource {
	MangaFoxSource = 2,
	MangableSource	
};