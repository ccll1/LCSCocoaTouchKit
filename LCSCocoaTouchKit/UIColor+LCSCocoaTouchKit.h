//
//  UIColor+LCSCocoaTouchKit.h
//  LCSCocoaTouchKit
//
//  Created by Christoph Lauterbach on 16.10.13.
//  Copyright (c) 2013 Christoph Lauterbach. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (LCSCocoaTouchKit)

+ (UIColor*)colorWithRandomHueButSaturation:(CGFloat)saturation brightness:(CGFloat)brightness;

- (UIColor *)colorWithBrightness:(CGFloat)brightness;

/**
 *  Creates and returns an instance of <code>UIColor</code> created by parsing the given color encoded as a web-standard hexadecimal string, using the device RGB color space. The alpha value of the color is set to <code>1.0</code>, i. e. fully opaque.
 *
 *  @param hex A string in the format <code>#00ff00</code> or <code>#0f0</code>.
 *
 *  @return A new instance of <code>UIColor</code> in the device RGB color space if the passed string is a valid web-standard hexadecimal color or nil if it is not valid.
 */
+ (UIColor *)colorFromHexadecimalValue:(NSString *)hex;

/**
 *  Creates and returns an instance of <code>UIColor</code> created by parsing the given color encoded as a CSS color string, using the device RGB color space.
 *
 *  Accepted formats for the string are (all of the examples are equal representations of fully opaque green):
 *
 *  - <code>#00ff00</code>
 *  - <code>#0f0</code>
 *  - <code>rgb(0, 255, 0)</code>
 *  - <code>rgba(0, 255, 0, 255)</code>
 *  - <code>rgb(0%, 100%, 0%)</code>
 *  - <code>rgb(0.0%, 100.0%, 0.0%)</code>
 *  - <code>rgba(0%, 100%, 0%, 100%)</code>
 *  - <code>hsl(120, 100%, 100%)</code>
 *  - <code>hsla(120, 100%, 100%, 1.0)</code>
 *  - <code>hsla(120.0, 100.0%, 100.0%, 1.0)</code>
 *  @param cssValue A string in one of the above formats.
 *
 *  @return A new instance of <code>UIColor</code> in the device RGB color space if the passed string is a valid CSS color string or nil if it is not valid.
 */
+ (UIColor *)colorFromCSSValue:(NSString *)cssValue;

/**
 *  Creates and returns a string with the web-standard hexadecimal representation of the receiver in the format <code>#00ff00</code>.
 */
@property (nonatomic,readonly) NSString *hexadecimalValue;

@end
