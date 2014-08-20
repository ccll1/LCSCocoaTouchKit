//
//  UIView+LCSCocoaTouchKit.h
//  LCSCocoaTouchKit
//
//  Created by Christoph Lauterbach on 12.12.13.
//  Copyright (c) 2013 Christoph Lauterbach. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LCSCocoaTouchKit)

- (UIImage*)blurredImageWithTintColor:(UIColor*)tintColor blurRadius:(CGFloat)blurRadius;

@end
