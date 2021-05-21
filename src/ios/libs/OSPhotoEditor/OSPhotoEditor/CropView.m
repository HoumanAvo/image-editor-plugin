//
//  CropView.m
//  OSPhotoEditor
//
//  Created by Luis Bouça on 06/04/2021.
//  Copyright © 2021 André Gonçalves. All rights reserved.
//

#import "CropView.h"
#import "UIImage+Crop.h"

@implementation CropView

-(void)setImage:(UIImage*)image{
    if(image != nil){
        _imageSize = image.size;
    }
    [_imageView removeFromSuperview];
    _imageView = nil;
    [_zoomingView removeFromSuperview];
    _zoomingView = nil;
    [self setNeedsLayout];
}
-(void)setImageView:(UIView*) imageView{
    if(_image == nil){
        _imageSize = imageView.frame.size;
    }
    _usingCustomImageView = true;
    [self setNeedsLayout];
}

- (UIImage *)getCroppedImage{
    return [_image rotatedImageWithTransform:_rotation croppedToRect: [self zoomedCropRect] ];
}

- (void)setKeepAspectRatio:(BOOL)keepAspectRatio{
    _cropRectView.keepAspectRatio = keepAspectRatio;
}

- (void)setCropAspectRatio:(CGFloat)cropAspectRatio{
    [self setCropAspectRatio:cropAspectRatio shouldCenter:true];
}

- (CGFloat)getCropAspectRatio{
    return _scrollView.frame.size.width / _scrollView.frame.size.height;
}

- (CGAffineTransform)getRotation{
    if (_imageView != nil) {
        return _imageView.transform;
    }else{
        return CGAffineTransformIdentity;
    }
}

- (void)setRotationAngle:(CGFloat)rotationAngle{
    _imageView.transform = CGAffineTransformMakeRotation(rotationAngle);
}

- (CGFloat)getRotationAngle{
    return atan2(_rotation.b, _rotation.a);
}

- (CGRect)getCropRect{
    return _scrollView.frame;
}

- (void)setCropRect:(CGRect)cropRect{
    [self zoomToCropRect:cropRect];
}

- (void)setImageCropRect:(CGRect)imageCropRect{
    [self resetCropRect];
    
    CGFloat scale = MIN(_scrollView.frame.size.width/_imageSize.width, _scrollView.frame.size.height/_imageSize.height);
    CGFloat x = CGRectGetMinX(_imageCropRect)*scale+CGRectGetMinX(_scrollView.frame);
    CGFloat y = CGRectGetMinY(_imageCropRect)*scale+CGRectGetMinY(_scrollView.frame);
    

    CGFloat width = _imageCropRect.size.width*scale;
    CGFloat height = _imageCropRect.size.height*scale;
    
    CGRect rect = CGRectMake(x, y, width, height);
    CGRect intersection = CGRectIntersection(rect, _scrollView.frame);
    
    if (!CGRectIsNull(intersection)) {
        _cropRect = intersection;
    }
    
}
- (void)setResizeEnabled:(BOOL)resizeEnabled{
    [_cropRectView enableResizing:resizeEnabled];
}

- (void)setShowCroppedArea:(BOOL)showCroppedArea{
    [self layoutIfNeeded];
    _scrollView.clipsToBounds = !showCroppedArea;
    [self showOverlayView:showCroppedArea];
}

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

