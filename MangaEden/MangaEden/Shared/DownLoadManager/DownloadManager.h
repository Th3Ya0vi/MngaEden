//
//  DownloadManager.h
//  MangaEden
//
//  Created by Cuccku on 8/24/12.
//  Copyright (c) 2012 Cuccku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChapterDownloader.h"
/*typedef enum  {
 DM_NEW,
 DM_FETCHING,
 DM_FAILED,
 DM_COMPLETE
 } STATUS;
 */
//may be add some status
enum {
	DMNothing = 0,
	DMDidFinishLoadingChapterPage,
	DMDidFinishDownloadingChapter,
	DMQueueIsProcessing,
	DMQueueDoneProcessing
};
extern NSString *const kDMStatusChangeNotification;
@interface DownloadManager : NSObject
{
    NSManagedObjectContext *managedObjectContext;
	NSPersistentStoreCoordinator *persistentStoreCoordinator;
    
	NSOperationQueue *operationQueue;
	
	NSMutableArray *downloadingQueue;
    
    UIBackgroundTaskIdentifier bgTaskDownloadChapters;
	
	BOOL isProcessing;
    
    ChapterDownloader *downloadChapter;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) ChapterDownloader *downloadChapter;

@property (nonatomic, retain) NSMutableArray *downloadingQueue;
@property (nonatomic, retain) NSOperationQueue *operationQueue;


@property (nonatomic) BOOL isProcessing;

@end
