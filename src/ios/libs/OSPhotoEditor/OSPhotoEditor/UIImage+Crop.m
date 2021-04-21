//
//  UIImage+Crop.m
//  OSPhotoEditor
//
//  Created by Luis Bouça on 01/03/2021.
//  Copyright © 2021 André Gonçalves. All rights reserved.
//

#import "UIImage+Crop.h"

@implementation UIImage (UIImageCrop)

-(UIImage*)rotatedImageWithTransform:(CGAffineTransform)rotation croppedToRect:(CGRect)rect {
    UIImage *rotatedImage = [self rotatedImageWithTransform:rotation];
    
    CGFloat scale = rotatedImage.scale;
    CGRect cropRect = CGRectApplyAffineTransform(rect,CGAffineTransformScale(CGAffineTransformIdentity, scale, scale));
    
    CGImageRef croppedImage = CGImageCreateWithImageInRect(rotatedImage.CGImage,cropRect);
    UIImage * image = [[UIImage alloc] initWithCGImage:croppedImage scale:self.scale orientation:rotatedImage.imageOrientation];
    return image;
}

-(UIImage*)rotatedImageWithTransform:(CGAffineTransform)transform{
    UIGraphicsBeginImageContextWithOptions([self size],true,[self scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context,[self size].width / 2.0, [self size].height / 2.0);
    CGContextConcatCTM(context,transform);
    CGContextTranslateCTM(context,[self size].width / -2.0, [self size].height / -2.0);
    
    [self drawInRect:CGRectMake(0.0, 0.0, [self size].width, [self size].height)];
    UIImage * rotatedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return rotatedImage;
}

@end
