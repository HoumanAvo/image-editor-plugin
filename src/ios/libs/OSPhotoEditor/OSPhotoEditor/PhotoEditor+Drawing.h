//
//  PhotoEditor+Drawing.h
//  OSPhotoEditor
//
//  Created by Luis Bouça on 19/04/2021.
//  Copyright © 2021 André Gonçalves. All rights reserved.
//

#ifndef PhotoEditor_Drawing_h
#define PhotoEditor_Drawing_h

#import "PhotoEditorViewController.h"

@interface PhotoEditorViewController (PhotoEditorDrawing)

-(void)drawLineFrom:(CGPoint) fromPoint toPoint:(CGPoint) toPoint;
@end

#endif /* PhotoEditor_Drawing_h */
