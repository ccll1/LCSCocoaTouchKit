//
//  UIBezierPath+ConenvienceAdditions.m
//  Minimal Sudoku
//
//  Created by Christoph Lauterbach on 12.02.14.
//  Copyright (c) 2014 Christoph Lauterbach. All rights reserved.
//

#import "UIBezierPath+ConenvienceAdditions.h"

@implementation UIBezierPath (ConenvienceAdditions)

+ (UIBezierPath*)histogramPathFromBinHeights:(CGFloat*)binHeights binCount:(NSUInteger)binCount closed:(BOOL)closed
{
    if (binCount < 3) {
        return nil;
    }
    
    CGFloat x;
    CGFloat y;
    
    CGFloat cp1x;
    CGFloat cp1y;
    CGFloat cp2x;
    CGFloat cp2y;
    
    CGFloat cpLengthFactor = 0.3;
    
    CGFloat *xPoints = malloc(sizeof(CGFloat) * (binCount + 2));
    CGFloat *yPoints = malloc(sizeof(CGFloat) * (binCount + 2));
    CGFloat *cp1xPoints = malloc(sizeof(CGFloat) * (binCount + 2));
    CGFloat *cp1yPoints = malloc(sizeof(CGFloat) * (binCount + 2));
    CGFloat *cp2xPoints = malloc(sizeof(CGFloat) * (binCount + 2));
    CGFloat *cp2yPoints = malloc(sizeof(CGFloat) * (binCount + 2));
    
    xPoints[0] = 0.0;
    yPoints[0] = 0.0;
    
    for (NSUInteger binIdx = 0; binIdx < binCount; binIdx++) {
        x = (CGFloat)binIdx + 0.5;
        y = binHeights[binIdx];
        xPoints[binIdx+1] = x;
        yPoints[binIdx+1] = y;
    }
    
    xPoints[binCount+1] = (CGFloat)(binCount);
    yPoints[binCount+1] = 0.0;
    
    cp1xPoints[1] = xPoints[0];
    cp1yPoints[1] = yPoints[0];
    
    for (NSUInteger binIdx = 1; binIdx < binCount+1; binIdx++) {
        x = xPoints[binIdx];
        y = yPoints[binIdx];
        
        CGFloat yDiff_2 = (yPoints[binIdx+1] - yPoints[binIdx-1]) / 2.0;
        
        if (yPoints[binIdx-1] <= y && yPoints[binIdx+1] >= y) {
            // Rising
            cp1y = y - (yDiff_2 * cpLengthFactor);
            cp2y = y + (yDiff_2 * cpLengthFactor);
        }
        else if (yPoints[binIdx-1] >= y && yPoints[binIdx+1] <= y) {
            // Falling
            cp1y = y + (-yDiff_2 * cpLengthFactor);
            cp2y = y - (-yDiff_2 * cpLengthFactor);
        }
        else {
            cp1y = y;
            cp2y = y;
        }
        
        cp1y = MAX(cp1y, 0.0);
        cp2y = MAX(cp2y, 0.0);
        
        cp1x = x - cpLengthFactor;
        cp2x = x + cpLengthFactor;
        
        cp2xPoints[binIdx] = cp1x;
        cp2yPoints[binIdx] = cp1y;
        
        cp1xPoints[binIdx+1] = cp2x;
        cp1yPoints[binIdx+1] = cp2y;
    }
    
    cp2xPoints[binCount+1] = xPoints[binCount+1];
    cp2yPoints[binCount+1] = yPoints[binCount+1];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(0.0, 0.0)];
    
    x = xPoints[0];
    y = yPoints[0];
    [path addLineToPoint:CGPointMake(x, y)];
    
    for (NSUInteger binIdx = 1; binIdx < binCount+2; binIdx++) {
        x = xPoints[binIdx];
        y = yPoints[binIdx];
        
        cp1x = cp1xPoints[binIdx];
        cp1y = cp1yPoints[binIdx];
        cp2x = cp2xPoints[binIdx];
        cp2y = cp2yPoints[binIdx];
        
        [path addCurveToPoint:CGPointMake(x, y) controlPoint1:CGPointMake(cp1x, cp1y) controlPoint2:CGPointMake(cp2x, cp2y)];
    }
    
    if (closed) {
        [path closePath];
    }
    
    free(xPoints);
    free(yPoints);
    
    free(cp1xPoints);
    free(cp1yPoints);
    free(cp2xPoints);
    free(cp2yPoints);
    
    return path;
}

