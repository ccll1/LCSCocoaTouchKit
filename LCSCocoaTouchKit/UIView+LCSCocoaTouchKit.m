//
//  UIView+LCSCocoaTouchKit.m
//  LCSCocoaTouchKit
//
//  Created by Christoph Lauterbach on 12.12.13.
//  Copyright (c) 2013 Christoph Lauterbach. All rights reserved.
//

#import "UIView+LCSCocoaTouchKit.h"
#import "UIImage+ImageEffects.h"

@implementation UIView (LCSCocoaTouchKit)

- (UIImage*)blurredImageWithTintColor:(UIColor*)tintColor blurRadius:(CGFloat)blurRadius
{
    if (self.window == nil) {
        return nil;
    }
    
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, [[[self window] screen] scale]);
    [self drawViewHierarchyInRect:self.frame afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    image = [image applyBlurWithRadius:blurRadius tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
    
    return image;
}

@end
