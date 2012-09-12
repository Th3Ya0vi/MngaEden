//
//  DataImporterOperation.h
//  MangaEden
//
//  Created by Cuccku on 8/24/12.
//  Copyright (c) 2012 Cuccku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"
#import "ImportersConfig.h"
#import <CoreData/CoreData.h>
@interface DataImporterOperation : NSOperation {
	NSURLConnection *dataConnection;
	
	
	NSManagedObjectContext *insertionContext;
	NSPersistentStoreCoordinator *persistentStoreCoordinator;
	NSEntityDescription *aMangaEntityDescription;
	
	UIBackgroundTaskIdentifier bgTask;	
	
	NSMutableData *importingData;	
	NSURL *url;
	
	// Overall state of the importer, used to exit the run loop.
    BOOL done;	
}

@property (nonatomic, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSManagedObjectContext *insertionContext;
@property (nonatomic, retain, readonly) NSEntityDescription *aMangaEntityDescription;

@property BOOL done;
@property (nonatomic, retain) NSURLConnection *dataConnection;

@property (nonatomic, retain) NSMutableData *importingData;
@property (nonatomic, retain) NSURL *url;

- (void)cancelOperation;
- (void)forwardError:(NSError *)error;

- (NSString *)stringForURL;
- (void)beforeOperation;
- (void)afterOperation;

- (NSError *)processData:(NSData *)content;

@end
