//
//  ImageEditorPlugin.h
//  test
//
//  Created by Luis Bouça on 20/04/2021.
//

#ifndef ImageEditorPlugin_h
#define ImageEditorPlugin_h

#import <Cordova/CDVPlugin.h>
#import <Cordova/CDVInvokedUrlCommand.h>
#import <UIKit/UIKit.h>
#import <OSPhotoEditor/OSPhotoEditor.h>

@interface UIImage (UIImageBase64)

-(NSString*)toBase64;

@end

@interface ImageEditorPlugin : CDVPlugin<PhotoEditorDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(weak)IBOutlet UIImageView* imageView;
@property()IBOutlet NSString* callbackId;

- (void)editImage:(CDVInvokedUrlCommand*)command;
- (void)presentImageEditorViewController:(UIImage*)image;

@end

#endif /* ImageEditorPlugin_h */
