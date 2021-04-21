//
//  ResizeControl.m
//  OSPhotoEditor
//
//  Created by Luis Bouça on 13/04/2021.
//  Copyright © 2021 André Gonçalves. All rights reserved.
//

#import "ResizeControl.h"

@implementation ResizeControl

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize{
    
    _translation = CGPointZero;
    _enabled = true;
    _startPoint = CGPointZero;
    self.backgroundColor = UIColor.clearColor;
    self.exclusiveTouch = true;
    
    UIPanGestureRecognizer* gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.superview addGestureRecognizer:gestureRecognizer ];
}

-(void)handlePan:(UIPanGestureRecognizer*) gestureRecognizer{
    if(!_enabled) {
        return;
    }
    CGPoint translation;
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan :
            translation = [gestureRecognizer translationInView:self.superview];
            _startPoint = CGPointMake(round(translation.x), round(translation.y));
            [_delegate resizeControlDidBeginResizing:self];
            break;
        case UIGestureRecognizerStateChanged :
            translation = [gestureRecognizer translationInView:self.superview];
            _translation = CGPointMake(round(_startPoint.x+ translation.x), round(_startPoint.y+ translation.y));
            [_delegate resizeControlDidResize:self];
            break;
        case UIGestureRecognizerStateEnded :
        case UIGestureRecognizerStateCancelled :
            [_delegate resizeControlDidEndResizing:self];
            break;
            
        default:
            break;
    }    
}

@end
