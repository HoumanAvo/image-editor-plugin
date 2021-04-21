//
//  PhotoEditor+Drawing.m
//  OSPhotoEditor
//
//  Created by Luis Bouça on 19/04/2021.
//  Copyright © 2021 André Gonçalves. All rights reserved.
//

#import "PhotoEditor+Drawing.h"
#import "PhotoEditor+StickersViewController.h"

@implementation PhotoEditorViewController (PhotoEditorDrawing)

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([self isDrawing]) {
        self.swiped = false;
        UITouch* touch = [[touches allObjects] firstObject];
        if(touch != nil){
            self.lastPoint = [touch locationInView:self.canvasImageView];
        }
    }else if(self.stickersVCIsVisible){
        UITouch* touch = [[touches allObjects] firstObject];
        if(touch != nil){
            CGPoint location = [touch locationInView:self.view];
            if(CGRectContainsPoint(self.stickersViewController.view.frame, location)){
                [self removeStickersView];
            }
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([self isDrawing]) {
        self.swiped = true;
        UITouch* touch = [[touches allObjects] firstObject];
        if(touch != nil){
            CGPoint currentPoint = [touch locationInView:self.canvasImageView];
            [self drawLineFrom:self.lastPoint toPoint:currentPoint];
            self.lastPoint = currentPoint;
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([self isDrawing]) {
        if (!self.swiped) {
            [self drawLineFrom:self.lastPoint toPoint:self.lastPoint];
        }
    }
}

-(void) drawLineFrom:(CGPoint) fromPoint toPoint:(CGPoint) toPoint {
    // 1
    CGSize canvasSize = self.canvasImageView.frame.size;
    UIGraphicsBeginImageContextWithOptions(canvasSize, false, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if(context != nil) {
        [self.canvasImageView.image drawInRect:CGRectMake(0, 0, canvasSize.width, canvasSize.height)];
        // 2
        CGContextMoveToPoint(context, fromPoint.x, fromPoint.y);
        CGContextAddLineToPoint(context, toPoint.x, toPoint.y);
        // 3
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineWidth(context, 5.0);
        CGContextSetStrokeColorWithColor(context, self.drawColor.CGColor);
        CGContextSetBlendMode(context, kCGBlendModeNormal);
        // 4
        CGContextStrokePath(context);
        // 5
        self.canvasImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
}

@end
