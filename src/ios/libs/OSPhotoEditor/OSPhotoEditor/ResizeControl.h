//
//  ResizeControl.h
//  OSPhotoEditor
//
//  Created by Luis Bouça on 13/04/2021.
//  Copyright © 2021 André Gonçalves. All rights reserved.
//

#ifndef ResizeControl_h
#define ResizeControl_h

#import <UIKit/UIKit.h>

@class ResizeControl;

@protocol ResizeControlDelegate

-(void) resizeControlDidBeginResizing:(ResizeControl*) control;
-(void) resizeControlDidResize:(ResizeControl*) control;
-(void) resizeControlDidEndResizing:(ResizeControl*) control;

@end


@interface ResizeControl : UIView

@property(weak)id<ResizeControlDelegate> delegate;
@property() CGPoint translation;
@property() BOOL enabled;
@property() CGPoint startPoint;
    
-(void)initialize;
    
-(void)handlePan:(UIPanGestureRecognizer*) gestureRecognizer;

@end

#endif /* ResizeControl_h */
