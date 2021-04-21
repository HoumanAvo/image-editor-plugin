//
//  UIImageView+Alpha.h
//  OSPhotoEditor
//
//  Created by Luis Bouça on 01/03/2021.
//  Copyright © 2021 André Gonçalves. All rights reserved.
//

#ifndef UIImageView_Alpha_h
#define UIImageView_Alpha_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImageView (UIImageViewAlpha)
-(CGFloat)alphaAtPoint:(CGPoint)point;
@end

#endif /* UIImageView_Alpha_h */
