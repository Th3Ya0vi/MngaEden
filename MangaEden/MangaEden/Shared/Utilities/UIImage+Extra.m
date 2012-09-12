//
//  UIImage+Extra.m
//  mr_hd
//
//  Created by Luong Thanh Khanh on 10/11/10.
//  Copyright 2010 Not A Basement Studio. All rights reserved.
//

#import "UIImage+Extra.h"


@implementation UIImage (Extra)

- (UIImage *)addImageReflection:(CGFloat)reflectionFraction {
	int reflectionHeight = self.size.height * reflectionFraction;
	
	// create a 2 bit CGImage containing a gradient that will be used for masking the 
	// main view content to create the 'fade' of the reflection.  The CGImageCreateWithMask
	// function will stretch the bitmap image as required, so we can create a 1 pixel wide gradient
	CGImageRef gradientMaskImage = NULL;
	
	// gradient is always black-white and the mask must be in the gray colorspace
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
	
	// create the bitmap context
	CGContextRef gradientBitmapContext = CGBitmapContextCreate(nil, 1, reflectionHeight,
															   8, 0, colorSpace, kCGImageAlphaNone);
	
	// define the start and end grayscale values (with the alpha, even though
	// our bitmap context doesn't support alpha the gradient requires it)
	CGFloat colors[] = {0.0, 1.0, 1.0, 1.0};
	
	// create the CGGradient and then release the gray color space
	CGGradientRef grayScaleGradient = CGGradientCreateWithColorComponents(colorSpace, colors, NULL, 2);
	CGColorSpaceRelease(colorSpace);
	
	// create the start and end points for the gradient vector (straight down)
	CGPoint gradientStartPoint = CGPointMake(0, reflectionHeight);
	CGPoint gradientEndPoint = CGPointZero;
	
	// draw the gradient into the gray bitmap context
	CGContextDrawLinearGradient(gradientBitmapContext, grayScaleGradient, gradientStartPoint,
								gradientEndPoint, kCGGradientDrawsAfterEndLocation);
	CGGradientRelease(grayScaleGradient);
	
	// add a black fill with 50% opacity
	CGContextSetGrayFillColor(gradientBitmapContext, 0.0, 0.5);
	CGContextFillRect(gradientBitmapContext, CGRectMake(0, 0, 1, reflectionHeight));
	
	// convert the context into a CGImageRef and release the context
	gradientMaskImage = CGBitmapContextCreateImage(gradientBitmapContext);
	CGContextRelease(gradientBitmapContext);
	
	// create an image by masking the bitmap of the mainView content with the gradient view
	// then release the  pre-masked content bitmap and the gradient bitmap
	CGImageRef reflectionImage = CGImageCreateWithMask(self.CGImage, gradientMaskImage);
	CGImageRelease(gradientMaskImage);
	
	CGSize size = CGSizeMake(self.size.width, self.size.height + reflectionHeight);
	
	UIGraphicsBeginImageContext(size);
	
	[self drawAtPoint:CGPointZero];
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextDrawImage(context, CGRectMake(0, self.size.height, self.size.width, reflectionHeight), reflectionImage);
	
	UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	CGImageRelease(reflectionImage);
	
	return result;
}

- (UIImage*)scaleToSize:(CGSize)size {
	UIGraphicsBeginImageContext(size);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(context, 0.0, size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	
	CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, size.width, size.height), self.CGImage);
	
	UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return scaledImage;
}

- (UIImage *)cropImageToRect:(CGRect)cropRect {
	// Begin the drawing (again)
	UIGraphicsBeginImageContext(cropRect.size);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	// Tanslate and scale upside-down to compensate for Quartz's inverted coordinate system
	CGContextTranslateCTM(ctx, 0.0, cropRect.size.height);
	CGContextScaleCTM(ctx, 1.0, -1.0);
	
	// Draw view into context
	CGRect drawRect = CGRectMake(-cropRect.origin.x, cropRect.origin.y - (self.size.height - cropRect.size.height) , self.size.width, self.size.height);
	CGContextDrawImage(ctx, drawRect, self.CGImage);
	
	// Create the new UIImage from the context
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	
	// End the drawing
	UIGraphicsEndImageContext();
	
	return newImage;
}

