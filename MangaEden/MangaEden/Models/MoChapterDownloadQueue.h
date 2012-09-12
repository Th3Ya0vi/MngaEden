//
//  MoChapterDownloadQueue.h
//  MangaEden
//
//  Created by Cuccku on 8/25/12.
//  Copyright (c) 2012 Cuccku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MoMangaDownloadQueue;

@interface MoChapterDownloadQueue : NSManagedObject

@property (nonatomic, retain) NSNumber * chapter_id;
@property (nonatomic, retain) NSNumber * chapter_number;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * page_pos;
@property (nonatomic, retain) NSNumber * progress;
@property (nonatomic, retain) NSNumber * queue_no;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) MoMangaDownloadQueue *mangaDownloadQueue;

@end
