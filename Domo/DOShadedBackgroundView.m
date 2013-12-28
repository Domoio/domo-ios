//
//  DOShadedBackgroundView.m
//  Domo
//
//  Created by Alexander Hoekje List on 12/27/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "DOShadedBackgroundView.h"

@interface DOShadedBackgroundView ()

@end

@implementation DOShadedBackgroundView //shout-outs to SIAlertView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.opaque = NO;
        self.backgroundColor = nil;
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    size_t locationsCount = 2;
    CGFloat locations[2] = {0.0f, 1.0f};
    CGFloat colors[8] = {0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.75f};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, locationsCount);
    CGColorSpaceRelease(colorSpace);
    
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    CGFloat radius = MIN(self.bounds.size.width, self.bounds.size.height) ;
    CGContextDrawRadialGradient (context, gradient, center, 0, center, radius, kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient);
}

@end