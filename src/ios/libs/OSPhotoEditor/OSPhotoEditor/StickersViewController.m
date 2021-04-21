//
//  StickersViewController.m
//  OSPhotoEditor
//
//  Created by Luis Bouça on 02/03/2021.
//  Copyright © 2021 André Gonçalves. All rights reserved.
//

#import "StickersViewController.h"

@implementation StickersViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _stickers = [[NSMutableArray alloc] init];
        _screenSize = UIScreen.mainScreen.bounds.size;
        _fullView = 100;
        //TODO: maybe geter for this
        _partialView = UIScreen.mainScreen.bounds.size.height - 380;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self configureCollectionViews];
    
    _scrollView.contentSize = CGSizeMake(2.0* _screenSize.width, _scrollView.frame.size.height);
    
    _scrollView.pagingEnabled = true;
    _scrollView.delegate = self;
    _pageControl.numberOfPages = 2;
    
    _holdView.layer.cornerRadius = 3;
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    gesture.delegate = self;
    [[self view] addGestureRecognizer:gesture];
}

-(void)configureCollectionViews{
    
    CGRect frame = CGRectMake(0 ,0 ,UIScreen.mainScreen.bounds.size.width ,[self view].frame.size.height - 40);
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout init];
    layout.sectionInset = UIEdgeInsetsMake(20, 10, 10, 10);
    CGFloat width = (CGFloat) ((_screenSize.width - 30) / 3.0);
    layout.itemSize = CGSizeMake(width, 100);
    
    _collectioView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    _collectioView.backgroundColor = UIColor.clearColor;
    [_scrollView addSubview:_collectioView];
    
    _collectioView.delegate = self;
    _collectioView.dataSource = self;
    
    [_collectioView registerNib:[UINib nibWithNibName:@"StickerCollectionViewCell" bundle:[NSBundle bundleForClass:StickerCollectionViewCell.class]] forCellWithReuseIdentifier:@"StickerCollectionViewCell"];
    
    //-----------------------------------
    
    CGRect emojisFrame = CGRectMake(_scrollView.frame.size.width, 0, UIScreen.mainScreen.bounds.size.width, [self view].frame.size.height - 40);
    
    UICollectionViewFlowLayout *emojislayout = [UICollectionViewFlowLayout init];
    emojislayout.sectionInset = UIEdgeInsetsMake(20, 10, 10, 10);
    emojislayout.itemSize = CGSizeMake( 70, 70);
    
    _emojisCollectioView = [[UICollectionView alloc] initWithFrame:emojisFrame collectionViewLayout:emojislayout];
    _emojisCollectioView.backgroundColor = UIColor.clearColor;
    [_scrollView addSubview:_emojisCollectioView];
    _emojisDelegate = [[EmojisCollectionViewDelegate alloc] init];
    _emojisDelegate.stickersViewControllerDelegate = _stickersViewControllerDelegate;
    _emojisCollectioView.delegate = _emojisDelegate;
    _emojisCollectioView.dataSource = _emojisDelegate;
    
    [_emojisCollectioView registerNib:[UINib nibWithNibName:@"EmojiCollectionViewCell" bundle:[NSBundle bundleForClass:EmojiCollectionViewCell.class]] forCellWithReuseIdentifier:@"EmojiCollectionViewCell"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self prepareBackgroundView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.6 animations:^{
        CGRect frame = self.view.frame;
        CGFloat yComponent = self.partialView;
        self.view.frame = CGRectMake(0, yComponent, frame.size.width, UIScreen.mainScreen.bounds.size.height-self.partialView);
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.collectioView.frame = CGRectMake(0,
                                          0,
                                          UIScreen.mainScreen.bounds.size.width,
                                          self.view.frame.size.height - 40);
    
    self.emojisCollectioView.frame = CGRectMake(self.scrollView.frame.size.width,
                                                0,
                                                UIScreen.mainScreen.bounds.size.width,
                                                self.view.frame.size.height - 40);
    
    self.scrollView.contentSize = CGSizeMake(2.0 * self.screenSize.width,
                                             self.scrollView.frame.size.height);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//MARK: Pan Gesture

- (void)panGesture:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self.view];
    CGPoint velocity = [recognizer velocityInView:self.view];
    
    CGFloat y = CGRectGetMinY(self.view.frame);
    if(y + translation.y >= _fullView) {
        CGFloat newMinY = y + translation.y;
        self.view.frame = CGRectMake(0, newMinY, self.view.frame.size.width, UIScreen.mainScreen.bounds.size.height - newMinY );
        [self.view layoutIfNeeded];
        [recognizer setTranslation:CGPointZero inView:self.view];
    }
    
    if(recognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat duration =  velocity.y < 0 ? ((y - _fullView) / -velocity.y) : ((_partialView - y) / velocity.y );
        duration = duration > 1.3 ? 1 : duration;
        //velocity is direction of gesture
        [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            if (velocity.y >= 0) {
                if (y + translation.y >= self.partialView)  {
                    [self removeBottomSheetView];
                } else {
                    self.view.frame = CGRectMake(0, self.partialView, self.view.frame.size.width, UIScreen.mainScreen.bounds.size.height - self.partialView);
                    [self.view layoutIfNeeded];
                }
            } else {
                if(y + translation.y >= self.partialView){
                    self.view.frame = CGRectMake(0, self.partialView, self.view.frame.size.width, UIScreen.mainScreen.bounds.size.height - self.partialView);
                    [self.view layoutIfNeeded];
                } else {
                    self.view.frame = CGRectMake(0, self.fullView, self.view.frame.size.width, UIScreen.mainScreen.bounds.size.height - self.fullView);
                    [self.view layoutIfNeeded];
                }
            }
                } completion:nil];
    }
}
- (void)removeBottomSheetView {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = CGRectGetMaxY(UIScreen.mainScreen.bounds);
        self.view.frame = frame;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        [self.stickersViewControllerDelegate stickersViewDidDisappear];
    }];
}
- (void)prepareBackgroundView{
    UIBlurEffect* blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView* visualEffect = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    UIVisualEffectView* bluredView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [bluredView.contentView addSubview:visualEffect];
    visualEffect.frame = UIScreen.mainScreen.bounds;
    bluredView.frame = UIScreen.mainScreen.bounds;
    [self.view insertSubview:bluredView atIndex:0];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pageWidth = _scrollView.bounds.size.width;
    CGFloat pageFraction = _scrollView.contentOffset.x / pageWidth;
    self.pageControl.currentPage = (int)round(pageFraction);
}

// MARK: - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.stickers.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAt:(NSIndexPath *)indexPath{
    [_stickersViewControllerDelegate didSelectImage:[_stickers objectAtIndex:indexPath.item]];
}

- (NSInteger)numberOfSectionsIn:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAt:(NSIndexPath *)indexPath {
    NSString* identifier = @"StickerCollectionViewCell";
    StickerCollectionViewCell* cell  = (StickerCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath ];
    cell.stickerImage.image = [_stickers objectAtIndex:indexPath.item];
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAt:(NSInteger)section {
    return 4;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAt:(NSInteger)section {
    return 0;
}


@end
