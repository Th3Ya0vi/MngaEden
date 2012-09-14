//
//  RetrieveChapterListOperation.h
//  quickmanga
//
//  Created by Luong Ken on 1/26/11.
//  Copyright 2011 Not A Basement Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataImporterOperation.h"
//#import "aManga+Extra.h"
#import "NSString+HTML.h"

@protocol RetrieveChapterListOperationDelegate <NSObject>

@optional
- (void) retrieveChapterListOperationWillImportData:(long long)size;
- (void) retrieveChapterListOperationDidFinishImportingData;
- (void) retrieveChapterListOperationDidFailImportingData:(NSError *)error;


// Notification posted by NSManagedObjectContext when saved.
- (void) retrieveChapterListOperationDidSave:(NSNotification *)saveNotification;

@end
@interface RetrieveChapterListOperation : DataImporterOperation {
	id <RetrieveChapterListOperationDelegate> delegate;		
	NSManagedObjectID *aMangaObjectID;
	
	NSString *manga_id;
}

@property (nonatomic, assign) id <RetrieveChapterListOperationDelegate> delegate;
@property (nonatomic, retain) NSManagedObjectID *aMangaObjectID;
- (RetrieveChapterListOperation *)initWithPersistenceStoreCoordinator:(NSPersistentStoreCoordinator *)psc andAMangaObjectID:(NSManagedObjectID *)objectID;


@end
