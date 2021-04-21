//
//  UIImageView+Alpha.m
//  OSPhotoEditor
//
//  Created by Luis Bouça on 01/03/2021.
//  Copyright © 2021 André Gonçalves. All rights reserved.
//

#import "UIImageView+Alpha.h"

@implementation UIImageView (UIImageViewAlpha)

-(CGFloat)alphaAtPoint:(CGPoint)point{
    
    NSArray *pixel = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], nil];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    
    CGContextRef context = CGBitmapContextCreate(&pixel, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast);
    
    if(context == nil){
        return 0;
    }
    
    CGContextTranslateCTM(context,-point.x, -point.y);
    [[self layer] renderInContext:context];
    
    CGFloat floatAlpha = [pixel[3] doubleValue];
    
    return floatAlpha;
}

@end
