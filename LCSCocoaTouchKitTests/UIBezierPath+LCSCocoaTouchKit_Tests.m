//
//  UIBezierPath_LCSCocoaTouchKit_Tests.m
//  LCSCocoaTouchKit
//
//  Created by Christoph Lauterbach on 20.08.14.
//  Copyright (c) 2014 Christoph Lauterbach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "UIBezierPath+LCSCocoaTouchKit.h"

@interface UIBezierPath_LCSCocoaTouchKit_Tests : XCTestCase

@end

@implementation UIBezierPath_LCSCocoaTouchKit_Tests

- (void)testIsEqual {
    UIBezierPath *pathA;
    UIBezierPath *pathB;
    
    pathA = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0.0, 0.0, 100.0, 100.0)];
    pathB = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0.0, 0.0, 100.0, 100.0)];
    
    XCTAssertEqualObjects(pathA, pathB);

    pathA = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(50.0, 0.0, 100.0, 100.0)];
    pathB = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0.0, 0.0, 100.0, 100.0)];
    
    XCTAssertNotEqualObjects(pathA, pathB);
}

@end
