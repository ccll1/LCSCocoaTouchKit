//
//  LCSCTLabelWithShadow.h
//  LCSCocoaTouchKit
//
//  Created by Christoph Lauterbach on 24.06.14.
//  Copyright (c) 2014 Christoph Lauterbach. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCSCTLabelWithShadow : UILabel

@property (nonatomic) CGFloat shadowRadius UI_APPEARANCE_SELECTOR;
@property (nonatomic) CGFloat shadowOpacity UI_APPEARANCE_SELECTOR;

@end
