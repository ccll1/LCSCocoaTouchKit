//
//  UIButton+LCSCocoaTouchKit.m
//  LCSCocoaTouchKit
//
//  Created by Christoph Lauterbach on 12.03.14.
//  Copyright (c) 2014 Christoph Lauterbach. All rights reserved.
//

#import "UIButton+LCSCocoaTouchKit.h"

@implementation UIButton (LCSCocoaTouchKit)

- (void)useTintedImage
{
    UIImage *image;
    
    image = [[self imageForState:UIControlStateNormal] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self setImage:image forState:UIControlStateNormal];
    image = [[self imageForState:UIControlStateSelected] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self setImage:image forState:UIControlStateSelected];
    image = [[self imageForState:UIControlStateHighlighted] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self setImage:image forState:UIControlStateHighlighted];
}

@end
