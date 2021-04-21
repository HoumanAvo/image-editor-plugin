//
//  PhotoEditor+Crop.h
//  OSPhotoEditor
//
//  Created by Luis Bouça on 13/04/2021.
//  Copyright © 2021 André Gonçalves. All rights reserved.
//

#ifndef PhotoEditor_Crop_h
#define PhotoEditor_Crop_h

#import "PhotoEditorViewController.h"
#import "CropViewController.h"

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface PhotoEditorViewController (PhotoEditorCrop)

-(void)cropViewController:(CropViewController*) controller didFinishCroppingImage:(UIImage*) image transform:(CGAffineTransform) transform cropRect:(CGRect)cropRect;

-(void) cropViewControllerDidCancel:(CropViewController*)controller;

@end
#endif /* PhotoEditor_Crop_h */
