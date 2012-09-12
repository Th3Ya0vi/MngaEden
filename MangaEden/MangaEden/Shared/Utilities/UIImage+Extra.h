//
//  UIImage+Extra.h
//  mr_hd
//
//  Created by Luong Thanh Khanh on 10/11/10.
//  Copyright 2010 Not A Basement Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extra)

- (UIImage *)addImageReflection:(CGFloat)reflectionFraction;

- (UIImage*)scaleToSize:(CGSize)size;
- (UIImage *)cropImageToRect:(CGRect)cropRect;
- (CGSize)calculateNewSizeForCroppingBox:(CGSize)croppingBox;
- (UIImage *)cropCenterAndScaleImageToSize:(CGSize)cropSize;
- (UIImage*) resizedImageInRect:(CGRect)thumbRect;
- (CGRect)croppedBox;
@end