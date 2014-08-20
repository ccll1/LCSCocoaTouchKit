//
//  UIBezierPath+ConenvienceAdditions.h
//  LCSCocoaTouchKit
//
//  Created by Christoph Lauterbach on 12.02.14.
//  Copyright (c) 2014 Christoph Lauterbach. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (LCSCocoaTouchKit)

+ (UIBezierPath*)pathWithPoints:(NSArray*)points closed:(BOOL)closed;

- (UIBezierPath*)pathWithStraightSegements;
- (void)controlPointsPathCp1:(UIBezierPath **)controlPoints1Path cp2:(UIBezierPath **)controlPoints2Path;

- (UIBezierPath*)approximatePathWithMaxLineLength:(CGFloat)maxLineLength;

@property (nonatomic,readonly) NSArray *allPoints;

/**
 *  Tests two paths for equality. The paths are only equal if they have equal element count and equal elements. Other path properties, like line width, winding rule and so on are not tested.
 *
 *  @param anObject Another instance of UIBezierPath
 *
 *  @return YES if the two objects have equal path elements, NO otherwise.
 */
- (BOOL)isEqual:(id)anObject;


@end
