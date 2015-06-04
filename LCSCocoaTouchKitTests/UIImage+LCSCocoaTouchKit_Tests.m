//
//  UIImage+LCSCocoaTouchKit_Tests.m
//  LCSCocoaTouchKit
//
//  Created by Christoph Lauterbach on 11.12.14.
//  Copyright (c) 2014 Christoph Lauterbach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "UIImage+LCSCocoaTouchKit.h"

@interface UIImage_LCSCocoaTouchKit_Tests : XCTestCase

@property (nonatomic,readwrite) UIImage *image;

@end

@implementation UIImage_LCSCocoaTouchKit_Tests

- (void)setUp {
    [super setUp];
    
    NSURL *imageURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"Sample_Image" withExtension:@"png"];
    self.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
}

- (void)testResizeA {
    XCTAssert(self.image);
    __block UIImage *resizedImageA;

    CGSize newSize = CGSizeMake(160.0, 284.0);
    [self measureBlock:^{
        resizedImageA = [self.image resizeTo:newSize];
    }];
    
    XCTAssertNotNil(resizedImageA);
}

- (void)testResizeB {
    XCTAssert(self.image);
    __block UIImage *resizedImageB;
    CGSize newSize = CGSizeMake(160.0, 284.0);
    [self measureBlock:^{
        resizedImageB = [self.image alternativeResizeTo:newSize];
    }];
    
    XCTAssertNotNil(resizedImageB);
}

- (void)testCompareResizedImages
{
    CGSize newSize = CGSizeMake(160.0, 284.0);
    
    UIImage *resizedImageA = [self.image resizeTo:newSize];
    UIImage *resizedImageB = [self.image alternativeResizeTo:newSize];

    XCTAssertTrue([resizedImageA isEqual:resizedImageB]);
}

@end
