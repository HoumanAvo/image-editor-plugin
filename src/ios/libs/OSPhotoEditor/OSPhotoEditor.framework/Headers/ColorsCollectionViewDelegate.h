//
//  ColorsCollectionViewDelegate.h
//  OSPhotoEditor
//
//  Created by Luis Bouça on 26/02/2021.
//  Copyright © 2021 André Gonçalves. All rights reserved.
//

#ifndef ColorsCollectionViewDelegate_h
#define ColorsCollectionViewDelegate_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Protocols.h"

@interface ColorsCollectionViewDelegate : NSObject<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property()id<ColorDelegate> colorDelegate;
@property()NSArray* colors;
@property()id<StickersViewControllerDelegate> stickersViewControllerDelegate;

@end

#endif /* ColorsCollectionViewDelegate_h */
