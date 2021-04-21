//
//  UIImage+Crop.h
//  OSPhotoEditor
//
//  Created by Luis Bouça on 01/03/2021.
//  Copyright © 2021 André Gonçalves. All rights reserved.
//

#ifndef UIImage_Crop_h
#define UIImage_Crop_h


#import <UIKit/UIKit.h>

@interface UIImage (UIImageCrop)
-(UIImage*)rotatedImageWithTransform:(CGAffineTransform)rotation croppedToRect:(CGRect)rect;
@end

#endif /* UIImage_Crop_h */
