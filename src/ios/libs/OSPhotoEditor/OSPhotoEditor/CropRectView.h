//
//  CropRectView.h
//  OSPhotoEditor
//
//  Created by Luis Bouça on 01/03/2021.
//  Copyright © 2021 André Gonçalves. All rights reserved.
//

#ifndef CropRectView_h
#define CropRectView_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ResizeControl.h"

@class CropRectView;

@protocol CropRectViewDelegate

-(void) cropRectViewDidBeginEditing:(CropRectView*)view;
-(void) cropRectViewDidChange:(CropRectView*)view;
-(void) cropRectViewDidEndEditing:(CropRectView*)view;

@end

@interface CropRectView : UIView<ResizeControlDelegate>

@property(weak)id<CropRectViewDelegate> delegate;
@property(nonatomic) BOOL showsGridMajor;
@property(nonatomic) BOOL showsGridMinor;
@property(nonatomic) BOOL keepAspectRatio;
    
@property() UIImageView* resizeImageView;
@property() ResizeControl* topLeftCornerView;
@property() ResizeControl* topRightCornerView;
@property() ResizeControl* bottomLeftCornerView;
@property() ResizeControl* bottomRightCornerView;
@property() ResizeControl* topEdgeView;
@property() ResizeControl* leftEdgeView;
@property() ResizeControl* rightEdgeView;
@property() ResizeControl* bottomEdgeView;
@property() CGRect initialRect;
@property() CGFloat fixedAspectRatio;
    
-(void) initialize;

-(void) setShowsGridMajor:(BOOL)showsGridMajor;
-(void) setShowsGridMinor:(BOOL)showsGridMinor;
-(void) setKeepAspectRatio:(BOOL)keepAspectRatio;
    
    
-(void) enableResizing:(BOOL) enabled;

// MARK: - ResizeControl delegate methods
-(void) resizeControlDidBeginResizing:(ResizeControl*) control;
    
-(void) resizeControlDidResize:(ResizeControl*) control;
    
-(void) resizeControlDidEndResizing:(ResizeControl*) control;
    
-(CGRect) cropRectWithResizeControlView:(ResizeControl*) resizeControl;
    
-(CGRect) constrainedRectWithRectBasisOfWidth:(CGRect) frame;
    
-(CGRect) constrainedRectWithRectBasisOfHeight:(CGRect) frame;

@end
#endif /* CropRectView_h */
