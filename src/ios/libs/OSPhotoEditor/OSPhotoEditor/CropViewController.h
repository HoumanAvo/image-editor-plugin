//
//  CropViewController.h
//  OSPhotoEditor
//
//  Created by Luis Bouça on 13/04/2021.
//  Copyright © 2021 André Gonçalves. All rights reserved.
//

#ifndef CropViewController_h
#define CropViewController_h

#import "CropView.h"

@class CropViewController;

@protocol CropViewControllerDelegate

-(void)cropViewController:(CropViewController*) controller didFinishCroppingImage:(UIImage*) image transform:(CGAffineTransform) transform cropRect:(CGRect) cropRect;
-(void)cropViewControllerDidCancel:(CropViewController*) controller;

@end

@interface CropViewController : UIViewController

@property(weak)id<CropViewControllerDelegate> delegate;
@property(nonatomic) UIImage* image;
-(void) setImage:(UIImage*)image;

@property(nonatomic) BOOL keepAspectRatio;
-(void) setKeepAspectRatio:(BOOL)keepAspectRatio;

@property(nonatomic) CGFloat cropAspectRatio;
-(void) setCropAspectRatio:(CGFloat)cropAspectRatio;

@property(nonatomic) CGRect cropRect;
-(void) setCropRect:(CGRect)cropRect;

@property(nonatomic) CGRect imageCropRect;
-(void) setImageCropRect:(CGRect)imageCropRect;

@property() BOOL toolbarHidden;
@property(nonatomic) BOOL rotationEnabled;
-(void) setRotationEnabled:(BOOL)rotationEnabled;

@property() CGAffineTransform rotationTransform;
-(CGAffineTransform) getRotationTransform;

@property() CGRect zoomedCropRect;
-(CGRect) getZoomedCropRect;

@property() CropView* cropView;

-(void) initialize;

-(void) resetCropRect;

-(void) resetCropRectAnimated:(BOOL) animated;

-(void) cancel:(UIBarButtonItem*) sender;

-(void)done:(UIBarButtonItem*) sender;

-(void)constrain:(UIBarButtonItem*) sender;

// MARK: - Private methods
-(void)adjustCropRect;
@end

#endif /* CropViewController_h */
