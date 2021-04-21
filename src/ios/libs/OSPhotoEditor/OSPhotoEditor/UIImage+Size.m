//
//  UIImage+Size.m
//  OSPhotoEditor
//
//  Created by Luis Bouça on 01/03/2021.
//  Copyright © 2021 André Gonçalves. All rights reserved.
//

#import "UIImage+Size.h"

@implementation UIImage (UIImageSize)

-(CGSize)suitableSizeHeightLimit:(CGFloat)heightLimit{
    CGFloat width = (heightLimit / self.size.height) * self.size.width;
    return CGSizeMake(width, heightLimit);
}
-(CGSize)suitableSizeWidthLimit:(CGFloat)widthLimit {
    CGFloat height = (widthLimit / self.size.width) * self.size.height;
    return CGSizeMake(widthLimit,height);
}

@end
