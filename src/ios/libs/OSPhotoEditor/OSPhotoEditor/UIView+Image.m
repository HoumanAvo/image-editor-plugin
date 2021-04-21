//
//  UIView+Image.m
//  OSPhotoEditor
//
//  Created by Luis Bouça on 01/03/2021.
//  Copyright © 2021 André Gonçalves. All rights reserved.
//

#import "UIView+Image.h"

@implementation UIView (UIViewImage)

-(UIImage*) toImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:false];
    UIImage* snapshotImageFromMyView = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshotImageFromMyView;
}

@end
