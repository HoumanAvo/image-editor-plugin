//
//  PhotoEditor+StickersViewController.m
//  OSPhotoEditor
//
//  Created by Luis Bouça on 19/04/2021.
//  Copyright © 2021 André Gonçalves. All rights reserved.
//

#import "PhotoEditor+StickersViewController.h"

@implementation PhotoEditorViewController (PhotoEditorStickers)

-(void)addStickersViewController{
    self.stickersVCIsVisible = true;
    [self hideToolbar:true];
    self.canvasImageView.userInteractionEnabled = false;
    self.stickersViewController.stickersViewControllerDelegate = self;
    for (UIImage* image in self.stickers) {
        [self.stickersViewController.stickers addObject:image];
    }
    [self addChildViewController:self.stickersViewController];
    [self.view addSubview:self.stickersViewController.view];
    [self.stickersViewController didMoveToParentViewController:self];
    CGFloat height = self.view.frame.size.height;
    CGFloat width  = self.view.frame.size.width;
    self.stickersViewController.view.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame) , width, height);
}
-(void)removeStickersView{
    self.stickersVCIsVisible = false;
    self.canvasImageView.userInteractionEnabled = true;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGRect frame = self.stickersViewController.view.frame;
        frame.origin.y = CGRectGetMaxY(UIScreen.mainScreen.bounds);
        self.stickersViewController.view.frame = frame;
    } completion:^(BOOL finished) {
        [self.stickersViewController.view removeFromSuperview];
        [self.stickersViewController removeFromParentViewController];
        [self hideToolbar:false];
    }];
}

@end
