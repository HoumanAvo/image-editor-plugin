//
//  CropViewController.m
//  OSPhotoEditor
//
//  Created by Luis Bouça on 13/04/2021.
//  Copyright © 2021 André Gonçalves. All rights reserved.
//

#import "CropViewController.h"

@implementation CropViewController

-(void)initialize{
    _keepAspectRatio = false;
    _cropAspectRatio = 0.0;
    _toolbarHidden = false;
    _rotationEnabled = false;
    _cropRect = CGRectZero;
    _imageCropRect = CGRectZero;
    
    [self setRotationEnabled:true];
}

-(void)setImage:(UIImage*)image {
    _cropView.image = image;
}
-(void)setKeepAspectRatio:(BOOL)keepAspectRatio{
    _cropView.keepAspectRatio = keepAspectRatio;
}
-(void) setCropAspectRatio:(CGFloat) cropAspectRatio {
    _cropView.cropAspectRatio = cropAspectRatio;
}
-(void) setCropRect:(CGRect) cropRect {
    [self adjustCropRect];
}
-(void) setImageCropRect:(CGRect) imageCropRect {
    _cropView.imageCropRect = imageCropRect;
}
-(void)setRotationEnabled:(BOOL)rotationEnabled {
    _cropView.rotationGestureRecognizer.enabled = rotationEnabled;
}
-(CGAffineTransform) getRotationTransform {
    return _cropView.rotation;
}
-(CGRect) getZoomedCropRect {
    return _cropView.zoomedCropRect;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initialize];
    }
    return self;
}
- (void)loadView{
    UIView* contentView = [[UIView alloc] init];
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    contentView.backgroundColor = UIColor.blackColor;
    self.view = contentView;
    
    // Add CropView
    _cropView = [[CropView alloc] initWithFrame:contentView.bounds];
    [contentView addSubview:_cropView];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = false;
    self.navigationController.toolbar.translucent = false;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone  target:self action:@selector(done:)];
    
    if(self.toolbarItems == nil) {
        UIBarButtonItem* flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace  target:nil action:nil];
        UIBarButtonItem* constrainButton = [[UIBarButtonItem alloc] initWithTitle:@"Constrain" style:UIBarButtonItemStylePlain target:self action:@selector(constrain:)];
        self.toolbarItems = [NSArray arrayWithObjects:flexibleSpace, constrainButton, flexibleSpace, nil];
    }
    
    self.navigationController.toolbarHidden = _toolbarHidden;
    
    _cropView.image = _image;
    _cropView.rotationGestureRecognizer.enabled = _rotationEnabled;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if(_cropAspectRatio != 0) {
        _cropView.cropAspectRatio = _cropAspectRatio;
    }
    
    if(!CGRectEqualToRect(_cropRect, CGRectZero)) {
        [self adjustCropRect];
    }
    if(!CGRectEqualToRect(_imageCropRect, CGRectZero)) {
        _cropView.imageCropRect = _imageCropRect;
    }
    
    _cropView.keepAspectRatio = _keepAspectRatio;
}

