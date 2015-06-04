//
//  LCSCTLabelWithShadow.m
//  LCSCocoaTouchKit
//
//  Created by Christoph Lauterbach on 24.06.14.
//  Copyright (c) 2014 Christoph Lauterbach. All rights reserved.
//

#import "LCSCTLabelWithShadow.h"

@implementation LCSCTLabelWithShadow

- (void)setShadowColor:(UIColor *)shadowColor
{
    self.layer.shadowColor = shadowColor.CGColor;
}
- (UIColor*)shadowColor
{
    return [UIColor colorWithCGColor:self.layer.shadowColor];
}

- (void)setShadowOpacity:(CGFloat)shadowOpacity
{
    self.layer.shadowOpacity = shadowOpacity;
}
- (CGFloat)shadowOpacity
{
    return self.layer.shadowOpacity;
}

- (void)setShadowRadius:(CGFloat)shadowRadius
{
    self.layer.shadowRadius = shadowRadius;
}
- (CGFloat)shadowRadius
{
    return self.layer.shadowRadius;
}

- (void)setShadowOffset:(CGSize)shadowOffset
{
    self.layer.shadowOffset = shadowOffset;
}
- (CGSize)shadowOffset
{
    return self.layer.shadowOffset;
}

@end
