//
//  EmojisCollectionViewDelegate.h
//  OSPhotoEditor
//
//  Created by Luis Bouça on 14/04/2021.
//  Copyright © 2021 André Gonçalves. All rights reserved.
//

#ifndef EmojisCollectionViewDelegate_h
#define EmojisCollectionViewDelegate_h

#import <UIKit/UIKit.h>
#import "EmojiCollectionViewCell.h"
#import "Protocols.h"

@interface EmojisCollectionViewDelegate : NSObject< UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property() id<StickersViewControllerDelegate> stickersViewControllerDelegate;

@property() NSArray* emojiRanges;
@property() NSMutableArray* emojis;

/*
-() collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int

func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)

func numberOfSections(in collectionView: UICollectionView) -> Int

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell

func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat

func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
 */

@end

#endif /* EmojisCollectionViewDelegate_h */