+ (UIBezierPath*)pathWithPoints:(NSArray*)points closed:(BOOL)closed
{
    UIBezierPath *path = [UIBezierPath new];
    
    CGPoint firstPoint = [points.firstObject CGPointValue];
    [path moveToPoint:firstPoint];
    
    for (NSUInteger i = 1; i < points.count; i++) {
        CGPoint point = [points[i] CGPointValue];
        [path addLineToPoint:point];
    }
    
    if (closed) {
        [path closePath];
    }
    
    return path;
}

- (UIBezierPath*)pathWithStraightSegements
{
    NSArray *points = [self allPoints];
    
    return [UIBezierPath pathWithPoints:points closed:NO];
}

void cgStraightPathApplierFunc (void *info, const CGPathElement *element)
{
    UIBezierPath *path = (__bridge UIBezierPath*)info;
    
    CGPoint *points = element->points;
    CGPathElementType type = element->type;
    
    switch(type) {
        case kCGPathElementMoveToPoint: // contains 1 point
            [path moveToPoint:points[0]];
            break;
            
        case kCGPathElementAddLineToPoint: // contains 1 point
            [path addLineToPoint:points[0]];
            break;
            
        case kCGPathElementAddQuadCurveToPoint: // contains 2 points
            [path addLineToPoint:points[1]];
            break;
            
        case kCGPathElementAddCurveToPoint: // contains 3 points
            [path addLineToPoint:points[2]];
            break;
            
        case kCGPathElementCloseSubpath: // contains no point
            [path closePath];
            break;
    }
}

- (void)controlPointsPathCp1:(UIBezierPath **)controlPoints1Path cp2:(UIBezierPath **)controlPoints2Path
{
    UIBezierPath *cp1s = [UIBezierPath new];
    UIBezierPath *cp2s = [UIBezierPath new];
    
    NSDictionary *infoDict = @{@"cp1s": cp1s, @"cp2s": cp2s};

    CGPathRef pathCG = self.CGPath;
    
    controlPointsPathLastPoint = CGPointZero;
    CGPathApply(pathCG, (__bridge void *)(infoDict), cgControlPointsPathsApplierFunc);
    controlPointsPathLastPoint = CGPointZero;
    
    *controlPoints1Path = cp1s;
    *controlPoints2Path = cp2s;
}

static CGPoint controlPointsPathLastPoint;

void cgControlPointsPathsApplierFunc(void *info, const CGPathElement *element)
{
    NSDictionary *infoDict = (__bridge NSDictionary *)info;
    UIBezierPath *cp1s = infoDict[@"cp1s"];
    UIBezierPath *cp2s = infoDict[@"cp2s"];
    
    CGPoint *points = element->points;
    CGPathElementType type = element->type;
    
    switch(type) {
        case kCGPathElementMoveToPoint: // contains 1 point
        case kCGPathElementAddLineToPoint: // contains 1 point
            controlPointsPathLastPoint = points[0];
            break;
            
        case kCGPathElementAddQuadCurveToPoint: // contains 2 points
            if (CGPointEqualToPoint(controlPointsPathLastPoint, CGPointZero)) {
//                NSLog(@"last point not set!");
            }
            else {
                [cp1s moveToPoint:controlPointsPathLastPoint];
                [cp1s addLineToPoint:points[0]];
                
                [cp2s moveToPoint:points[1]];
                [cp2s addLineToPoint:points[0]];
            }
            
            controlPointsPathLastPoint = points[1];
            break;
            
        case kCGPathElementAddCurveToPoint: // contains 3 points
            if (CGPointEqualToPoint(controlPointsPathLastPoint, CGPointZero)) {
//                NSLog(@"last point not set!");
            }
            else {
                [cp1s moveToPoint:controlPointsPathLastPoint];
                [cp1s addLineToPoint:points[0]];
                
                [cp2s moveToPoint:points[2]];
                [cp2s addLineToPoint:points[1]];
            }

            controlPointsPathLastPoint = points[2];
            break;
            
        case kCGPathElementCloseSubpath: // contains no point
            controlPointsPathLastPoint = CGPointZero;
            break;
    }
}

- (UIBezierPath*)approximatePathWithMaxLineLength:(CGFloat)maxLineLength
{
    UIBezierPath *newPath = [UIBezierPath new];
    
    NSDictionary *infoDict = @{@"path": newPath, @"maxLineLength": @(maxLineLength)};
    
    CGPathRef pathCG = self.CGPath;
    
    approximatePathLastPoint = CGPointZero;
    CGPathApply(pathCG, (__bridge void *)(infoDict), cgApproximatePathApplierFunc);
    approximatePathLastPoint = CGPointZero;
    
    return newPath;
}

