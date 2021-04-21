//
//  UIImage+Size.h
//  OSPhotoEditor
//
//  Created by Luis Bouça on 01/03/2021.
//  Copyright © 2021 André Gonçalves. All rights reserved.
//

#ifndef UIImage_Size_h
#define UIImage_Size_h

#import <UIKit/UIKit.h>

@interface UIImage (UIImageSize)
-(CGSize)suitableSizeHeightLimit:(CGFloat)heightLimit;
-(CGSize)suitableSizeWidthLimit:(CGFloat)widthLimit;
@end

#endif /* UIImage_Size_h */