-(void) initialize{
    _imageSize = CGSizeMake(1.0, 1.0);
    _cropRectView = [[CropRectView alloc] init];
    _topOverlayView = [[UIView alloc] init];
    _leftOverlayView = [[UIView alloc] init];
    _rightOverlayView = [[UIView alloc] init];
    _bottomOverlayView = [[UIView alloc] init];
    _insetRect = CGRectZero;
    _editingRect = CGRectZero;
    _interfaceOrientation = UIApplication.sharedApplication.statusBarOrientation;
    _resizing = false;
    _usingCustomImageView = false;
    _MarginTop = 37.0;
    _MarginLeft = 20.0;
    [self setKeepAspectRatio:false];
    [self setImageCropRect:CGRectZero];
    [self setResizeEnabled:true];
    [self setShowCroppedArea:true];
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundColor = UIColor.clearColor;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:[self bounds]];
    _scrollView.delegate = self;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleBottomMargin |UIViewAutoresizingFlexibleRightMargin;
    _scrollView.backgroundColor = UIColor.clearColor;
    _scrollView.maximumZoomScale = 20.0;
    _scrollView.minimumZoomScale = 1.0;
    _scrollView.showsHorizontalScrollIndicator = false;
    _scrollView.showsVerticalScrollIndicator = false;
    _scrollView.bounces = false;
    _scrollView.bouncesZoom = false;
    _scrollView.clipsToBounds =  false;
    [self addSubview:_scrollView];
    
    _rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)];
    _rotationGestureRecognizer.delegate = self;
    [_scrollView addGestureRecognizer:_rotationGestureRecognizer];
    
    _cropRectView.delegate = self;
    [self addSubview:_cropRectView];
    
    [self showOverlayView:_showCroppedArea];
    [self addSubview:_topOverlayView];
    [self addSubview:_leftOverlayView];
    [self addSubview:_rightOverlayView];
    [self addSubview:_bottomOverlayView];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if (![self isUserInteractionEnabled]) {
        return nil;
    }
    UIView* hitView = [_cropRectView hitTest:[self convertPoint:point toView:_cropRectView] withEvent:event];
    if(hitView != nil) {
        return hitView;
    }
    CGPoint locationInImageView = [self convertPoint:point toView:_zoomingView];
    CGPoint zoomedPoint = CGPointMake(locationInImageView.x*_scrollView.zoomScale, locationInImageView.y * _scrollView.zoomScale);
    
    if (CGRectContainsPoint(_zoomingView.frame, zoomedPoint)){
        return _scrollView;
    }
    return [super hitTest:point withEvent:event];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    UIInterfaceOrientation interfaceOrientation = UIApplication.sharedApplication.statusBarOrientation;
    
    if(_image == nil && _imageView == nil) {
        return;
    }
    
    [self setupEditingRect];

    if(_imageView == nil) {
        if (interfaceOrientation == UIInterfaceOrientationPortrait) {
            _insetRect = CGRectInset([self bounds], _MarginLeft, _MarginTop);
        } else {
            _insetRect = CGRectInset([self bounds], _MarginLeft, _MarginLeft);
        }
        if(!_showCroppedArea) {
            _insetRect = _editingRect;
        }
        [self setupZoomingView];
        [self setupImageView];
    } else if(_usingCustomImageView) {
        if (interfaceOrientation == UIInterfaceOrientationPortrait) {
            _insetRect = CGRectInset([self bounds], _MarginLeft, _MarginTop);
        } else {
            _insetRect = CGRectInset([self bounds], _MarginLeft, _MarginLeft);
        }
        if (!_showCroppedArea) {
            _insetRect = _editingRect;
        }
        [self setupZoomingView];
        _imageView.frame = _zoomingView.bounds;
        [_zoomingView addSubview:_imageView];
        _usingCustomImageView = false;
    }
    
    if(!_resizing) {
        [self layoutCropRectViewWithCropRect:_scrollView.frame];
        if(self.interfaceOrientation != interfaceOrientation) {
            [self zoomToCropRect:_scrollView.frame];
        }
    }
    
    self.interfaceOrientation = interfaceOrientation;
}

- (void)setRotationAngle:(CGFloat) rotationAngle snap:(BOOL)snap {
    CGFloat rotation = rotationAngle;
    if(snap){
        rotation = nearbyint(rotationAngle / (M_PI/2)) * M_PI/2;
    }
    self.rotationAngle = rotation;
}

- (void)resetCropRect {
    [self resetCropRectAnimated:false];
}

- (void)resetCropRectAnimated:(BOOL) animated{
    if(animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationBeginsFromCurrentState:true];
    }
    _imageView.transform = CGAffineTransformIdentity;
    CGSize contentSize = _scrollView.contentSize;
    CGRect initialRect = CGRectMake(0,0, contentSize.width, contentSize.height);
    [_scrollView zoomToRect:initialRect animated:false];
    [self layoutCropRectViewWithCropRect:_scrollView.bounds];
    
    if(animated){
        [UIView commitAnimations];
    }
}

- (CGRect)zoomedCropRect{
    
    CGRect cropRect = [self convertRect:_scrollView.frame toView:_zoomingView];
    CGFloat ratio = 1.0;
    UIInterfaceOrientation orientation = UIApplication.sharedApplication.statusBarOrientation;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad || orientation == UIInterfaceOrientationPortrait) {
        ratio = AVMakeRectWithAspectRatioInsideRect(_imageSize, _insetRect).size.width / _imageSize.width;
    } else {
        ratio = AVMakeRectWithAspectRatioInsideRect(_imageSize, _insetRect).size.height / _imageSize.height;
    }
    
    CGRect zoomedCropRect = CGRectMake(cropRect.origin.x / ratio,
                                       cropRect.origin.y / ratio,
                                       cropRect.size.width / ratio,
                                       cropRect.size.height / ratio);
    
    return zoomedCropRect;
}

- (UIImage*)croppedImage:(UIImage*) image{
    _imageSize = image.size;
    return [image rotatedImageWithTransform:_rotation croppedToRect: [self zoomedCropRect] ];
}

