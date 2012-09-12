//
//  MoMangaDownloadQueue.h
//  MangaEden
//
//  Created by Cuccku on 8/25/12.
//  Copyright (c) 2012 Cuccku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MoChapterDownloadQueue;

@interface MoMangaDownloadQueue : NSManagedObject

@property (nonatomic, retain) NSNumber * host_id;
@property (nonatomic, retain) NSNumber * manga_id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * progress;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSString * thumbnail_path;
@property (nonatomic, retain) NSNumber * total_downloading;
@property (nonatomic, retain) NSNumber * total_queued;
@property (nonatomic, retain) NSSet *chapterDownloadQueues;
@end

@interface MoMangaDownloadQueue (CoreDataGeneratedAccessors)

- (void)addChapterDownloadQueuesObject:(MoChapterDownloadQueue *)value;
- (void)removeChapterDownloadQueuesObject:(MoChapterDownloadQueue *)value;
- (void)addChapterDownloadQueues:(NSSet *)values;
- (void)removeChapterDownloadQueues:(NSSet *)values;

@end
