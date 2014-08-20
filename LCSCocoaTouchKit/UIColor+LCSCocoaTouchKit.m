//
//  UIColor+LCSCocoaTouchKit.m
//  LCSCocoaTouchKit
//
//  Created by Christoph Lauterbach on 16.10.13.
//  Copyright (c) 2013 Christoph Lauterbach. All rights reserved.
//

#import "UIColor+LCSCocoaTouchKit.h"

@interface UIColor (LCSCocoaTouchKitPrivate)

+ (BOOL)convertHexadecimalString:(NSString*)hexString toRed:(CGFloat*)red green:(CGFloat*)green blue:(CGFloat*)blue;

+ (BOOL)convertCssRgbString:(NSString*)cssString
                      toRed:(CGFloat*)red
                      green:(CGFloat*)green
                       blue:(CGFloat*)blue
                      alpha:(CGFloat*)alpha;
+ (BOOL)convertCssHslString:(NSString*)cssString
                      toHue:(CGFloat*)hue
                 saturation:(CGFloat*)saturation
                 brightness:(CGFloat*)brightness
                      alpha:(CGFloat*)alpha;

@property (nonatomic,readonly) NSString *genericHexadecimalValue;

@end

@implementation UIColor (LCSCocoaTouchKit)

- (NSString *)hexadecimalValue {
    return [self genericHexadecimalValue];
}

- (NSString*)genericHexadecimalValue
{
    CGFloat redFloatValue;
    CGFloat greenFloatValue;
    CGFloat blueFloatValue;
    int redIntValue;
    int greenIntValue;
    int blueIntValue;
    
    [self getRed:&redFloatValue green:&greenFloatValue blue:&blueFloatValue alpha:NULL];
    
    redIntValue = redFloatValue * 0xFF;
    greenIntValue = greenFloatValue * 0xFF;
    blueIntValue = blueFloatValue * 0xFF;
    
    return [NSString stringWithFormat:@"#%02x%02x%02x", redIntValue, greenIntValue, blueIntValue];
}

+ (UIColor *)colorFromHexadecimalValue:(NSString *)hex
{
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    
    if ([UIColor convertHexadecimalString:hex toRed:&red green:&green blue:&blue]) {
        return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    }
    else {
        return nil;
    }
}

+ (BOOL)convertHexadecimalString:(NSString*)hexString toRed:(CGFloat*)red green:(CGFloat*)green blue:(CGFloat*)blue
{
    if (![hexString hasPrefix:@"#"]) {
        NSAssert(false, @"Passed hex string must be prefixed with a dash (#).");
        return NO;
    }
    
    hexString = [hexString substringWithRange:NSMakeRange(1, hexString.length - 1)];
    
    if (hexString.length != 6 && hexString.length != 3) {
        NSAssert(false, @"Passed hex string must be 3 or 6 hex digits with a prefixed dash.");
        return NO;
    }
    
    unsigned int colorCode = 0;
    
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    BOOL didScan = [scanner scanHexInt:&colorCode];
    
    NSAssert(didScan, @"Couldn't scan from hex string.");
    
    if (!didScan) {
        return NO;
    }
    
    if (hexString.length == 3) {
        *red = ((colorCode >>   8) & 0xF) / 15.0;
        *green = ((colorCode >> 4) & 0xF) / 15.0;
        *blue = ((colorCode >>  0) & 0xF) / 15.0;
    }
    else {
        *red = ((colorCode >>  16) & 0xFF) / 255.0;
        *green = ((colorCode >> 8) & 0xFF) / 255.0;
        *blue = ((colorCode >>  0) & 0xFF) / 255.0;
    }
    
    return YES;
}

