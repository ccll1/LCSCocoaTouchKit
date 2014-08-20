//
//  UILabel+FontAppearance.m
//  Minimal Sudoku
//
//  Created by Christoph Lauterbach on 09.03.14.
//  Copyright (c) 2014 Christoph Lauterbach. All rights reserved.
//

#import "UILabel+FontAppearance.h"

@implementation UILabel (FontAppearance)

- (void)setAppearanceFont:(UIFont*)font
{
    if (self.font) {
        self.font = [font fontWithSize:self.font.pointSize];
    }
    else {
        self.font = font;
    }
}

- (UIFont*)appearanceFont
{
    return [self font];
}

@end
