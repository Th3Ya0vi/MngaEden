//
//  MoManga.h
//  MangaEden
//
//  Created by Cuccku on 8/25/12.
//  Copyright (c) 2012 Cuccku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MoChapter;
//
@interface MoManga : NSManagedObject

@property (nonatomic, retain) NSString * alphabetical;
@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * author_index;
@property (nonatomic, retain) NSString * categories;
@property (nonatomic, retain) NSNumber * completed;
@property (nonatomic, retain) NSNumber * direction;
@property (nonatomic, retain) NSNumber * favourite;
@property (nonatomic, retain) NSNumber * host_id;
@property (nonatomic, retain) NSDate * last_browsed_date;
@property (nonatomic, retain) NSNumber * last_opened_chapter_id;
@property (nonatomic, retain) NSString * last_opened_chapter_name;
@property (nonatomic, retain) NSDate * last_opened_date;
@property (nonatomic, retain) NSNumber * last_update;
@property (nonatomic, retain) NSNumber * license;
@property (nonatomic, retain) NSString * manga_id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * new_updated_total;
@property (nonatomic, retain) NSNumber * old_mid;
@property (nonatomic, retain) NSNumber * rank;
@property (nonatomic, retain) NSNumber * rank_index;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * thumbnail_path;
@property (nonatomic, retain) NSString * thumbnail_url;
@property (nonatomic, retain) NSNumber * total_chapter;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSSet *moChapters;
@end

@interface MoManga (CoreDataGeneratedAccessors)

- (void)addMoChaptersObject:(MoChapter *)value;
- (void)removeMoChaptersObject:(MoChapter *)value;
- (void)addMoChapters:(NSSet *)values;
- (void)removeMoChapters:(NSSet *)values;

@end
