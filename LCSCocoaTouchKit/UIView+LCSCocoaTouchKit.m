//
//  UIView+BlurredImage.m
//  Minimal Sudoku
//
//  Created by Christoph Lauterbach on 12.12.13.
//  Copyright (c) 2013 Christoph Lauterbach. All rights reserved.
//

#import "UIView+BlurredImage.h"
#import "UIImage+ImageEffects.h"

#import "BNRTimeBlock.h"

#import "LcAppDelegate+Appearance.h"

#import "LcAppDelegate+BundleAndDeviceInfo.h"

@implementation UIView (BlurredImage)

- (UIImage*)blurredImage
{
    if ([self window] == nil) {
        return nil;
    }
    
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, [[[self window] screen] scale]);
    [self drawViewHierarchyInRect:self.frame afterScreenUpdates:NO];
    UIImage *newBGImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIColor *tintColor;
    
    if ([LcAppDelegate sharedAppDelegate].interfaceColorMode == LcInterfaceColorModeLight) {
        tintColor = [UIColor colorWithWhite:0.97 alpha:0.82];
    }
    else {
        tintColor = [UIColor colorWithWhite:0.03 alpha:0.50];
    }
    
    NSString *deviceTypeString = [LcAppDelegate sharedAppDelegate].deviceTypeString;
    
    CGFloat blurRadius;
    if ([@[@"iPhone3,1", @"iPad3,1"] containsObject:deviceTypeString]) {
        blurRadius = 0.0;
    }
    else {
        blurRadius = 5.0;
    }
    
    newBGImage = [newBGImage applyBlurWithRadius:blurRadius tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
    
    return newBGImage;
}

@end
