//
//  GradientView.h
//  OSPhotoEditor
//
//  Created by Luis Bouça on 14/04/2021.
//  Copyright © 2021 André Gonçalves. All rights reserved.
//

#ifndef GradientView_h
#define GradientView_h

#import <UIKit/UIKit.h>

@interface GradientView : UIView

@property()IBInspectable BOOL gradientFromtop;
@property() CAGradientLayer* gradientLayer;

@end

#endif /* GradientView_h */
