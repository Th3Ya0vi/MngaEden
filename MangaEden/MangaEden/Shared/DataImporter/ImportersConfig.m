//
//  ImportersConfig.m
//  quickmanga
//
//  Created by Luong Ken on 1/23/11.
//  Copyright 2011 Not A Basement Studio. All rights reserved.
//

#import "ImportersConfig.h"


//NSString * const kBaseURL = @"http://drdev.ltkjguru.webfactional.com/plistmrquery10.php?action=";
//plistmrquery10(not_reviewed).php
//NSString * const kBaseURL = @"http://komikconnect.com/plistmrquery10.php?action=";
//NSString * const kBaseURL = @"http://komikconnect.com/plistmrquery10(not_reviewed).php?action=";

NSString * const kBaseURL = @"http://komikconnect.com/plistmrquery10.php?action=";

#ifdef MRMF_APP
NSString * const kBaseURL = @"http://komikconnect.com/plistmrmfquery201.php?action=";
#endif


NSString * const kRetrieveListActionName = @"retrieve_list";
NSString * const kSyncListActionName = @"sync";
NSString * const kRetrieveMangaInfoActionName = @"retrieve_info";
NSString * const kRetrieveChapterListActionName = @"chapter_list";
NSString * const kRetrieveChapterPagesActionName = @"retrieve_pages";
NSString * const kReloadChapterPagesActionName = @"reload_pages";