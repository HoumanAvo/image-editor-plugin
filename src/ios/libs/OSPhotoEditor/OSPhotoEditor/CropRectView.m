//
//  CropRectView.m
//  OSPhotoEditor
//
//  Created by Luis Bouça on 01/03/2021.
//  Copyright © 2021 André Gonçalves. All rights reserved.
//

#import "CropRectView.h"

@implementation CropRectView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void) initialize{
    [self setShowsGridMajor:true];
    [self setShowsGridMinor:false];
    [self setKeepAspectRatio:false];
    _topLeftCornerView = [[ResizeControl alloc] init];
    _topRightCornerView = [[ResizeControl alloc] init];
    _bottomLeftCornerView = [[ResizeControl alloc] init];
    _bottomRightCornerView = [[ResizeControl alloc] init];
    _topEdgeView = [[ResizeControl alloc] init];
    _leftEdgeView = [[ResizeControl alloc] init];
    _rightEdgeView = [[ResizeControl alloc] init];
    _bottomEdgeView = [[ResizeControl alloc] init];
    _initialRect = CGRectZero;
    _fixedAspectRatio = 0.0;
    self.backgroundColor = UIColor.clearColor;
    self.contentMode = UIViewContentModeRedraw;
    
    _resizeImageView = [[UIImageView alloc] initWithFrame:CGRectInset(self.bounds, -2.0, -2.0)];
    _resizeImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
    NSBundle* bundle = [NSBundle bundleForClass:[self class]];
    UIImage* image = [UIImage imageNamed:@"PhotoCropEditorBorder" inBundle:bundle compatibleWithTraitCollection:nil];
    _resizeImageView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(23.0, 23.0, 23.0, 23.0)];
    [self addSubview:_resizeImageView];
    
    _topEdgeView.delegate = self;
    [self addSubview:_topEdgeView ];
    _leftEdgeView.delegate = self;
    [self addSubview:_leftEdgeView ];
    _rightEdgeView.delegate = self;
    [self addSubview:_rightEdgeView ];
    _bottomEdgeView.delegate = self;
    [self addSubview:_bottomEdgeView ];
    
    _topLeftCornerView.delegate = self;
    [self addSubview:_topLeftCornerView ];
    _topRightCornerView.delegate = self;
    [self addSubview:_topRightCornerView ];
    _bottomLeftCornerView.delegate = self;
    [self addSubview:_bottomLeftCornerView ];
    _bottomRightCornerView.delegate = self;
    [self addSubview:_bottomRightCornerView ];
}

-(void)setShowsGridMajor:(BOOL) showsGridMajor{
    [self setNeedsDisplay];
}
-(void)setShowsGridMinor:(BOOL) showsGridMinor{
    [self setNeedsDisplay];
}

