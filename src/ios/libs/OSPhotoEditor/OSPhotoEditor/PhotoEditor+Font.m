//
//  PhotoEditor+Font.m
//  OSPhotoEditor
//
//  Created by Luis Bouça on 19/04/2021.
//  Copyright © 2021 André Gonçalves. All rights reserved.
//

#import "PhotoEditor+Font.h"

@implementation PhotoEditorViewController (PhotoEditorFont)

- (void)registerFont{
    NSBundle* bundle = [NSBundle bundleForClass:PhotoEditorViewController.self];
    NSURL* url = [bundle URLForResource:@"icomoon" withExtension:@"ttf"];
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((CFURLRef)url);
    if (fontDataProvider == nil) {
        return;
    }
    CGFontRef font = CGFontCreateWithDataProvider(fontDataProvider);
    if (font == nil) {
        return;
    }
    CFErrorRef* error = NULL;
    CTFontManagerRegisterGraphicsFont(font,error);
}

@end
