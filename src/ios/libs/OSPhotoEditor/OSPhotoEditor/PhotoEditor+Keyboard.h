//
//  PhotoEditor+Keyboard.h
//  OSPhotoEditor
//
//  Created by Luis Bouça on 19/04/2021.
//  Copyright © 2021 André Gonçalves. All rights reserved.
//

#ifndef PhotoEditor_Keyboard_h
#define PhotoEditor_Keyboard_h

#import "PhotoEditorViewController.h"

@interface PhotoEditorViewController (PhotoEditorKeyboard)

-(void)keyboardDidShow:(NSNotification*) notification;

-(void)keyboardWillHide:(NSNotification*) notification;

-(void)keyboardWillChangeFrame:(NSNotification*) notification;

@end
#endif /* PhotoEditor_Keyboard_h */
