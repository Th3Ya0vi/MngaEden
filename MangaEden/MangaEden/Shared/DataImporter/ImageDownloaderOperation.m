//
//  ImageDownloaderOperation.m
//  quickmanga
//
//  Created by Luong Thanh Khanh on 6/19/10.
//  Copyright 2010 Not A Basement Studio. All rights reserved.
//

#import "ImageDownloaderOperation.h"

@interface ImageDownloaderOperation()

@property (nonatomic, retain) NSMutableData *imageRequestData;
@end


@implementation ImageDownloaderOperation
@synthesize imageRequestData,imageUrl,image,imageConnection,done,delegate,pathToSave;

#pragma mark dealloc


#pragma mark init
-(id) initWithNSStringURL:(NSString *)url
{
	self = [super init];
	if (self) {
		self.imageUrl = url;
		self.done = YES;
	}	
	return self;
}

#pragma mark main

- (void)main {
    @autoreleasepool {
        [self startDownload];
    }

	
}
#pragma mark startDownload
-(void) startDownload
{	
	DLog(@"url = %@",self.imageUrl);
	NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.imageUrl] 
												  cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60.0];
	
	imageConnection = [[NSURLConnection alloc] initWithRequest:imageRequest delegate:self];
	[UIAppDelegate retainNetworkIndicator];
	if (self.imageConnection) {
		self.done = NO;
		imageRequestData = [NSMutableData data];
		do {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        } while (!self.done);
	}
	
	[UIAppDelegate releaseNetworkIndicator];
}

#pragma mark stopDownload
-(void) stopDownload{
	self.done = YES;
	[UIAppDelegate releaseNetworkIndicator];
	[imageConnection cancel];
	imageConnection = nil;
	
	if (imageRequestData) {
		imageRequestData = nil;
	}
	imageRequestData = nil;
	self.done = YES;
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(imageDownloaderDidStopDownloading)]) {
		[self.delegate imageDownloaderDidStopDownloading];
	}
}

#pragma mark NSURLConnection delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	DLog(@"-");
	if (self.isCancelled) {
		if (imageRequestData) {
			imageRequestData = nil;
		}
		self.done = YES;
		return;
	}
    // this method is called when the server has determined that it
    // has enough information to create the NSURLResponse
    // it can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    // receivedData is declared as a method instance elsewhere
    [self.imageRequestData setLength:0];
	
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // append the new data to the receivedData
    // receivedData is declared as a method instance elsewhere
	if (self.isCancelled) {
		if (imageRequestData) {
			imageRequestData = nil;
		}
		self.done = YES;
		return;
	}
    [self.imageRequestData appendData:data];	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{ 
	if (self.isCancelled) {
		if (imageRequestData) {
			imageRequestData = nil;
		}
		self.done = YES;
		return;
	}
	
    // release the data object
    if (imageRequestData) {
		imageRequestData = nil;
	}
	
    // inform the user
    //DLog(@"Connection failed! Error - %@ %@", [error localizedDescription], [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
	self.done = YES;
	if (delegate && [delegate respondsToSelector:@selector(imageDownloaderDidFailDownloadingWithError:)]) {
		[delegate imageDownloaderDidFailDownloadingWithError:error];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{		
	if (self.isCancelled) {
		if (imageRequestData) {
			imageRequestData = nil;
		}
		self.done = YES;
		return;
	}
	
	if(!self.done)
	{
		
		if (self.isCancelled) {
			self.done = YES;
			return;
		}
		// Create the image with the downloaded data
		UIImage* downloadedImage = [[UIImage alloc] initWithData:self.imageRequestData];
		
		
		if (self.isCancelled) {
			self.done = YES;
            downloadedImage = nil;
			return;
		}		
		
		if (self.delegate && [self.delegate respondsToSelector:@selector(imageDownloaderDidFinishDownloadingImage:)])
		{	
			[self.delegate imageDownloaderDidFinishDownloadingImage:downloadedImage];
		}
		
		//save to file
		if (self.pathToSave) {
			if (downloadedImage != nil) {
				NSData *imgData = UIImageJPEGRepresentation(downloadedImage,1);		
				NSLog(@"data size = %d", [imgData length]);
				NSLog(@"path = %@",self.pathToSave);
				[imgData writeToFile:self.pathToSave atomically:YES];
			}			
		}		
		
        downloadedImage = nil;
        if (imageRequestData) {
			imageRequestData = nil;
		}
		
		done = YES;
	}	
}

@end
