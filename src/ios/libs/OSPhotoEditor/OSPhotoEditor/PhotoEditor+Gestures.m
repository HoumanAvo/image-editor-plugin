//
//  PhotoEditor+Gestures.m
//  OSPhotoEditor
//
//  Created by Luis Bouça on 19/04/2021.
//  Copyright © 2021 André Gonçalves. All rights reserved.
//

#import "PhotoEditor+Gestures.h"
#import "PhotoEditor+StickersViewController.h"

@implementation PhotoEditorViewController (PhotoEditorGestures)

/**
 UIPanGestureRecognizer - Moving Objects
 Selecting transparent parts of the imageview won't move the object
 */
- (void)panGesture:(UIPanGestureRecognizer *)recognizer{
    UIView* view = recognizer.view;
    if(view !=nil){
        if ([view isKindOfClass:UIImageView.class]) {
            if (recognizer.state == UIGestureRecognizerStateBegan) {
                for (UIImageView* imageView in [self subImageViews:self.canvasImageView]) {
                    CGPoint location = [recognizer locationInView:imageView];
                    CGFloat alpha = [imageView alphaAtPoint:location];
                    if (alpha >0) {
                        self.imageViewToPan = imageView;
                        break;
                    }
                }
            }
            if (self.imageViewToPan != nil) {
                [self moveView:self.imageViewToPan recognizer:recognizer];
            }
        }else{
            [self moveView:view recognizer:recognizer];
        }
    }
}

/**
 UIPinchGestureRecognizer - Pinching Objects
 If it's a UITextView will make the font bigger so it doen't look pixlated
 */
- (void)pinchGesture:(UIPinchGestureRecognizer *)recognizer{
    UIView* view = recognizer.view;
    if(view !=nil){
        if ([view isKindOfClass:UITextView.class]) {
            UITextView *textView = (UITextView*)view;
            if (textView.font.pointSize*recognizer.scale <90) {
                UIFont* font = [UIFont fontWithName:textView.font.fontName size:textView.font.pointSize * recognizer.scale];
                textView.font = font;
            }
            CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(UIScreen.mainScreen.bounds.size.width, CGFLOAT_MAX)];
            CGRect bounds = textView.bounds;
            bounds.size = CGSizeMake(textView.intrinsicContentSize.width, sizeToFit.height);
            textView.bounds = bounds;
        } else {
            view.transform = CGAffineTransformScale(view.transform, recognizer.scale, recognizer.scale);
        }
        recognizer.scale = 1;
    }
}

/**
 UIRotationGestureRecognizer - Rotating Objects
 */
- (void)rotationGesture:(UIRotationGestureRecognizer *)recognizer{
    UIView* view = recognizer.view;
    if(view !=nil){
        view.transform = CGAffineTransformRotate(view.transform, recognizer.rotation);
        recognizer.rotation = 0;
    }
}

/**
 UITapGestureRecognizer - Taping on Objects
 Will make scale scale Effect
 Selecting transparent parts of the imageview won't move the object
 */
- (void)tapGesture:(UITapGestureRecognizer *)recognizer{
    UIView* view = recognizer.view;
    if(view !=nil){
        if ([view isKindOfClass:UIImageView.class]) {
            for (UIImageView* imageView in [self subImageViews:self.canvasImageView]) {
                CGPoint location = [recognizer locationInView:imageView];
                CGFloat alpha = [imageView alphaAtPoint:location];
                if (alpha>0) {
                    [self scaleEffect:imageView];
                    break;
                }
            }
        }else{
            [self scaleEffect:view];
        }
    }
}

/*
 Support Multiple Gesture at the same time
 */
-(BOOL)gestureRecognizer:(UIGestureRecognizer*) gestureRecognizer shouldRecognizeSimultaneouslyWith:(UIGestureRecognizer*) otherGestureRecognizer {
    return true;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer*) gestureRecognizer shouldRequireFailureOf:(UIGestureRecognizer*) otherGestureRecognizer{
    return false;
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer*) gestureRecognizer shouldBeRequiredToFailBy:(UIGestureRecognizer*) otherGestureRecognizer {
    return false;
}

