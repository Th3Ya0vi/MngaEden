//
//  DataImporterOperation.m
//  MangaEden
//
//  Created by Cuccku on 8/24/12.
//  Copyright (c) 2012 Cuccku. All rights reserved.
//

#import "DataImporterOperation.h"

@implementation DataImporterOperation

@synthesize url,dataConnection,importingData,done;
@synthesize persistentStoreCoordinator;

#pragma mark-
#pragma mark dealloc
- (void)dealloc{
	
	[url release];
	url = nil;
	
	[dataConnection release];
	dataConnection = nil;	
	
	[insertionContext release];
	insertionContext = nil;
	
	[aMangaEntityDescription release];
	aMangaEntityDescription = nil;
	
	[super dealloc];    
}

#pragma mark -
#pragma mark subclass override methods
- (NSString *)stringForURL{
	//subclass must override
	return nil;
}

- (void)beforeOperation{
	//subclass must override
	[UIAppDelegate retainNetworkIndicator];
}

- (void)afterOperation{
	[UIAppDelegate releaseNetworkIndicator];
}

- (NSError *)processData:(NSData *)content{
	return nil;
}

- (void)forwardError:(NSError *)error {
    [UIAppDelegate releaseNetworkIndicator];
}

#pragma mark -
#pragma mark core data
- (NSManagedObjectContext *)insertionContext 
{
    if (insertionContext == nil) {
        insertionContext = [[NSManagedObjectContext alloc] init];
        [insertionContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
		[insertionContext setUndoManager:nil];
		[insertionContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
    }
    return insertionContext;
}

- (NSEntityDescription *)aMangaEntityDescription 
{
    if (aMangaEntityDescription == nil) {
        aMangaEntityDescription = [[NSEntityDescription entityForName:@"MoManga" inManagedObjectContext:self.insertionContext] retain];
    }
    return aMangaEntityDescription;
}

#pragma mark -
#pragma mark cancel Operation
- (void) cancelOperation{
	if (importingData) {
		[importingData release];
		importingData = nil;
	}
	self.done = YES;		
}

#pragma mark -
#pragma mark main

- (void)main{
	@autoreleasepool {
        [self beforeOperation];
        
        self.done = NO;
        
        self.url = [NSURL URLWithString:[self stringForURL]];
        DLog(@"retrieve url = %@",[self stringForURL]);
        
        if ([UIAppDelegate backgroundSupported]) {
            bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
                [[UIApplication sharedApplication] endBackgroundTask:bgTask];
                bgTask = UIBackgroundTaskInvalid;
            }];
        }

        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.url];
        [request setValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
        dataConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        if (dataConnection != nil) {
            importingData = [[NSMutableData data] retain];
            do {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            } while (!done);
            
            if (importingData != nil) {
                [importingData release];	
            }	
        }
		
        NSError *saveError = nil;
        [insertionContext save:&saveError];
        
        [self afterOperation];
    }
}

#pragma mark -
#pragma mark NSURLConnection Delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	DLog(@"-");
	if (self.isCancelled) {
		[self cancelOperation];
		return;
	}
    // this method is called when the server has determined that it
    // has enough information to create the NSURLResponse
    // it can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    // receivedData is declared as a method instance elsewhere
	DLog(@"expected size = %lli", [response expectedContentLength]);
	
	//NSHTTPURLResponse *hr = (NSHTTPURLResponse*)response;
	//NSDictionary *dict = [hr allHeaderFields];          
	//NSLog(@"HEADERS : %@",[dict description]);
	
    [self.importingData setLength:0];	
}

// Forward errors to the delegate.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self performSelectorOnMainThread:@selector(forwardError:) withObject:error waitUntilDone:NO];
	
	if (self.isCancelled) {
		[self cancelOperation];
		return;
	}
	
    if (importingData) {
		[importingData release];
		importingData = nil;
	}
	
    // Set the condition which ends the run loop.
    done = YES;
	
	if ([UIAppDelegate backgroundSupported]) {
		if (bgTask != UIBackgroundTaskInvalid) {
			[[UIApplication sharedApplication] endBackgroundTask:bgTask];
			bgTask = UIBackgroundTaskInvalid;
		}
	}
}

// Called when a chunk of data has been downloaded.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	if (self.isCancelled) {
		[self cancelOperation];
		return;
	}
    NSLog(@"download didreceiveData");
	[self.importingData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	DLog(@"-");
	if (self.isCancelled) {
		[self cancelOperation];		
	} else {
		if (self.importingData == nil) {
			[self performSelectorOnMainThread:@selector(forwardError:) withObject:nil waitUntilDone:NO];		
			[self cancelOperation];		
		} else {
			
			if (!self.isCancelled) {
				NSError *error = [self processData:self.importingData];
				if (error != nil) {
					[self performSelectorOnMainThread:@selector(forwardError:) withObject:nil waitUntilDone:NO];		
					[self cancelOperation];
				}
			}						
			
		}	
	}
	
	if ([UIAppDelegate backgroundSupported]) {
		if (bgTask != UIBackgroundTaskInvalid) {
			[[UIApplication sharedApplication] endBackgroundTask:bgTask];
			bgTask = UIBackgroundTaskInvalid;
		}
	}
	
	self.done = YES;
	
}

@end
