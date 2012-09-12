//
//  MoChapter.h
//  MangaEden
//
//  Created by Cuccku on 8/25/12.
//  Copyright (c) 2012 Cuccku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MoManga;

@interface MoChapter : NSManagedObject

@property (nonatomic, retain) NSDate * added_date;
@property (nonatomic, retain) NSNumber * chapter_id;
@property (nonatomic, retain) NSNumber * chapter_number;
@property (nonatomic, retain) NSNumber * download_status;
@property (nonatomic, retain) NSString * manga_id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * recent_page_pos;
@property (nonatomic, retain) NSNumber * total_page;
@property (nonatomic, retain) MoManga *moManga;

@end