- (void)handleRotation:(UIRotationGestureRecognizer*) gestureRecognizer{
    if(_imageView != nil) {
        CGFloat rotation = gestureRecognizer.rotation;
        CGAffineTransform transform = CGAffineTransformRotate(_imageView.transform, rotation);
        _imageView.transform = transform;
        gestureRecognizer.rotation = 0.0;
    }
    
    switch(gestureRecognizer.state){
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
            _cropRectView.showsGridMinor = true;
            break;
        default:
            _cropRectView.showsGridMinor = false;
    }
}

// MARK: - Private methods
- (void) showOverlayView:(BOOL) show{
    UIColor* color;
    if (show) {
        color = [[UIColor alloc] initWithWhite:0.0 alpha:0.4];
    }else{
        color = UIColor.clearColor;
    }
    _topOverlayView.backgroundColor = color;
    _leftOverlayView.backgroundColor = color;
    _rightOverlayView.backgroundColor = color;
    _bottomOverlayView.backgroundColor = color;
}

- (void)setupEditingRect {
    UIInterfaceOrientation interfaceOrientation = UIApplication.sharedApplication.statusBarOrientation;
    if(interfaceOrientation == UIInterfaceOrientationPortrait){
        _editingRect = CGRectInset([self bounds], _MarginLeft, _MarginTop);
    } else {
        _editingRect = CGRectInset([self bounds], _MarginLeft, _MarginLeft);
    }
    if(!_showCroppedArea){
        _editingRect = CGRectMake(0, 0, [self bounds].size.width, [self bounds].size.height);
    }
}

- (void)setupZoomingView {
    CGRect cropRect = AVMakeRectWithAspectRatioInsideRect(_imageSize, _insetRect);
    
    _scrollView.frame = cropRect;
    _scrollView.contentSize = cropRect.size;
    
    _zoomingView = [[UIView alloc] initWithFrame:_scrollView.bounds];
    _zoomingView.backgroundColor = UIColor.clearColor;
    [_scrollView addSubview:_zoomingView];
}

- (void)setupImageView {
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:_zoomingView.bounds];
    imageView.backgroundColor = UIColor.clearColor;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = _image;
    [_zoomingView addSubview:imageView];
    self.imageView = imageView;
    _usingCustomImageView = false;
}

- (void)layoutCropRectViewWithCropRect:(CGRect) cropRect{
    _cropRectView.frame = cropRect;
    [self layoutOverlayViewsWithCropRect:cropRect];
}

- (void)layoutOverlayViewsWithCropRect:(CGRect) cropRect{
    _topOverlayView.frame = CGRectMake(0, 0, [self bounds].size.width, CGRectGetMinY(cropRect));
    _leftOverlayView.frame = CGRectMake(0, CGRectGetMinY(cropRect), CGRectGetMinX(cropRect), cropRect.size.height);
    _rightOverlayView.frame = CGRectMake(CGRectGetMaxX(cropRect), CGRectGetMinY(cropRect), [self bounds].size.width - CGRectGetMaxX(cropRect), cropRect.size.height);
    _bottomOverlayView.frame = CGRectMake(0, CGRectGetMaxY(cropRect), [self bounds].size.width, [self bounds].size.height - CGRectGetMaxY(cropRect));
}

- (void)zoomToCropRect:(CGRect) toRect{
    [self zoomToCropRect:toRect shouldCenter:false animated:true completion:nil];
}

- (void)zoomToCropRect:(CGRect) toRect shouldCenter:(BOOL)shouldCenter animated:(BOOL)animated completion:(void (^)(void))completion {
    
    if(CGRectEqualToRect(_scrollView.frame, toRect)) {
        return;
    }
    
    CGFloat width = toRect.size.width;
    CGFloat height = toRect.size.height;
    CGFloat scale = MIN(_editingRect.size.width/width, _editingRect.size.height/height);
    
    CGFloat scaledWidth = width * scale;
    CGFloat scaledHeight = height * scale;
    CGRect cropRect = CGRectMake(([self bounds].size.width - scaledWidth) / 2.0,([self bounds].size.height - scaledHeight) / 2.0, scaledWidth, scaledHeight);
    
    CGRect zoomRect = [self convertRect:toRect toView:_zoomingView];
    zoomRect.size.width = cropRect.size.width / (_scrollView.zoomScale * scale);
    zoomRect.size.height = cropRect.size.height / (_scrollView.zoomScale * scale);
    if (_imageView != nil && shouldCenter) {
        CGRect imageViewBounds = _imageView.bounds;
        zoomRect.origin.x = (imageViewBounds.size.width / 2.0) - (zoomRect.size.width / 2.0);
        zoomRect.origin.y = (imageViewBounds.size.height / 2.0) - (zoomRect.size.height / 2.0);
    }
    
    CGFloat duration = 0.0;
    if (animated) {
        duration = 0.25;
    }
    
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.scrollView.bounds = cropRect;
        [self.scrollView zoomToRect:zoomRect animated:false];
        [self layoutCropRectViewWithCropRect:cropRect];
    } completion:^(BOOL finished) {
        if(completion != nil){
            completion();
        }
    }];
}

