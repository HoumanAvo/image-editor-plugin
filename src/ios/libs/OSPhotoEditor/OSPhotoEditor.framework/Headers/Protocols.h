//
//  Protocols.h
//  OSPhotoEditor
//
//  Created by Luis Bouça on 01/03/2021.
//  Copyright © 2021 André Gonçalves. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 - doneEditing
 - canceledEditing
 */
@protocol PhotoEditorDelegate

-(void) doneEditing:(UIImage*)image;
    
-(void) canceledEditing;

@end


/**
 - didSelectView
 - didSelectImage
 - stickersViewDidDisappear
 */
@protocol StickersViewControllerDelegate
    /**
     - Parameter view: selected view from StickersViewController
     */
-(void) didSelectView:(UIView*)view;
    /**
     - Parameter image: selected Image from StickersViewController
     */
-(void) didSelectImage:(UIImage*)image;
    /**
     StickersViewController did Disappear
     */
-(void) stickersViewDidDisappear;

@end

/**
 - didSelectColor
 */
@protocol ColorDelegate

-(void) didSelectColor:(UIColor*)color;

@end
