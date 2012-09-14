//
//  ImageDownloaderOperation.h
//  quickmanga
//
//  Created by Luong Thanh Khanh on 6/19/10.
//  Copyright 2010 Not A Basement Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol ImageDownloaderDelegate <NSObject>

@optional

- (void) imageDownloaderDidFinishDownloadingImage:(UIImage *)image;

- (void) imageDownloaderDidFailDownloadingWithError:(NSError *)error;

- (void) imageDownloaderDidStopDownloading;
@end

@interface ImageDownloaderOperation : NSOperation 
{
		
	NSString *imageUrl;
	NSString *pathToSave;
	UIImage *image;
}
@property (nonatomic, retain) NSString *pathToSave;
@property (nonatomic, retain) NSString *imageUrl;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSURLConnection *imageConnection;
@property (nonatomic) bool done;

@property (nonatomic, assign) id <ImageDownloaderDelegate> delegate;

-(id) initWithNSStringURL:(NSString *)url;

-(void) startDownload;
-(void) stopDownload;
@end