- (void)resetCropRect {
    [_cropView resetCropRect];
}
- (void)resetCropRectAnimated:(BOOL)animated {
    [_cropView resetCropRectAnimated:animated];
}
- (void)cancel:(UIBarButtonItem *)sender {
    [_delegate cropViewControllerDidCancel:self];
}
- (void)done:(UIBarButtonItem *)sender {
    if(_cropView != nil){
        UIImage* image = _cropView.croppedImage;
        if(image != nil) {
            CGAffineTransform rotation =_cropView.rotation;
            if(CGAffineTransformEqualToTransform(rotation, CGAffineTransformIdentity)){
                return;
            }
            CGRect rect =_cropView.zoomedCropRect;
            if(CGRectEqualToRect(rect, CGRectNull)){
                return;
            }
            
            [_delegate cropViewController:self didFinishCroppingImage:image transform:rotation cropRect:rect];
        }
    }
}
- (void)constrain:(UIBarButtonItem *)sender {
    UIAlertController* actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* original = [UIAlertAction actionWithTitle:@"Original" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImage* image = self.cropView.image;
        if (image == nil) {
            return;
        }
        CGRect cropRect = self.cropView.cropRect;
        if (CGRectEqualToRect(cropRect, CGRectNull)) {
            return;
        }
        CGFloat width = image.size.width;
        CGFloat height = image.size.height;
        CGFloat ratio;
        if(width < height) {
            ratio = width / height;
            cropRect.size = CGSizeMake(cropRect.size.height * ratio, cropRect.size.height);
        } else {
            ratio = height / width;
            cropRect.size = CGSizeMake(cropRect.size.width, cropRect.size.width * ratio);
        }
        self.cropView.cropRect = cropRect;
    }];
    [actionSheet addAction:original];
    UIAlertAction* square = [UIAlertAction actionWithTitle:@"Square" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        CGFloat ratio = 1.0;
//            self.cropView?.cropAspectRatio = ratio
        CGRect cropRect = self.cropView.cropRect;
        if(!CGRectEqualToRect(cropRect, CGRectNull)){
            CGFloat width = cropRect.size.width;
            cropRect.size = CGSizeMake(width, width * ratio);
            self.cropView.cropRect = cropRect;
        }
    }];
    [actionSheet addAction:square];
    UIAlertAction* threeByTwo = [UIAlertAction actionWithTitle:@"3 x 2" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.cropView.cropAspectRatio = 2.0 / 3.0;
    }];
    [actionSheet addAction:threeByTwo];
    UIAlertAction* threeByFive = [UIAlertAction actionWithTitle:@"3 x 5" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.cropView.cropAspectRatio = 3.0 / 5.0;
    }];
    [actionSheet addAction:threeByFive];
    UIAlertAction* fourByThree = [UIAlertAction actionWithTitle:@"4 x 3" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        CGFloat ratio = 3.0 / 4.0;
        CGRect cropRect = self.cropView.cropRect;
        if(!CGRectEqualToRect(cropRect, CGRectNull)){
            CGFloat width = cropRect.size.width;
            cropRect.size = CGSizeMake(width, width * ratio);
            self.cropView.cropRect = cropRect;
        }
    }];
    [actionSheet addAction:fourByThree];
    UIAlertAction* fourBySix = [UIAlertAction actionWithTitle:@"4 x 6" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.cropView.cropAspectRatio = 4.0 / 6.0;
    }];
    [actionSheet addAction:fourBySix];
    UIAlertAction* fiveBySeven = [UIAlertAction actionWithTitle:@"5 x 7" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.cropView.cropAspectRatio = 5.0 / 7.0;
    }];
    [actionSheet addAction:fiveBySeven];
    UIAlertAction* eightByTen = [UIAlertAction actionWithTitle:@"8 x 10" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.cropView.cropAspectRatio = 8.0 / 10.0;
    }];
    [actionSheet addAction:eightByTen];
    UIAlertAction* widescreen = [UIAlertAction actionWithTitle:@"16 x 9" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        CGFloat ratio = 9.0 / 16.0;
        CGRect cropRect = self.cropView.cropRect;
        if(!CGRectEqualToRect(cropRect, CGRectNull)){
            CGFloat width = cropRect.size.width;
            cropRect.size = CGSizeMake(width, width * ratio);
            self.cropView.cropRect = cropRect;
        }
    }];
    [actionSheet addAction:widescreen];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:true completion:nil];
    }];
    [actionSheet addAction:cancel];
    
    UIPopoverPresentationController* popoverController = actionSheet.popoverPresentationController;
    if (popoverController != nil) {
        popoverController.barButtonItem = sender;
    }
    [self presentViewController:actionSheet animated:true completion:nil];
}

// MARK: - Private methods
- (void)adjustCropRect {
    _imageCropRect = CGRectZero;
    
    CGRect cropViewCropRect = _cropView.cropRect;
    if(CGRectEqualToRect(cropViewCropRect, CGRectNull)){
        return;
    }
    cropViewCropRect.origin.x += _cropRect.origin.x;
    cropViewCropRect.origin.y += _cropRect.origin.y;
    
    CGFloat minWidth = MIN(CGRectGetMaxX(cropViewCropRect) - CGRectGetMinX(cropViewCropRect), _cropRect.size.width);
    CGFloat minHeight = MIN(CGRectGetMaxY(cropViewCropRect) - CGRectGetMinY(cropViewCropRect), _cropRect.size.height);
    CGSize size = CGSizeMake(minWidth, minHeight);
    cropViewCropRect.size = size;
    _cropView.cropRect = cropViewCropRect;
}

@end
