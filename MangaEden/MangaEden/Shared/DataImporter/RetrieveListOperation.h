//
//  InitialDataImporterOperation.h
//  quickmanga
//
//  Created by Luong Ken on 1/23/11.
//  Copyright 2011 Not A Basement Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataImporterOperation.h"
#import "NSString+HTML.h"
@class HomeViewController;
@protocol RetrieveListOperationDelegate <NSObject>

@optional
- (void) retrieveListOperationWillDonwloadDataWithSize:(long long)size;
- (void) retrieveListOperationDidDonwloadDataAtCurrentSize:(long long)size;
- (void) retrieveListOperationDidFinishImportingData;
- (void) retrieveListOperationDidFailImportingData:(NSError *)error;

// Notification posted by NSManagedObjectContext when saved.
- (void) retrieveListOperationDidSave:(NSNotification *)saveNotification;

@end


@interface RetrieveListOperation : DataImporterOperation {
	id <RetrieveListOperationDelegate> delegate;

}

@property (nonatomic, assign) id <RetrieveListOperationDelegate> delegate;

- (RetrieveListOperation *)initWithPersistenceStoreCoordinator:(NSPersistentStoreCoordinator *)psc;

@end
