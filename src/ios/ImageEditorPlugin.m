//
//  ImageEditorPlugin.m
//  test
//
//  Created by Luis Bouça on 20/04/2021.
//

#import "ImageEditorPlugin.h"

@implementation UIImage (UIImageBase64)

-(NSString*) toBase64{
    NSData* imageData;
    imageData = UIImageJPEGRepresentation(self, 1);//compression
    return [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

@end

@implementation ImageEditorPlugin

-(void) editImage:(CDVInvokedUrlCommand*) command{
    self.callbackId = command.callbackId;
    
    UIImagePickerControllerSourceType sourceType = (UIImagePickerControllerSourceType)UIImagePickerControllerSourceTypePhotoLibrary;
    NSString* sourceTypeString = command.arguments[0];
    if ( [sourceTypeString isEqualToString:@"sourcetype"]){
        NSString* type = command.arguments[1];
        if ([type isEqualToString:@"camera"]){
            sourceType = (UIImagePickerControllerSourceType)UIImagePickerControllerSourceTypeCamera;
        }
        
        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = sourceType;
        
        [self.viewController presentViewController:picker animated:true completion:^{
            //                pluginResult = CDVPluginResult(
            //                    status: CDVCommandStatus_OK,
            //                    messageAs: ""
            //                )
        }];
        
    } else if ([sourceTypeString isEqualToString:@"base64"]) {
        NSString* strBase64 = command.arguments[1];
        
        if (![strBase64 isEqualToString:@""]){
            
            NSData* dataDecoded = [[NSData alloc] initWithBase64EncodedString:strBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
            [self presentImageEditorViewController:[UIImage imageWithData:dataDecoded]];
        }
        /*self.commandDelegate!.send(
         pluginResult,
         callbackId: command.callbackId
         )*/
    } else {
        printf("You must set the first argument of the editImage function as sourcetype or base64");
        
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

- (void)presentImageEditorViewController:(UIImage *)image{
    PhotoEditorViewController *photoEditor = [[PhotoEditorViewController alloc] initWithNibName:@"PhotoEditorViewController" bundle:[NSBundle bundleForClass:PhotoEditorViewController.self]];
    photoEditor.modalPresentationStyle = UIModalPresentationFullScreen;
    photoEditor.photoEditorDelegate = self;
    photoEditor.image = image;
    //Colors for drawing and Text, If not set default values will be used
    //photoEditor.colors = [.red, .blue, .green]
    
    //Stickers that the user will choose from to add on the image
    /*for i in 0...10 {
        photoEditor.stickers.append(UIImage(named: i.description )!)
    }*/
    
    //To hide controls - array of enum control
    //photoEditor.hiddenControls = [.crop, .draw, .share]
    
    [self.viewController presentViewController:photoEditor animated:true completion:nil];
}

- (void)doneEditing:(UIImage *)image{
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[image toBase64]];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
}
- (void)canceledEditing{
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    
    UIImage* image = [info valueForKey:UIImagePickerControllerOriginalImage];
    if(image == nil){
        [picker dismissViewControllerAnimated:true completion:nil];
        return;
    }
    [picker dismissViewControllerAnimated:true completion:nil];
    [self presentImageEditorViewController:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.viewController dismissViewControllerAnimated:true completion:nil];
}


@end