+ (UIColor *)colorFromCSSValue:(NSString *)cssValue
{
    UIColor *color;
    
    if ([cssValue hasPrefix:@"#"]) {
        color = [UIColor colorFromHexadecimalValue:cssValue];
    }
    else if ([cssValue hasPrefix:@"rgb"]) {
        CGFloat red;
        CGFloat green;
        CGFloat blue;
        CGFloat alpha;
        
        BOOL didConvert = [UIColor convertCssRgbString:cssValue toRed:&red green:&green blue:&blue alpha:&alpha];
        
        if (didConvert) {
            color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
        }
    }
    else if ([cssValue hasPrefix:@"hsl"]) {
        CGFloat hue;
        CGFloat saturation;
        CGFloat brightness;
        CGFloat alpha;
        
        BOOL didConvert = [UIColor convertCssHslString:cssValue toHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
        
        if (didConvert) {
            color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
        }
    }
    
    return color;
}

+ (BOOL)convertCssRgbString:(NSString*)cssString
                      toRed:(CGFloat*)redOut
                      green:(CGFloat*)greenOut
                       blue:(CGFloat*)blueOut
                      alpha:(CGFloat*)alphaOut;
{
    cssString = cssString.lowercaseString;
    NSScanner *scanner = [NSScanner scannerWithString:cssString];
    
    BOOL didScan;
    NSString *lastToken;
    [scanner scanUpToString:@"(" intoString:&lastToken];
    
    BOOL hasAlpha;
    
    if ([lastToken isEqualToString:@"rgb"]) {
        hasAlpha = NO;
    }
    else if ([lastToken isEqualToString:@"rgba"]) {
        hasAlpha = YES;
    }
    else {
        return NO;
    }
    
    if (![scanner scanString:@"(" intoString:nil]) {
        return NO;
    }
    
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    
    if (![scanner scanDouble:&red]) {
        return NO;
    }
    
    BOOL hasPercentageValues = [scanner scanString:@"%" intoString:nil];
    
    [scanner scanString:@"," intoString:nil];
    
    if (![scanner scanDouble:&green]) {
        return NO;
    }
    
    if (hasPercentageValues && ![scanner scanString:@"%" intoString:nil]) {
        return NO;
    }
    
    [scanner scanString:@"," intoString:nil];
    
    if (![scanner scanDouble:&blue]) {
        return NO;
    }
    
    if (hasPercentageValues && ![scanner scanString:@"%" intoString:nil]) {
        return NO;
    }
    
    if (hasAlpha) {
        [scanner scanString:@"," intoString:nil];
        
        if (![scanner scanDouble:&alpha]) {
            return NO;
        }
        
        if (hasPercentageValues && ![scanner scanString:@"%" intoString:nil]) {
            return NO;
        }
    }
    else {
        alpha = hasPercentageValues ? 100.0 : 255.0;
    }
    
    didScan = [scanner scanString:@")" intoString:nil];
    
    if (!didScan) {
        return NO;
    }
    
    CGFloat factor = hasPercentageValues ? 100.0 : 255.0;
    red /= factor;
    green /= factor;
    blue /= factor;
    alpha /= factor;
    
    *redOut   = red;
    *greenOut = green;
    *blueOut  = blue;
    *alphaOut = alpha;
    
    return YES;
}

+ (BOOL)convertCssHslString:(NSString*)cssString
                      toHue:(CGFloat*)hueOut
                 saturation:(CGFloat*)saturationOut
                 brightness:(CGFloat*)brightnessOut
                      alpha:(CGFloat*)alphaOut
{
    cssString = cssString.lowercaseString;
    NSScanner *scanner = [NSScanner scannerWithString:cssString];
    
    BOOL didScan;
    NSString *lastToken;
    
    [scanner scanUpToString:@"(" intoString:&lastToken];
    
    BOOL hasAlpha;
    
    if ([lastToken isEqualToString:@"hsl"]) {
        hasAlpha = NO;
    }
    else if ([lastToken isEqualToString:@"hsla"]) {
        hasAlpha = YES;
    }
    else {
        return NO;
    }
    
    if (![scanner scanString:@"(" intoString:nil]) {
        return NO;
    }
    
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
    CGFloat alpha;
    
    if (![scanner scanDouble:&hue]) {
        return NO;
    }
    
    [scanner scanString:@"," intoString:nil];
    
    if (![scanner scanDouble:&saturation]) {
        return NO;
    }
    
    BOOL hasPercentageValues = [scanner scanString:@"%" intoString:nil];
    
    [scanner scanString:@"," intoString:nil];
    
    if (![scanner scanDouble:&brightness]) {
        return NO;
    }
    
    if (hasPercentageValues && ![scanner scanString:@"%" intoString:nil]) {
        return NO;
    }
    
    if (hasAlpha) {
        [scanner scanString:@"," intoString:nil];
        
        if (![scanner scanDouble:&alpha]) {
            return NO;
        }
        
        if ([scanner scanString:@"%" intoString:nil]) {
            alpha /= 100.0;
        }
    }
    else {
        alpha = 1.0;
    }
    
    didScan = [scanner scanString:@")" intoString:nil];
    
    if (!didScan) {
        return NO;
    }
    
    hue /= 360.0;
    CGFloat factor = hasPercentageValues ? 100.0 : 255.0;
    saturation /= factor;
    brightness /= factor;
    
    *hueOut   = hue;
    *saturationOut = saturation;
    *brightnessOut  = brightness;
    *alphaOut = alpha;
    
    return YES;
}

+ (UIColor*)colorWithRandomHueButSaturation:(CGFloat)saturation brightness:(CGFloat)brightness
{
    CGFloat hue = (CGFloat)arc4random_uniform(255) / 255.0;
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1.0];
}

- (UIColor *)colorWithBrightness:(CGFloat)brightness
{
    CGFloat hue;
    CGFloat saturation;
    CGFloat alpha;
    [self getHue:&hue saturation:&saturation brightness:NULL alpha:&alpha];
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
}

@end
