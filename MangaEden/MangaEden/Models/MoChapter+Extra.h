//
//  MoChapter+Extra.h
//  quickmanga
//
//  Created by hieu.tran on 3/6/11.
//  Copyright 2011 Not A Basement Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoChapter.h"

@interface MoChapter(Extra)
- (NSString *)chapterNumberSection;
- (NSURL *)urlForPageNo:(int)pageNo;

- (void)eraseChapterFromDisk;
- (MoChapter *)nextChapter;
- (MoChapter *)previousChapter;
@end
