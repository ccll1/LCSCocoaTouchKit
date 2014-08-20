//
//  UIBezierPath+ConenvienceAdditions.m
//  LCSCocoaTouchKit
//
//  Created by Christoph Lauterbach on 12.02.14.
//  Copyright (c) 2014 Christoph Lauterbach. All rights reserved.
//

#import "UIBezierPath+LCSCocoaTouchKit.h"

@implementation UIBezierPath (LCSCocoaTouchKit)

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
    CGFloat distance = sqrt(pow(pt0.x - pt1.x, 2.0) + pow(pt0.y - pt1.y, 2.0));
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

- (BOOL)isEqual:(id)anObject
{
    if (self == anObject)
        return YES;
    if (![anObject isKindOfClass: [UIBezierPath class]])
        return NO;
    
    CGPathRef path = self.CGPath;
    CGPathRef otherPath = [anObject CGPath];
    
    return CGPathEqualToPath(path, otherPath);
}

@end
