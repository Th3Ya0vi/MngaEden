//
//  RetrieveMangaInfoOperation.h
//  quickmanga
//
//  Created by Luong Ken on 1/25/11.
//  Copyright 2011 Not A Basement Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataImporterOperation.h"
#import "NSString+HTML.h"
@protocol RetrieveMangaInfoOperationDelegate <NSObject>

@optional
- (void) retrieveMangaInfoOperationWillImportData:(long long)size;
- (void) retrieveMangaInfoOperationDidFinishImportingDataAndRequireRefreshData:(BOOL)isNeed;
- (void) retrieveMangaInfoOperationDidFailImportingData:(NSError *)error;


// Notification posted by NSManagedObjectContext when saved.
- (void) retrieveMangaInfoOperationDidSave:(NSNotification *)saveNotification;

@end

@interface RetrieveMangaInfoOperation : DataImporterOperation {
	id <RetrieveMangaInfoOperationDelegate> delegate;		
	int manga_id;
}

@property (nonatomic, assign) id <RetrieveMangaInfoOperationDelegate> delegate;
@property (nonatomic) int manga_id;
- (RetrieveMangaInfoOperation *)initWithPersistenceStoreCoordinator:(NSPersistentStoreCoordinator *)psc andMid:(int)aManga_id;


@end
