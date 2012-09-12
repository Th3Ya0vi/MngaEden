//
//  NSString+HTML.h
//  mr_mf
//
//  Created by Luong Thanh Khanh on 8/16/10.
//  Copyright 2010 Not A Basement Studio. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSString (HTML)

- (NSString *)stringByDecodingXMLEntities;

@end