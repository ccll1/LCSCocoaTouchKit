//
//  UIBezierPath+ConenvienceAdditions.h
//  Minimal Sudoku
//
//  Created by Christoph Lauterbach on 12.02.14.
//  Copyright (c) 2014 Christoph Lauterbach. All rights reserved.
//

@interface UIBezierPath (ConenvienceAdditions)

+ (UIBezierPath*)histogramPathFromBinHeights:(CGFloat*)binHeights binCount:(NSUInteger)binCount closed:(BOOL)closed;
+ (UIBezierPath*)pathWithPoints:(NSArray*)points closed:(BOOL)closed;

//- (UIBezierPath*)dotsOnPointsWithDiameter:(CGFloat)diameter;
- (UIBezierPath*)pathWithStraightSegements;
- (void)controlPointsPathCp1:(UIBezierPath **)controlPoints1Path cp2:(UIBezierPath **)controlPoints2Path;

- (UIBezierPath*)approximatePathWithMaxLineLength:(CGFloat)maxLineLength;

- (NSArray*)allPoints;

- (CGFloat)assumeHistogramPathFindHeightAtX:(CGFloat)x maxLineLength:(CGFloat)maxLineLength;

CGFloat interpolateYForXBetweenPoints(CGPoint p0, CGPoint p1, CGFloat x);

@end
