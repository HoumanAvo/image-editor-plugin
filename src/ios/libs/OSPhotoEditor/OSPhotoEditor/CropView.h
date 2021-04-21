//
//  CropView.h
//  OSPhotoEditor
//
//  Created by Luis Bouça on 06/04/2021.
//  Copyright © 2021 André Gonçalves. All rights reserved.
//

#ifndef CropView_h
#define CropView_h


#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "CropRectView.h"

@interface CropView : UIView<UIScrollViewDelegate, UIGestureRecognizerDelegate, CropRectViewDelegate>

@property(nonatomic)UIImage* image;
@property(nonatomic)UIView* imageView;
@property()UIImage* croppedImage;
@property(nonatomic)BOOL keepAspectRatio;
@property(nonatomic)CGFloat cropAspectRatio;
@property()CGAffineTransform rotation;
@property(nonatomic)CGFloat rotationAngle;
@property(nonatomic)CGRect cropRect;
@property(nonatomic)CGRect imageCropRect;
@property(nonatomic)BOOL resizeEnabled;
@property(nonatomic)BOOL showCroppedArea;

-(void)setImage:(UIImage*)image;
-(void)setImageView:(UIView*)imageView;
-(UIImage*)getCroppedImage;
-(void)setKeepAspectRatio:(BOOL)keepAspectRatio;
-(void)setCropAspectRatio:(CGFloat)cropAspectRatio;
-(CGFloat)getCropAspectRatio;
-(CGAffineTransform)getRotation;
-(CGFloat)getRotationAngle;
-(void)setRotationAngle:(CGFloat)rotationAngle;
-(CGRect)getCropRect;
-(void)setCropRect:(CGRect)cropRect;
-(void)setImageCropRect:(CGRect)imageCropRect;
-(void)setResizeEnabled:(BOOL)resizeEnabled;
-(void)setShowCroppedArea:(BOOL)showCroppedArea;


@property() UIRotationGestureRecognizer* rotationGestureRecognizer;
@property() CGSize imageSize;
@property() UIScrollView* scrollView;
@property() UIView* zoomingView;
@property() CropRectView* cropRectView;
@property() UIView* topOverlayView;
@property() UIView* leftOverlayView;
@property() UIView* rightOverlayView;
@property() UIView* bottomOverlayView;
@property() CGRect insetRect;
@property() CGRect editingRect;
@property() UIInterfaceOrientation interfaceOrientation;
@property() BOOL resizing;
@property() BOOL usingCustomImageView;
@property() CGFloat MarginTop;
@property() CGFloat MarginLeft;

-(void)initialize;

-(void)setRotationAngle:(CGFloat) rotationAngle snap:(BOOL)snap;

-(void)resetCropRect;

-(void)resetCropRectAnimated:(BOOL) animated;

-(CGRect)zoomedCropRect;

-(UIImage*)croppedImage:(UIImage*) image;

-(void)handleRotation:(UIRotationGestureRecognizer*) gestureRecognizer;

// MARK: - Private methods
-(void)showOverlayView:(BOOL) show;

-(void)setupEditingRect;

-(void)setupZoomingView;

-(void)setupImageView;

-(void)layoutCropRectViewWithCropRect:(CGRect) cropRect;

-(void)layoutOverlayViewsWithCropRect:(CGRect) cropRect;

-(void)zoomToCropRect:(CGRect) toRect;

-(void)zoomToCropRect:(CGRect) toRect shouldCenter:(BOOL)shouldCenter animated:(BOOL)animated completion:(void (^)(void))completion;

-(CGRect)cappedCropRectInImageRectWithCropRectView:(CropRectView*) cropRectView;

-(void)automaticZoomIfEdgeTouched:(CGRect) cropRect;

-(void)setCropAspectRatio:(CGFloat) ratio shouldCenter:(BOOL)shouldCenter;

@end


#endif /* CropView_h */