- (CGRect)cappedCropRectInImageRectWithCropRectView:(CropRectView*) cropRectView{
    CGRect cropRect = cropRectView.frame;
    
    CGRect rect = [self convertRect:cropRect toView:_scrollView];
    if(CGRectGetMinX(rect) < CGRectGetMinX(_zoomingView.frame)) {
        cropRect.origin.x = CGRectGetMinX([_scrollView convertRect:_zoomingView.frame toView:self]);
        CGFloat cappedWidth = CGRectGetMaxX(rect);
        CGFloat height = !_keepAspectRatio ? cropRect.size.height : cropRect.size.height * (cappedWidth / cropRect.size.width);
        cropRect.size = CGSizeMake(cappedWidth, height);
    }
    
    if(CGRectGetMinY(rect) < CGRectGetMinY(_zoomingView.frame)) {
        cropRect.origin.y = CGRectGetMinY([_scrollView convertRect:_zoomingView.frame toView:self]);
        CGFloat cappedHeight = CGRectGetMaxY(rect);
        CGFloat width = !_keepAspectRatio ? cropRect.size.width : cropRect.size.width * (cappedHeight / cropRect.size.height);
        cropRect.size = CGSizeMake(width, cappedHeight);
    }
        
    if(CGRectGetMaxX(rect) < CGRectGetMaxX(_zoomingView.frame)) {
        CGFloat cappedWidth = CGRectGetMaxX([_scrollView convertRect:_zoomingView.frame toView:self]) - CGRectGetMinX(cropRect);
        CGFloat height = !_keepAspectRatio ? cropRect.size.height : cropRect.size.height * (cappedWidth / cropRect.size.width);
        cropRect.size = CGSizeMake(cappedWidth, height);
    }
            
    if(CGRectGetMaxY(rect) < CGRectGetMaxY(_zoomingView.frame)) {
        CGFloat cappedHeight = CGRectGetMaxY([_scrollView convertRect:_zoomingView.frame toView:self]) - CGRectGetMinY(cropRect);
        CGFloat width = !_keepAspectRatio ? cropRect.size.width : cropRect.size.width * (cappedHeight / cropRect.size.height);
        cropRect.size = CGSizeMake(width, cappedHeight);
    }
    
    return cropRect;
}

- (void)automaticZoomIfEdgeTouched:(CGRect) cropRect{
    if (CGRectGetMinX(cropRect) < CGRectGetMinX(_editingRect)-5.0 || CGRectGetMaxX(cropRect) > CGRectGetMaxX(_editingRect)+5.0 || CGRectGetMinY(cropRect) < CGRectGetMinY(_editingRect)-5.0 || CGRectGetMaxY(cropRect) > CGRectGetMaxY(_editingRect)+5.0 ) {
        [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self zoomToCropRect:self.cropRectView.frame];
        } completion:nil];
    }
}

- (void)setCropAspectRatio:(CGFloat) ratio shouldCenter:(BOOL)shouldCenter {
    CGRect cropRect = _scrollView.frame;
    CGFloat width = cropRect.size.width;
    CGFloat height = cropRect.size.height;
    if(ratio <= 1.0){
        width = height * ratio;
        if(width > _imageView.bounds.size.width) {
            width = cropRect.size.width;
            height = width / ratio;
        }
    } else {
        height = width / ratio;
        if(height > _imageView.bounds.size.height) {
            height = cropRect.size.height;
            width = height * ratio;
        }
    }
    cropRect.size = CGSizeMake(width, height);
    [self zoomToCropRect:cropRect shouldCenter:shouldCenter animated:false completion:^{
        CGFloat scale = self.scrollView.zoomScale;
        self.scrollView.minimumZoomScale = scale;
    }];
}

// MARK: - CropView delegate methods
- (void)cropRectViewDidBeginEditing:(CropRectView *)view{
    _resizing = true;
}

- (void)cropRectViewDidChange:(CropRectView *)view{
    CGRect cropRect = [self cappedCropRectInImageRectWithCropRectView:view];
    [self layoutOverlayViewsWithCropRect:cropRect];
    [self automaticZoomIfEdgeTouched:cropRect];
}

- (void)cropRectViewDidEndEditing:(CropRectView *)view{
    _resizing = false;
    [self zoomToCropRect:_cropRectView.frame];
}

// MARK: - ScrollView delegate methods
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _zoomingView;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    CGPoint contentOffset = scrollView.contentOffset;
    targetContentOffset = &contentOffset;
}

// MARK: - Gesture Recognizer delegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return true;
}

@end
