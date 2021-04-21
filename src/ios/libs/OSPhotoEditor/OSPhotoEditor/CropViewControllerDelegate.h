//
//  CropViewControllerDelegate.h
//  OSPhotoEditor
//
//  Created by Luis Bouça on 13/04/2021.
//  Copyright © 2021 André Gonçalves. All rights reserved.
//

#ifndef CropViewControllerDelegate_h
#define CropViewControllerDelegate_h

@protocol CropViewControllerDelegate

-(void)cropViewController:(CropViewController) controller didFinishCroppingImage:(UIImage*) image transform:(CGAffineTransform) transform cropRect:(CGRect) cropRect;
-(void)cropViewControllerDidCancel:(CropViewController) controller;

@end

#endif /* CropViewControllerDelegate_h */
