//
//  EmojisCollectionViewDelegate.m
//  OSPhotoEditor
//
//  Created by Luis Bouça on 14/04/2021.
//  Copyright © 2021 André Gonçalves. All rights reserved.
//

#import "EmojisCollectionViewDelegate.h"


@implementation EmojisCollectionViewDelegate

- (instancetype)init
{
    self = [super init];
    if (self) {
        _emojiRanges = [self createHexRangeFrom:@"0x1F601" to:@"01F64F"];
        _emojiRanges = [_emojiRanges arrayByAddingObjectsFromArray:[self createHexRangeFrom:@"0x1F30D" to:@"0x1F567"]];
        _emojiRanges = [_emojiRanges arrayByAddingObjectsFromArray:[self createHexRangeFrom:@"0x1F680" to:@"0x1F6C0"]];
        _emojiRanges = [_emojiRanges arrayByAddingObjectsFromArray:[self createHexRangeFrom:@"0x1F681" to:@"0x1F6C5"]];
        for (NSString* hex in _emojiRanges) {
            [_emojis addObject:hex];
        }
    }
    return self;
}
-(NSArray*)createHexRangeFrom:(NSString*)from to:(NSString*)to{
    unsigned fromInt = [self hexToInt:from];
    unsigned toInt = [self hexToInt:to];
    NSMutableArray* result = [[NSMutableArray alloc] init];
    for (int i = fromInt; i<(fromInt-toInt); i++) {
        [result addObject:[self intToHex:i]];
    }
    return result;
}


-(unsigned)hexToInt:(NSString*)hex{
    unsigned result = 0;
    NSScanner* scanner = [NSScanner scannerWithString:hex];
    [scanner scanHexInt:&result];
    return result;
}
-(NSString*)intToHex:(unsigned)intValue{
    NSString* result = @"";
    result =[NSString stringWithFormat:@"%0X",intValue];
    return result;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _emojis.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UILabel* emojiLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,90,90)];
    emojiLabel.textAlignment = NSTextAlignmentCenter;
    emojiLabel.text = _emojis[indexPath.item];
    emojiLabel.font = [UIFont systemFontOfSize:70];
    [_stickersViewControllerDelegate didSelectView:emojiLabel];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    EmojiCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EmojiCollectionViewCell" forIndexPath:indexPath];
    cell.emojiLabel.text = _emojis[indexPath.item];
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 4;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

@end

