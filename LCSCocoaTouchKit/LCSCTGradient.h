//
//  LCSCTGradient.h
//  LCSCocoaTouchKit
//
//  Created by Christoph Lauterbach on 13.10.14.
//  Copyright (c) 2014 Christoph Lauterbach. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LCSCTGradientMode) {
    LCSCTGradientModeRGB,
    LCSCTGradientModeHSB
};

@interface LCSCTGradient : NSObject

@property (nonatomic, readonly) BOOL isValid;

@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSArray *locations;
@property (nonatomic) LCSCTGradientMode  mode;

- (UIColor *)colorAtLocation:(CGFloat)location;

@end