-(void)setKeepAspectRatio:(BOOL)keepAspectRatio{
    if(keepAspectRatio){
        _fixedAspectRatio = MIN([self bounds].size.width/[self bounds].size.height, [self bounds].size.height/[self bounds].size.width);
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    for (int i = 0; i<[self subviews].count; i++) {
        if ([[[self subviews] objectAtIndex:i] isKindOfClass:[ResizeControl class]]) {
            ResizeControl* subview =[[self subviews] objectAtIndex:i];
            if(CGRectContainsPoint(subview.frame, point)){
                return subview;
            }
        }
    }
    return nil;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGFloat height = [self bounds].size.height;
    CGFloat width = [self bounds].size.width;
    
    for(int i = 0; i<3; i++){
        CGFloat borderPadding = 0.5;
        
        if(_showsGridMinor){
            for(int j = 0; j<3;j++){
                [[[UIColor alloc] initWithRed:1.0 green:1.0 blue:0.0 alpha:0.3] set];
                UIRectFill(CGRectMake(round((width / 9.0) * ((CGFloat)j) + (width / 3.0) * ((CGFloat)i)), borderPadding, 1.0, round(height)-borderPadding*2.0));
                UIRectFill(CGRectMake(borderPadding, round((height/9.0)*((CGFloat)j)+(height/3.0)*((CGFloat)i)), round(width)- borderPadding*2.0, 1.0));
            }
        }
        if(_showsGridMinor){
            if(i>0){
                [UIColor.whiteColor set];
                UIRectFill(CGRectMake(round(((CGFloat)i) * width / 3.0) , borderPadding, 1.0, round(height)-borderPadding*2.0));
                UIRectFill(CGRectMake(borderPadding, round(((CGFloat)i) * height/3.0), round(width)- borderPadding*2.0, 1.0));
            }
        }
    }
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect tempFrame = _topLeftCornerView.frame;//.origin.x = (CGFloat) _topLeftCornerView.bounds.size.width/-2.0;
    tempFrame.origin = CGPointMake(_topLeftCornerView.bounds.size.width/-2.0, _topLeftCornerView.bounds.size.height/-2.0);
    _topLeftCornerView.frame = tempFrame;
    
    tempFrame = _topRightCornerView.frame;//.origin.x = (CGFloat) _topLeftCornerView.bounds.size.width/-2.0;
    tempFrame.origin = CGPointMake([self bounds].size.width - _topRightCornerView.bounds.size.width - 2.0, _topRightCornerView.bounds.size.height/-2.0);
    _topRightCornerView.frame = tempFrame;
    
    tempFrame = _bottomLeftCornerView.frame;//.origin.x = (CGFloat) _topLeftCornerView.bounds.size.width/-2.0;
    tempFrame.origin = CGPointMake(_bottomLeftCornerView.bounds.size.width/-2.0,[self bounds].size.height - _bottomLeftCornerView.bounds.size.height/2.0);
    _bottomLeftCornerView.frame = tempFrame;
    
    tempFrame = _bottomRightCornerView.frame;//.origin.x = (CGFloat) _topLeftCornerView.bounds.size.width/-2.0;
    tempFrame.origin = CGPointMake([self bounds].size.width - _bottomRightCornerView.bounds.size.width/2.0, [self bounds].size.height - _bottomRightCornerView.bounds.size.height/2.0);
    _bottomRightCornerView.frame = tempFrame;
    
    
    _topEdgeView.frame = CGRectMake(CGRectGetMaxX(_topLeftCornerView.frame), _topEdgeView.frame.size.height / -2.0, CGRectGetMinX(_topRightCornerView.frame) - CGRectGetMaxX(_topLeftCornerView.frame), _topEdgeView.bounds.size.height);
    _leftEdgeView.frame = CGRectMake(_leftEdgeView.frame.size.width / -2.0, CGRectGetMaxY(_topLeftCornerView.frame), _leftEdgeView.frame.size.width, CGRectGetMinY(_bottomLeftCornerView.frame) - CGRectGetMaxY(_topLeftCornerView.frame));
    _bottomEdgeView.frame = CGRectMake(CGRectGetMaxX(_bottomLeftCornerView.frame), CGRectGetMinY(_bottomLeftCornerView.frame), CGRectGetMinX(_bottomRightCornerView.frame) - CGRectGetMaxX(_bottomLeftCornerView.frame), _bottomEdgeView.frame.size.height);
    _rightEdgeView.frame = CGRectMake([self bounds].size.width - _rightEdgeView.frame.size.width / 2.0, CGRectGetMaxY(_topRightCornerView.frame), _rightEdgeView.frame.size.width, CGRectGetMinY(_bottomRightCornerView.frame) - CGRectGetMaxY(_topRightCornerView.frame));
}


-(void) enableResizing:(BOOL) enabled {
    _resizeImageView.hidden = !enabled;
    
    _topLeftCornerView.enabled = enabled;
    _topRightCornerView.enabled = enabled;
    _bottomLeftCornerView.enabled = enabled;
    _bottomRightCornerView.enabled = enabled;
    
    _topEdgeView.enabled = enabled;
    _leftEdgeView.enabled = enabled;
    _bottomEdgeView.enabled = enabled;
    _rightEdgeView.enabled = enabled;
}

// MARK: - ResizeControl delegate methods
- (void)resizeControlDidBeginResizing:(ResizeControl *)control{
    _initialRect = [self frame];
    [_delegate cropRectViewDidBeginEditing:self];
    
}

- (void) resizeControlDidResize:(ResizeControl *)control {
    self.frame = [self cropRectWithResizeControlView:control];
    [_delegate cropRectViewDidChange:self];
}

- (void) resizeControlDidEndResizing:(ResizeControl *)control{
    [_delegate cropRectViewDidEndEditing:self];
}

-(CGRect) cropRectWithResizeControlView:(ResizeControl*) resizeControl {
    CGRect rect = [self frame];
    
    if(resizeControl == _topEdgeView) {
        rect = CGRectMake(CGRectGetMinX(_initialRect),
                          CGRectGetMinY(_initialRect) + resizeControl.translation.y,
                          _initialRect.size.width,
                          _initialRect.size.height - resizeControl.translation.y);
        
        if(_keepAspectRatio) {
            rect = [self constrainedRectWithRectBasisOfHeight:rect];
        }
    } else if(resizeControl == _leftEdgeView) {
        rect = CGRectMake(CGRectGetMinX(_initialRect) + resizeControl.translation.x,
                          CGRectGetMinY(_initialRect),
                          _initialRect.size.width - resizeControl.translation.x,
                          _initialRect.size.height);
        
        if(_keepAspectRatio ){
            rect = [self constrainedRectWithRectBasisOfWidth:rect];
        }
    } else if(resizeControl == _bottomEdgeView) {
        rect = CGRectMake(CGRectGetMinX(_initialRect),
                          CGRectGetMinY(_initialRect),
                          _initialRect.size.width,
                          _initialRect.size.height + resizeControl.translation.y);
        
        if(_keepAspectRatio ){
            rect = [self constrainedRectWithRectBasisOfHeight:rect];
        }
    } else if(resizeControl == _rightEdgeView) {
        rect = CGRectMake(CGRectGetMinX(_initialRect),
                          CGRectGetMinY(_initialRect),
                          _initialRect.size.width + resizeControl.translation.x,
                          _initialRect.size.height);
        
        if(_keepAspectRatio) {
            rect = [self constrainedRectWithRectBasisOfWidth:rect];
        }
    } else if(resizeControl == _topLeftCornerView) {
        rect = CGRectMake(CGRectGetMinX(_initialRect) + resizeControl.translation.x,
                          CGRectGetMinY(_initialRect) + resizeControl.translation.y,
                          _initialRect.size.width - resizeControl.translation.x,
                          _initialRect.size.height - resizeControl.translation.y);
        
        if(_keepAspectRatio) {
            CGRect constrainedFrame;
            if( fabs(resizeControl.translation.x) < fabs(resizeControl.translation.y)) {
                constrainedFrame = [self constrainedRectWithRectBasisOfHeight:rect];
            } else {
                constrainedFrame = [self constrainedRectWithRectBasisOfWidth:rect];
            }
            constrainedFrame.origin.x -= constrainedFrame.size.width - rect.size.width;
            constrainedFrame.origin.y -= constrainedFrame.size.height - rect.size.height;
            rect = constrainedFrame;
        }
    } else if(resizeControl == _topRightCornerView) {
        rect = CGRectMake(CGRectGetMinX(_initialRect),
                          CGRectGetMinY(_initialRect) + resizeControl.translation.y,
                          _initialRect.size.width + resizeControl.translation.x,
                          _initialRect.size.height - resizeControl.translation.y);
        
        if(_keepAspectRatio) {
            if( fabs(resizeControl.translation.x) < fabs(resizeControl.translation.y)) {
                rect = [self constrainedRectWithRectBasisOfHeight:rect];
            } else {
                rect = [self constrainedRectWithRectBasisOfWidth:rect];
            }
        }
    } else if(resizeControl == _bottomLeftCornerView) {
        rect = CGRectMake(CGRectGetMinX(_initialRect) + resizeControl.translation.x,
                          CGRectGetMinY(_initialRect),
                          _initialRect.size.width - resizeControl.translation.x,
                          _initialRect.size.height + resizeControl.translation.y);
        if(_keepAspectRatio) {
            CGRect constrainedFrame;
            if(fabs(resizeControl.translation.x) < fabs(resizeControl.translation.y)) {
                constrainedFrame = [self constrainedRectWithRectBasisOfHeight:rect];
            } else {
                constrainedFrame = [self constrainedRectWithRectBasisOfWidth:rect];
            }
            constrainedFrame.origin.x -= constrainedFrame.size.width - rect.size.width;
            rect = constrainedFrame;
        }
    } else if(resizeControl == _bottomRightCornerView) {
        rect = CGRectMake( CGRectGetMinX(_initialRect),
                          CGRectGetMinY(_initialRect),
                          _initialRect.size.width + resizeControl.translation.x,
                          _initialRect.size.height + resizeControl.translation.y);
        
        if(_keepAspectRatio){
            if(fabs(resizeControl.translation.x) < fabs(resizeControl.translation.y)) {
                rect = [self constrainedRectWithRectBasisOfHeight:rect];
            } else {
                rect = [self constrainedRectWithRectBasisOfWidth:rect];
            }
        }
    }
    
    CGFloat minWidth = _leftEdgeView.bounds.size.width + _rightEdgeView.bounds.size.width;
    if(rect.size.width < minWidth) {
        rect.origin.x = CGRectGetMaxX([self frame]) - minWidth;
        rect.size.width = minWidth;
    }
    
    CGFloat minHeight = _topEdgeView.bounds.size.height + _bottomEdgeView.bounds.size.height;
    if(rect.size.height < minHeight) {
        rect.origin.y = CGRectGetMaxY([self frame]) - minHeight;
        rect.size.height = minHeight;
    }
    
    if(_fixedAspectRatio > 0){
        CGRect constraintedFrame = rect;
        if(rect.size.width < minWidth) {
            constraintedFrame.size.width = rect.size.height * (minWidth / rect.size.width);
        }
        if(rect.size.height < minHeight) {
            constraintedFrame.size.height = rect.size.width * (minHeight / rect.size.height);
        }
        rect = constraintedFrame;
    }
    
    return rect;
}

- (CGRect)constrainedRectWithRectBasisOfWidth:(CGRect)frame{
    CGRect result = [self frame];
    CGFloat width = result.size.width;
    CGFloat height = result.size.height;
    
    if(width < height) {
        height = width / _fixedAspectRatio;
    } else {
        height = width * _fixedAspectRatio;
    }
    result.size = CGSizeMake(width, height);
    return result;
}

- (CGRect)constrainedRectWithRectBasisOfHeight:(CGRect)frame{
    CGRect result = [self frame];
    CGFloat width = result.size.width;
    CGFloat height = result.size.height;
    
    if(width < height) {
        height = width * _fixedAspectRatio;
    } else {
        height = width / _fixedAspectRatio;
    }
    result.size = CGSizeMake(width, height);
    return result;
}


@end
