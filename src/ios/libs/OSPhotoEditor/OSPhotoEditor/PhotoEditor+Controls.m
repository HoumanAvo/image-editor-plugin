//
//  PhotoEditor+Controls.m
//  OSPhotoEditor
//
//  Created by Luis Bouça on 13/04/2021.
//  Copyright © 2021 André Gonçalves. All rights reserved.
//

#import "PhotoEditor+Controls.h"
#import "PhotoEditor+StickersViewController.h"
#import "PhotoEditor+Gestures.h"
#import "UIView+Image.h"


@implementation PhotoEditorViewController (PhotoEditorControls)

//MARK: Top Toolbar

-(IBAction) cancelButtonTapped:(id)sender{
    [self.photoEditorDelegate canceledEditing];
    [self dismissViewControllerAnimated:true completion:nil];
}

-(IBAction) cropButtonTapped:(UIButton*) sender {
    CropViewController* controller = [[CropViewController alloc] init];
    controller.delegate = self;
    controller.image = self.image;
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navController animated:true completion:nil];
}

-(IBAction) stickersButtonTapped:(id) sender{
    [self addStickersViewController];
}

-(IBAction) drawButtonTapped:(id) sender{
    self.isDrawing = true;
    self.canvasImageView.userInteractionEnabled = false;
    self.doneButton.hidden = false;
    self.colorPickerView.hidden = false;
    [self hideToolbar:true];
}

-(IBAction) textButtonTapped:(id) sender{
    self.isTyping = true;
   UITextView* textView = [[UITextView alloc] initWithFrame:CGRectMake(0, self.canvasImageView.center.y,
                                                                  UIScreen.mainScreen.bounds.size.width, 30)];
    
    textView.textAlignment = NSTextAlignmentCenter;
    textView.font = [UIFont fontWithName:@"Helvetica" size:30];
    textView.textColor = self.textColor;
    textView.layer.shadowColor = UIColor.blackColor.CGColor;
    textView.layer.shadowOffset = CGSizeMake(1.0, 0.0);
    textView.layer.shadowOpacity = 0.2;
    textView.layer.shadowRadius = 1.0;
    textView.layer.backgroundColor = UIColor.clearColor.CGColor;
    textView.autocorrectionType = UITextAutocorrectionTypeNo;
    textView.scrollEnabled = false;
    textView.delegate = self;
    [self.canvasImageView addSubview:textView];
    [self addGestures:textView];
    [textView becomeFirstResponder];
}

-(IBAction) doneButtonTapped:(id) sender{
    [self.view endEditing:true];
    self.doneButton.hidden = true;
    self.colorPickerView.hidden = true;
    self.canvasImageView.userInteractionEnabled = true;
    [self hideToolbar:false];
    self.isDrawing = false;
}

//MARK: Bottom Toolbar

-(IBAction) saveButtonTapped:(id) sender{
    UIImageWriteToSavedPhotosAlbum([self.canvasView toImage],self, @selector(image), nil);
}

-(IBAction) shareButtonTapped:(UIButton*) sender{
    UIActivityViewController* activity = [[UIActivityViewController alloc] initWithActivityItems:[[self canvasView] toImage] applicationActivities:nil];
    [self presentViewController:activity animated:true completion:nil];
}

-(IBAction) clearButtonTapped:(id) sender{
   //clear drawing
    self.canvasImageView.image = nil;
   //clear stickers and textviews
    for (UIView* subview in self.canvasImageView.subviews) {
        [subview removeFromSuperview];
    }
}

-(IBAction) continueButtonPressed:(id) sender {
    UIImage* img = [self.canvasView toImage];
    [self.photoEditorDelegate doneEditing:img];
    [self dismissViewControllerAnimated:true completion:nil];
}

//MAKR: helper methods

-(void) image{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Image Saved" message:@"Image successfully saved to Photos Library" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:true completion:nil];
}

-(void) hideControls{
    for (NSNumber* number in self.hiddenControls) {
        Control control = [number intValue];
        switch (control) {
            case clear:
                self.clearButton.hidden = true;
                break;
            case crop:
                self.cropButton.hidden = true;
                break;
            case draw:
                self.drawButton.hidden = true;
                break;
            case save:
                self.saveButton.hidden = true;
                break;
            case share:
                self.shareButton.hidden = true;
                break;
            case sticker:
                self.stickerButton.hidden = true;
                break;
            case text:
                self.stickerButton.hidden = true;
                break;
            default:
                break;
        }
    }
}

@end