static CGPoint approximatePathLastPoint;

void cgApproximatePathApplierFunc(void *info, const CGPathElement *element)
{
    NSDictionary *infoDict = (__bridge NSDictionary *)info;
    UIBezierPath *path = infoDict[@"path"];
    CGFloat maxLineLength = [infoDict[@"maxLineLength"] doubleValue];
    
    CGPoint *elementPoints = element->points;
    CGPathElementType type = element->type;
    
    if (type == kCGPathElementMoveToPoint) {
        [path moveToPoint:elementPoints[0]];
        approximatePathLastPoint = elementPoints[0];
    }
    else if (type == kCGPathElementAddLineToPoint) {
        [path addLineToPoint:elementPoints[0]];
        approximatePathLastPoint = elementPoints[0];
    }
    else if (type == kCGPathElementCloseSubpath) {
        [path closePath];
        approximatePathLastPoint = CGPointZero;
    }
    else {
        CGPoint p0 = approximatePathLastPoint;
        CGPoint cp0;
        CGPoint cp1;
        CGPoint p1;
        
        if (type == kCGPathElementAddQuadCurveToPoint) {
            cp0 = elementPoints[0];
            cp1 = elementPoints[0];
            p1 = elementPoints[1];
        }
        else {
            cp0 = elementPoints[0];
            cp1 = elementPoints[1];
            p1 = elementPoints[2];
        }
        
        NSMutableArray *newPoints = [NSMutableArray new];
        
        approximatePathSegment(p0, cp0, cp1, p1, p0, 0.0, p1, 1.0, maxLineLength, newPoints);
        
        for (NSValue *pointValue in newPoints) {
            CGPoint newPoint = pointValue.CGPointValue;
            [path addLineToPoint:newPoint];
        }
        
        approximatePathLastPoint = p1;
    }
}

void approximatePathSegment(CGPoint p0,
                            CGPoint cp0,
                            CGPoint cp1,
                            CGPoint p1,
                            CGPoint pt0,
                            CGFloat t0,
                            CGPoint pt1,
                            CGFloat t1,
                            CGFloat maxLineLength,
                            NSMutableArray *points)
{
    CGFloat distance = distanceBetweenPoints(pt0, pt1);
    CGFloat t05 = (t0 + t1) / 2.0;
    
    if (distance <= maxLineLength) {
        [points addObject:[NSValue valueWithCGPoint:pt1]];
    }
    else if (t05 > t0 && t05 < t1) {
        CGPoint pt05 = pointOnCurve(p0, cp0, cp1, p1, t05);
        
        approximatePathSegment(p0, cp0, cp1, p1, pt0, t0, pt05, t05, maxLineLength, points);
        approximatePathSegment(p0, cp0, cp1, p1, pt05, t05, pt1, t1, maxLineLength, points);
    }
}

CGPoint pointOnCurve(CGPoint p0, CGPoint cp0, CGPoint cp1, CGPoint p1, CGFloat t)
{
    CGPoint a;
    CGPoint b;
    CGPoint c;
    CGPoint d;
    CGPoint e;
    
    CGPoint p;
    
    a.x = ((1 - t) * p0.x) + (t * cp0.x);
    a.y = ((1 - t) * p0.y) + (t * cp0.y);
    b.x = ((1 - t) * cp0.x) + (t * cp1.x);
    b.y = ((1 - t) * cp0.y) + (t * cp1.y);
    c.x = ((1 - t) * cp1.x) + (t * p1.x);
    c.y = ((1 - t) * cp1.y) + (t * p1.y);
    
    d.x = ((1 - t) * a.x) + (t * b.x);
    d.y = ((1 - t) * a.y) + (t * b.y);
    
    e.x = ((1 - t) * b.x) + (t * c.x);
    e.y = ((1 - t) * b.y) + (t * c.y);
    
    p.x = ((1 - t) * d.x) + (t * e.x);
    p.y = ((1 - t) * d.y) + (t * e.y);
    
    return p;
}

CGFloat distanceBetweenPoints(CGPoint p0, CGPoint p1)
{
    return sqrt(pow(p0.x - p1.x, 2.0) + pow(p0.y - p1.y, 2.0));
}

- (NSArray*)allPoints
{
    NSMutableArray *points = [NSMutableArray new];
    
    CGPathApply(self.CGPath, (__bridge void *)(points), cgAllPointsOnPathApplierFunc);

    return [points copy];
}

