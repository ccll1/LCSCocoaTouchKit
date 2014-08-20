//
//  UIColor+Mixing.m
//  Minimal Sudoku
//
//  Created by Christoph Lauterbach on 16.10.13.
//  Copyright (c) 2013 Christoph Lauterbach. All rights reserved.
//

@implementation UIColor (Mixing)

- (UIColor *)colorWithBrightness:(CGFloat)brightness
{
    CGFloat hue;
    CGFloat saturation;
    CGFloat alpha;
    [self getHue:&hue saturation:&saturation brightness:NULL alpha:&alpha];
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
}

@end
