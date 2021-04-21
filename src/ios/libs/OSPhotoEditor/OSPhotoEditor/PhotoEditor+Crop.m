//
//  PhotoEditor+Crop.m
//  OSPhotoEditor
//
//  Created by Luis Bouça on 13/04/2021.
//  Copyright © 2021 André Gonçalves. All rights reserved.
//

#import "PhotoEditor+Crop.h"

@implementation PhotoEditorViewController (PhotoEditorCrop)


-(void)cropViewController:(CropViewController*) controller didFinishCroppingImage:(UIImage*) image transform:(CGAffineTransform) transform cropRect:(CGRect)cropRect {
    [controller dismissViewControllerAnimated:true completion:nil];
    [self setImageView:image];
}

-(void) cropViewControllerDidCancel:(CropViewController*)controller {
    [controller dismissViewControllerAnimated:true completion:nil];
}

@end