void cgAllPointsOnPathApplierFunc(void *info, const CGPathElement *element)
{
    NSMutableArray *points = (__bridge NSMutableArray *)info;

    CGPoint *segmentPoints = element->points;
    CGPathElementType type = element->type;
    
    switch(type) {
        case kCGPathElementMoveToPoint: // contains 1 point
        case kCGPathElementAddLineToPoint: // contains 1 point
            [points addObject:[NSValue valueWithCGPoint:segmentPoints[0]]];
            break;
            
        case kCGPathElementAddQuadCurveToPoint: // contains 2 points
            [points addObject:[NSValue valueWithCGPoint:segmentPoints[1]]];
            break;
            
        case kCGPathElementAddCurveToPoint: // contains 3 points
            [points addObject:[NSValue valueWithCGPoint:segmentPoints[2]]];
            break;
        case kCGPathElementCloseSubpath:
            break;
    }
}

- (CGFloat)assumeHistogramPathFindHeightAtX:(CGFloat)x maxLineLength:(CGFloat)maxLineLength
{
    NSDictionary *infoDict = @{@"x": @(x), @"maxLineLength": @(maxLineLength)};
    
    CGPathRef pathCG = self.CGPath;
    
    findPathHeightAtXLastPoint = CGPointZero;
    findPathHeightAtX_y = FLT_MIN;
    CGPathApply(pathCG, (__bridge void *)(infoDict), cgFindPathHeightAtXApplierFunc);
    
    CGFloat y = findPathHeightAtX_y;
    
    findPathHeightAtXLastPoint = CGPointZero;
    findPathHeightAtX_y = FLT_MIN;
    
    return y;
}

static CGFloat findPathHeightAtX_y;
static CGPoint findPathHeightAtXLastPoint;

void cgFindPathHeightAtXApplierFunc(void *info, const CGPathElement *element)
{
    NSDictionary *infoDict = (__bridge NSDictionary *)info;
    CGFloat x = [infoDict[@"x"] doubleValue];
    CGFloat maxLineLength = [infoDict[@"maxLineLength"] doubleValue];
    
    CGPoint *elementPoints = element->points;
    CGPathElementType type = element->type;
    
    if (type == kCGPathElementMoveToPoint) {
        findPathHeightAtXLastPoint = elementPoints[0];
    }
    else if (type == kCGPathElementAddLineToPoint) {
        if (findPathHeightAtXLastPoint.x <= x && elementPoints[0].x >= x) {
            findPathHeightAtX_y = interpolateYForXBetweenPoints(findPathHeightAtXLastPoint, elementPoints[0], x);
        }
        
        findPathHeightAtXLastPoint = elementPoints[0];
    }
    else if (type == kCGPathElementCloseSubpath) {
        findPathHeightAtXLastPoint = CGPointZero;
    }
    else {
        CGPoint p0 = findPathHeightAtXLastPoint;
        CGPoint cp0;
        CGPoint cp1;
        CGPoint p1;
        
        if (type == kCGPathElementAddQuadCurveToPoint) {
            cp0 = elementPoints[0];
            cp1 = elementPoints[0];
            p1 = elementPoints[1];
        }
        else {
            cp0 = elementPoints[0];
            cp1 = elementPoints[1];
            p1 = elementPoints[2];
        }
        
        if (p0.x <= x && p1.x >= x) {
            NSMutableArray *newPoints = [NSMutableArray new];
            
            approximatePathSegment(p0, cp0, cp1, p1, p0, 0.0, p1, 1.0, maxLineLength, newPoints);
            
            for (NSUInteger i = 0; i < newPoints.count - 1; i++) {
                p0 = [newPoints[i] CGPointValue];
                p1 = [newPoints[i+1] CGPointValue];
                
                if (p0.x <= x && p1.x >= x) {
                    findPathHeightAtX_y = interpolateYForXBetweenPoints(p0, p1, x);
                }
            }
        }
        
        findPathHeightAtXLastPoint = p1;
    }
}

CGFloat interpolateYForXBetweenPoints(CGPoint p0, CGPoint p1, CGFloat x)
{
    if (p0.x == p1.x) {
        return (p0.y + p1.y) / 2.0;
    }
    
    CGFloat xFactor = (x - p0.x) / (p1.x - p0.x);
    CGFloat yDiff = p1.y - p0.y;
    
    return p0.y + xFactor * yDiff;
}

@end
