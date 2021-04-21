//
//  ColorsCollectionViewDelegate.m
//  OSPhotoEditor
//
//  Created by Luis Bouça on 26/02/2021.
//  Copyright © 2021 André Gonçalves. All rights reserved.
//

#import "ColorsCollectionViewDelegate.h"
//
//  ColorsCollectionViewDelegate.swift
//  Photo Editor
//
//  Created by Mohamed Hamed on 5/1/17.
//  Copyright © 2017 Mohamed Hamed. All rights reserved.
//
@implementation ColorsCollectionViewDelegate

- (instancetype)init
{
    self = [super init];
    if (self) {
        _colors = [[NSArray alloc]initWithObjects:UIColor.blackColor,
            UIColor.darkGrayColor,
            UIColor.grayColor,
            UIColor.lightGrayColor,
            UIColor.whiteColor,
            UIColor.blueColor,
            UIColor.greenColor,
            UIColor.redColor,
            UIColor.yellowColor,
            UIColor.orangeColor,
            UIColor.purpleColor,
            UIColor.cyanColor,
            UIColor.brownColor,
            UIColor.magentaColor, nil];

    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView*) collectionView numberOfItemsInSection:(NSInteger)section{
        return [_colors count];
    }
-(void)collectionView:(UICollectionView*)collectionView didSelectItemAt:(NSIndexPath*)indexPath{
    [_colorDelegate didSelectColor:_colors[indexPath.item]];
    }
-(NSInteger)numberOfSections:(UICollectionView*) collectionView{
        return 1;
    }
-(UICollectionViewCell*)collectionView:(UICollectionView*) collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ColorCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor =  _colors[indexPath.item];
    return cell;
    }
@end