-(void) screenEdgeSwiped:(UIScreenEdgePanGestureRecognizer*) recognizer {
    if(recognizer.state == UIGestureRecognizerStateRecognized){
        if(!self.stickersVCIsVisible) {
            [self addStickersViewController];
        }
    }
}
- (BOOL)prefersStatusBarHidden{
    return true;
}

/**
 Scale Effect
 */
-(void) scaleEffect:(UIView*)view {
    [view.superview bringSubviewToFront:view];
    if (@available(iOS 10.0, *)) {
        UIImpactFeedbackGenerator* generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleHeavy];
        [generator impactOccurred];
    }
    
    CGAffineTransform previouTransform = view.transform;
    [UIView animateWithDuration:0.2 animations:^{
        view.transform = CGAffineTransformScale(view.transform, 1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            view.transform = previouTransform;
        }];
    }];
}

/**
 Moving Objects
 delete the view if it's inside the delete view
 Snap the view back if it's out of the canvas
 */
- (void)moveView:(UIView *)view recognizer:(UIPanGestureRecognizer *)recognizer{
    [self hideToolbar:true];
    self.deleteView.hidden = false;
    
    [view.superview bringSubviewToFront:view];
    CGPoint pointToSuperView = [recognizer locationInView:self.view];

    view.center = CGPointMake(view.center.x + [recognizer translationInView:self.canvasImageView].x,
                              view.center.y + [recognizer translationInView:self.canvasImageView].y);
    
    [recognizer setTranslation:CGPointZero inView:self.canvasImageView];
    
    CGPoint previousPoint = self.lastPanPoint;
    //View is going into deleteView
    if(CGRectContainsPoint(self.deleteView.frame,pointToSuperView) && !CGRectContainsPoint(self.deleteView.frame,previousPoint)) {
        if (@available(iOS 10.0, *)) {
            UIImpactFeedbackGenerator* generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleHeavy];
            [generator impactOccurred];
        }
        [UIView animateWithDuration:0.3 animations:^{
            view.transform = CGAffineTransformScale(view.transform, 0.25, 0.25);
            view.center = [recognizer locationInView:self.canvasImageView];
        }];
    }
        //View is going out of deleteView
    else if(CGRectContainsPoint(self.deleteView.frame,previousPoint) && !CGRectContainsPoint(self.deleteView.frame,pointToSuperView)) {
        //Scale to original Size
        [UIView animateWithDuration:0.3 animations:^{
            view.transform = CGAffineTransformScale(view.transform, 4, 4);
            view.center = [recognizer locationInView:self.canvasImageView];
        }];
    }
    self.lastPanPoint = pointToSuperView;
    
    if(recognizer.state == UIGestureRecognizerStateEnded) {
        self.imageViewToPan = nil;
        self.lastPanPoint = CGPointZero;

        if(self.isTyping) {
            [self hideToolbar:true];
        } else {
            [self hideToolbar:false];
        }
        
        self.deleteView.hidden = true;

        CGPoint point = [recognizer locationInView:self.view];
        
        if(CGRectContainsPoint(self.deleteView.frame,point)) { // Delete the view
            [view removeFromSuperview];
            if(@available(iOS 10.0, *)) {
                UINotificationFeedbackGenerator* generator = [[UINotificationFeedbackGenerator alloc] init];
                [generator notificationOccurred:UINotificationFeedbackTypeSuccess];
            }
        } else if(CGRectContainsPoint(self.canvasImageView.bounds,self.view.center)){ //Snap the view back to canvasImageView
            [UIView animateWithDuration:0.3 animations:^{
                view.center = self.canvasImageView.center;
            }];
        }
    }
}
- (NSArray<UIImageView*>*)subImageViews:(UIView *)view {
    NSMutableArray<UIImageView*>* imageviews = [[NSMutableArray alloc] init];
    for(UIView* imageView in view.subviews) {
        if([imageView isKindOfClass:UIImageView.class]){
            [imageviews addObject:(UIImageView*)imageView];
        }
    }
    return imageviews;
}

@end
