//
//  GradientView.m
//  OSPhotoEditor
//
//  Created by Luis Bouça on 14/04/2021.
//  Copyright © 2021 André Gonçalves. All rights reserved.
//

#import "GradientView.h"

@implementation GradientView

- (void)awakeFromNib{
    [super awakeFromNib];
    if (![self gradientFromtop]) {
        _gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor clearColor].CGColor,[[UIColor alloc]initWithWhite:0.0 alpha:0.5].CGColor, nil];
    }else{
        _gradientLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor alloc]initWithWhite:0.0 alpha:0.5].CGColor,[UIColor clearColor].CGColor, nil];
    }
    _gradientLayer.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:1.0],nil];
    self.backgroundColor = UIColor.clearColor;
    [[self layer] addSublayer:_gradientLayer];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _gradientLayer.frame = [self bounds];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.gradientFromtop = true;
        self.gradientLayer = [[CAGradientLayer alloc] init];
    }
    return self;
}

@end
