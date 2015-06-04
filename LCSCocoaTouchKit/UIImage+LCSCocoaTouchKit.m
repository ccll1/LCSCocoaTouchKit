//
//  UIImage+LCSCocoaTouchKit.m
//  LCSCocoaTouchKit
//
//  Created by Christoph Lauterbach on 11.12.14.
//  Copyright (c) 2014 Christoph Lauterbach. All rights reserved.
//

#import "UIImage+LCSCocoaTouchKit.h"

@implementation UIImage (LCSCocoaTouchKit)

- (UIImage*)resizeTo:(CGSize)newSize
{
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return newImage;
}

@end
