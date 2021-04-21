//
//  PhotoEditor+Gestures.h
//  OSPhotoEditor
//
//  Created by Luis Bouça on 19/04/2021.
//  Copyright © 2021 André Gonçalves. All rights reserved.
//

#ifndef PhotoEditor_Gestures_h
#define PhotoEditor_Gestures_h

#import "PhotoEditorViewController.h"
#import "UIImageView+Alpha.h"

@interface PhotoEditorViewController (PhotoEditorGestures)
/**
 UIPanGestureRecognizer - Moving Objects
 Selecting transparent parts of the imageview won't move the object
 */
-(void) panGesture:(UIPanGestureRecognizer*) recognizer;

/**
 UIPinchGestureRecognizer - Pinching Objects
 If it's a UITextView will make the font bigger so it doen't look pixlated
 */
-(void) pinchGesture:(UIPinchGestureRecognizer*) recognizer;

/**
 UIRotationGestureRecognizer - Rotating Objects
 */
-(void) rotationGesture:(UIRotationGestureRecognizer*) recognizer;

/**
 UITapGestureRecognizer - Taping on Objects
 Will make scale scale Effect
 Selecting transparent parts of the imageview won't move the object
 */
-(void) tapGesture:(UITapGestureRecognizer*) recognizer;

/*
 Support Multiple Gesture at the same time
 */
-(BOOL)gestureRecognizer:(UIGestureRecognizer*) gestureRecognizer shouldRecognizeSimultaneouslyWith:(UIGestureRecognizer*) otherGestureRecognizer;
-(BOOL)gestureRecognizer:(UIGestureRecognizer*) gestureRecognizer shouldRequireFailureOf:(UIGestureRecognizer*) otherGestureRecognizer;
-(BOOL)gestureRecognizer:(UIGestureRecognizer*) gestureRecognizer shouldBeRequiredToFailBy:(UIGestureRecognizer*) otherGestureRecognizer;

-(void)screenEdgeSwiped:(UIScreenEdgePanGestureRecognizer*) recognizer;

/**
 Scale Effect
 */
-(void) scaleEffect:(UIView*) view;

/**
 Moving Objects
 delete the view if it's inside the delete view
 Snap the view back if it's out of the canvas
 */

-(void) moveView:(UIView*) view recognizer:(UIPanGestureRecognizer*)recognizer;

-(NSArray<UIImageView*>*) subImageViews:(UIView*) view;
@end

#endif /* PhotoEditor_Gestures_h */
