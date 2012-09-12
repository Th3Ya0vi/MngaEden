//
//  SyncListOperation.h
//  quickmanga
//
//  Created by Luong Ken on 1/25/11.
//  Copyright 2011 Not A Basement Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataImporterOperation.h"
#import "NSString+HTML.h"
@protocol SyncListOperationDelegate <NSObject>

@optional
- (void) syncListOperationWillImportData:(long long)size;
- (void) syncListOperationDidFinishImportingData;
- (void) syncListOperationDidFailImportingData:(NSError *)error;

// Notification posted by NSManagedObjectContext when saved.
- (void) syncListOperationDidSave:(NSNotification *)saveNotification;

@end

@interface SyncListOperation : DataImporterOperation {
	id <SyncListOperationDelegate> delegate;		
}

@property (nonatomic, assign) id <SyncListOperationDelegate> delegate;

- (SyncListOperation *)initWithPersistenceStoreCoordinator:(NSPersistentStoreCoordinator *)psc;
- (void)getPushNewsCount;

@end
