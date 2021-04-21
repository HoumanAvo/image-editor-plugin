//
//  PhotoEditor+Controls.h
//  OSPhotoEditor
//
//  Created by Luis Bouça on 13/04/2021.
//  Copyright © 2021 André Gonçalves. All rights reserved.
//

#ifndef PhotoEditor_Controls_h
#define PhotoEditor_Controls_h

#import "PhotoEditorViewController.h"
#import "CropViewController.h"

@interface PhotoEditorViewController (PhotoEditorControls)
// MARK: - Control
typedef enum Control : NSUInteger {
    crop,
    sticker,
    draw,
    text,
    save,
    share,
    clear,
} Control;
//MARK: Top Toolbar

-(IBAction) cancelButtonTapped:(id)sender;
-(IBAction) cropButtonTapped:(UIButton*) sender;
-(IBAction) stickersButtonTapped:(id) sender;
-(IBAction) drawButtonTapped:(id) sender;
-(IBAction) textButtonTapped:(id) sender;
-(IBAction) doneButtonTapped:(id) sender;
//MARK: Bottom Toolbar

-(IBAction) saveButtonTapped:(id) sender;
-(IBAction) shareButtonTapped:(UIButton*) sender;
-(IBAction) clearButtonTapped:(id) sender;
-(IBAction) continueButtonPressed:(id) sender;
//MAKR: helper methods

-(void) image;
-(void) hideControls;
@end

#endif /* PhotoEditor_Controls_h */
