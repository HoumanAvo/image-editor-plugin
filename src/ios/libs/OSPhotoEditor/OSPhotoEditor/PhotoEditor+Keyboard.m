//
//  PhotoEditor+Keyboard.m
//  OSPhotoEditor
//
//  Created by Luis Bouça on 19/04/2021.
//  Copyright © 2021 André Gonçalves. All rights reserved.
//

#import "PhotoEditor+Keyboard.h"

@implementation PhotoEditorViewController (PhotoEditorKeyboard)

-(void)keyboardDidShow:(NSNotification*) notification{
    if(self.isTyping) {
        self.doneButton.hidden = false;
        self.colorPickerView.hidden = false;
        [self hideToolbar:true];
    }
}

-(void)keyboardWillHide:(NSNotification*) notification {
    self.isTyping = false;
    self.doneButton.hidden = true;
    [self hideToolbar:false];
}

-(void)keyboardWillChangeFrame:(NSNotification*) notification{
    NSDictionary* userInfo = notification.userInfo;
    if(userInfo != nil) {
        NSValue* endFrameValue = (NSValue*)[userInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect endFrame = endFrameValue.CGRectValue;
        NSTimeInterval duration;
        if ([userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey]) {
            duration = ((NSNumber*)[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey]).doubleValue;
        }else{
            duration = 0;
        }
        NSNumber* animationCurveRawNSN = (NSNumber*)[userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey];
        int animationCurveRaw;
        if (animationCurveRawNSN != nil) {
            animationCurveRaw = animationCurveRawNSN.intValue;
        }else{
            animationCurveRaw = UIViewAnimationOptionCurveEaseInOut;
        }
        int animationCurve = animationCurveRaw;
        
        if (endFrame.origin.y >= UIScreen.mainScreen.bounds.size.height) {
            self.colorPickerViewBottomConstraint.constant = 0.0;
        } else {
            self.colorPickerViewBottomConstraint.constant = endFrame.size.height;
        }
        
        [UIView animateWithDuration:duration delay:[[NSDate date] timeIntervalSinceNow] options:animationCurve animations:^{
            [self.view layoutIfNeeded];
        } completion:nil];    }
}

@end
