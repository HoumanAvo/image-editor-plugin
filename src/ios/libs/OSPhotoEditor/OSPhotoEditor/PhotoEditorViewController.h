//
//  PhotoEditorViewController.h
//  OSPhotoEditor
//
//  Created by Luis Bouça on 13/04/2021.
//  Copyright © 2021 André Gonçalves. All rights reserved.
//

#ifndef PhotoEditorViewController_h
#define PhotoEditorViewController_h

#import <UIKit/UIKit.h>
#import "Protocols.h"
#import "ColorsCollectionViewDelegate.h"
#import "StickersViewController.h"
#import <CoreText/CoreText.h>
#import "UIImage+Size.h"
#import "ColorCollectionViewCell.h"

@interface PhotoEditorViewController : UIViewController<StickersViewControllerDelegate,UITextViewDelegate,ColorDelegate>
/** holding the 2 imageViews original image and drawing & stickers */
@property(weak)IBOutlet UIView* canvasView;
//To hold the image
@property()IBOutlet UIImageView* imageView;
@property(weak)IBOutlet NSLayoutConstraint* imageViewHeightConstraint;
//To hold the drawings and stickers
@property(weak)IBOutlet UIImageView* canvasImageView;

@property(weak)IBOutlet UIView* topToolbar;
@property(weak)IBOutlet UIView* bottomToolbar;

@property(weak)IBOutlet UIView* topGradient;
@property(weak)IBOutlet UIView* bottomGradient;

@property(weak)IBOutlet UIButton* doneButton;
@property(weak)IBOutlet UIView* deleteView;
@property(weak)IBOutlet UICollectionView* colorsCollectionView;
@property(weak)IBOutlet UIView* colorPickerView;
@property(weak)IBOutlet NSLayoutConstraint* colorPickerViewBottomConstraint;

//Controls
@property(weak)IBOutlet UIButton* cropButton;
@property(weak)IBOutlet UIButton* stickerButton;
@property(weak)IBOutlet UIButton* drawButton;
@property(weak)IBOutlet UIButton* textButton;
@property(weak)IBOutlet UIButton* saveButton;
@property(weak)IBOutlet UIButton* shareButton;
@property(weak)IBOutlet UIButton* clearButton;

@property() UIImage* image;
/**
 Array of Stickers -UIImage- that the user will choose from
 */
@property() NSMutableArray* stickers;//UIImage[]
/**
 Array of Colors that will show while drawing or typing
 */
@property() NSMutableArray* colors;//UIColor[]

@property() id<PhotoEditorDelegate> photoEditorDelegate;
@property() ColorsCollectionViewDelegate* colorsCollectionViewDelegate;

// list of controls to be hidden
@property() NSMutableArray* hiddenControls;//[control] = []

@property() BOOL stickersVCIsVisible;
@property() UIColor* drawColor;
@property() UIColor* textColor;
@property() BOOL isDrawing;
@property() CGPoint lastPoint;
@property() BOOL swiped;
@property() CGPoint lastPanPoint;
@property() CGAffineTransform lastTextViewTransform;
@property() CGPoint lastTextViewTransCenter;
@property() UIFont* lastTextViewFont;
@property() UITextView* activeTextView;
@property() UIImageView* imageViewToPan;
@property() BOOL isTyping;


@property() StickersViewController* stickersViewController;

-(void) configureCollectionView;
-(void) hideToolbar:(BOOL) hide;
-(void) setImageView:(UIImage*) image;
-(void)addGestures:(UIView *)view;
-(void) didSelectColor:(UIColor*) color;
@end
#endif /* PhotoEditorViewController_h */
