//
//  StickersViewController.h
//  OSPhotoEditor
//
//  Created by Luis Bouça on 02/03/2021.
//  Copyright © 2021 André Gonçalves. All rights reserved.
//

#ifndef StickersViewController_h
#define StickersViewController_h

#import <UIKit/UIKit.h>
#import "Protocols.h"
#import "StickerCollectionViewCell.h"
#import "EmojisCollectionViewDelegate.h"

@interface StickersViewController : UIViewController<UIGestureRecognizerDelegate, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property(weak)IBOutlet UIView* headerView;
@property(weak)IBOutlet UIView* holdView;
@property(weak)IBOutlet UIScrollView* scrollView;
@property(weak)IBOutlet UIPageControl* pageControl;

@property()UICollectionView* collectioView;
@property()UICollectionView* emojisCollectioView;

@property()EmojisCollectionViewDelegate* emojisDelegate;

@property()NSMutableArray<UIImage *>* stickers;
@property()id<StickersViewControllerDelegate> stickersViewControllerDelegate;

@property()CGSize screenSize;

@property()CGFloat fullView;// remainder of screen height
@property()CGFloat partialView;/*  {
    return UIScreen.main.bounds.height - 380
}*/
-(void)configureCollectionViews;
-(void)panGesture:(UIPanGestureRecognizer*)recognizer;
-(void)removeBottomSheetView;
-(void)prepareBackgroundView;
-(void)scrollViewDidScroll:(UIScrollView*)scrollView;

-(NSInteger)collectionView:(UICollectionView*) collectionView numberOfItemsInSection:(NSInteger)section;

-(void)collectionView:(UICollectionView*) collectionView didSelectItemAt:(NSIndexPath*) indexPath;

-(NSInteger)numberOfSectionsIn:(UICollectionView*)collectionView;

-(UICollectionViewCell*)collectionView:(UICollectionView*) collectionView cellForItemAt: (NSIndexPath*) indexPath;

-(CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*) collectionViewLayout minimumLineSpacingForSectionAt:(NSInteger) section;

-(CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*) collectionViewLayout minimumInteritemSpacingForSectionAt:(NSInteger) section;
@end

#endif /* StickersViewController_h */