- (CGSize)calculateNewSizeForCroppingBox:(CGSize)croppingBox {
	// Make the shortest side be equivalent to the cropping box.
	CGFloat newHeight, newWidth;
	if (self.size.width < self.size.height) {
		newWidth = croppingBox.width;
		newHeight = (self.size.height / self.size.width) * croppingBox.width;
	} else {
		newHeight = croppingBox.height;
		newWidth = (self.size.width / self.size.height) *croppingBox.height;
	}
	
	return CGSizeMake(newWidth, newHeight);
}

- (UIImage *)cropCenterAndScaleImageToSize:(CGSize)cropSize {
	UIImage *scaledImage = [self scaleToSize:[self calculateNewSizeForCroppingBox:cropSize]];
	return [scaledImage cropImageToRect:CGRectMake((scaledImage.size.width-cropSize.width)/2, (scaledImage.size.height-cropSize.height)/2, cropSize.width, cropSize.height)];
}

- (UIImage*)resizedImageInRect:(CGRect)thumbRect {
	// Creates a bitmap-based graphics context and makes it the current context.
	UIGraphicsBeginImageContext(thumbRect.size);
	[self drawInRect:thumbRect];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsPopContext();	
	return newImage;
}

- (CGRect)croppedBox {
	// First get the image into your data buffer
	CGImageRef imageRef = self.CGImage;
	NSUInteger width = CGImageGetWidth(imageRef);
	NSUInteger height = CGImageGetHeight(imageRef);
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	unsigned char *rawData = malloc(height * width * 4);
	NSUInteger bytesPerPixel = 4;
	NSUInteger bytesPerRow = bytesPerPixel * width;
	NSUInteger bitsPerComponent = 8;
	CGContextRef context = CGBitmapContextCreate(rawData, width, height,
												 bitsPerComponent, bytesPerRow, colorSpace,
												 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
	CGColorSpaceRelease(colorSpace);
	
	CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
	CGContextRelease(context);
	
	int minX = 0;
	for (int x=0; x<width; x++) {
		BOOL fullLine = YES;
		int byteIndex = x * bytesPerPixel;
		for (int y=0; y<height; y++) {
			if ((rawData[byteIndex] < 210) || (rawData[byteIndex + 1] < 210) || (rawData[byteIndex + 2] < 210)) {
				fullLine = NO;
				break;
			}
			byteIndex += bytesPerRow;
		}
		if (!fullLine) {
			minX = x;
			break;
		}
	}
	
	int maxX = width-1;
	for (int x=width-1; x>=0; x--) {
		BOOL fullLine = YES;
		int byteIndex = x * bytesPerPixel;
		for (int y=0; y<height; y++) {
			if ((rawData[byteIndex] < 210) || (rawData[byteIndex + 1] < 210) || (rawData[byteIndex + 2] < 210)) {
				fullLine = NO;
				break;
			}
			byteIndex += bytesPerRow;
		}
		if (!fullLine) {
			maxX = x;
			break;
		}
	}
	
	int minY = 0;
	for (int y=0; y<height; y++) {
		BOOL fullLine = YES;
		int byteIndex = bytesPerRow * y;
		for (int x=0; x<width; x++) {
			if ((rawData[byteIndex] < 210) || (rawData[byteIndex + 1] < 210) || (rawData[byteIndex + 2] < 210)) {
				fullLine = NO;
				break;
			}
			byteIndex += bytesPerPixel;
		}
		if (!fullLine) {
			minY = y;
			break;
		}
	}
	
	int maxY = height-1;
	for (int y=height-1; y>=0; y--) {
		BOOL fullLine = YES;
		int byteIndex = bytesPerRow * y;
		for (int x=0; x<width; x++) {
			if ((rawData[byteIndex] < 210) || (rawData[byteIndex + 1] < 210) || (rawData[byteIndex + 2] < 210)) {
				fullLine = NO;
				break;
			}
			byteIndex += bytesPerPixel;
		}
		if (!fullLine) {
			maxY = y;
			break;
		}
	}
	
	DLog(@"%d %d %d %d", minX, minY, maxX, maxY);
	
	free(rawData);
	
	return CGRectMake(minX, minY, maxX - minX + 1, maxY - minY + 1);
}

@end