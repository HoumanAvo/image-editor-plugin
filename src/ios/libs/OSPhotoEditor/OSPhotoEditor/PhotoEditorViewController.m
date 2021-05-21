//
//  PhotoEditorViewController.m
//  OSPhotoEditor
//
//  Created by Luis Bouça on 13/04/2021.
//  Copyright © 2021 André Gonçalves. All rights reserved.
//

#import "PhotoEditorViewController.h"
#import "PhotoEditor+Controls.h"
#import "PhotoEditor+Font.h"
#import "PhotoEditor+StickersViewController.h"
#import "PhotoEditor+Gestures.h"
#import "PhotoEditor+Keyboard.h"
#import "UIImage+Size.h"

@implementation PhotoEditorViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _stickersVCIsVisible = false;
        _drawColor = UIColor.blackColor;
        _textColor = UIColor.whiteColor;
        _isDrawing = false;
        _swiped = false;
        _isTyping = false;
    }
    return self;
}

- (void)loadView{
    [self registerFont];
    [super loadView];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setImageView:_image];
    
    _deleteView.layer.cornerRadius = _deleteView.bounds.size.height / 2;
    _deleteView.layer.borderWidth = 2.0;
    _deleteView.layer.borderColor = UIColor.whiteColor.CGColor;
    _deleteView.clipsToBounds = true;
    
    UIScreenEdgePanGestureRecognizer *edgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(screenEdgeSwiped:)];
    edgePan.edges = UIRectEdgeBottom;
    edgePan.delegate = self;
    [self.view addGestureRecognizer:edgePan];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [self configureCollectionView];
    _stickersViewController = [[StickersViewController alloc] initWithNibName:@"StickersViewController" bundle:[NSBundle bundleForClass:StickersViewController.self]];
    [self hideControls];
}

-(void) configureCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(30, 30);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    _colorsCollectionView.collectionViewLayout = layout;
    _colorsCollectionViewDelegate = [[ColorsCollectionViewDelegate alloc] init];
    _colorsCollectionViewDelegate.colorDelegate = self;
    if ([_colors count]>0) {
        _colorsCollectionViewDelegate.colors = _colors;
    }
    _colorsCollectionView.delegate = _colorsCollectionViewDelegate;
    _colorsCollectionView.dataSource = _colorsCollectionViewDelegate;
    
    [_colorsCollectionView registerNib:[UINib nibWithNibName:@"ColorCollectionViewCell" bundle:[NSBundle bundleForClass:ColorCollectionViewCell.class]] forCellWithReuseIdentifier:@"ColorCollectionViewCell"];
}

-(void) setImageView:(UIImage*) image {
    _imageView.image = image;
    CGFloat height = (UIScreen.mainScreen.bounds.size.width / image.size.width) * image.size.height;
    CGSize size = CGSizeMake(UIScreen.mainScreen.bounds.size.width, height);
    self.imageViewHeightConstraint.constant = (size.height);
}

-(void) hideToolbar:(BOOL) hide{
    _topToolbar.hidden = hide;
    _topGradient.hidden = hide;
    _bottomToolbar.hidden = hide;
    _bottomGradient.hidden = hide;
}

-(void) didSelectColor:(UIColor*) color {
    if (_isDrawing) {
        self.drawColor = color;
    } else if(_activeTextView != nil) {
        _activeTextView.textColor = color;
        _textColor = color;
    }
}

- (void)didSelectView:(UIView *)view{
    [self removeStickersView];
    view.center = self.canvasImageView.center;
    [self.canvasImageView addSubview:view];
    
    [self addGestures:view];
}

- (void)didSelectImage:(UIImage *)image{
    [self removeStickersView];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:self.image];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    CGRect frame = imageView.frame;
    frame.size = CGSizeMake(150, 150);
    imageView.frame = frame;
    imageView.center = self.canvasImageView.center;
    
    [self.canvasImageView addSubview:imageView];
    
    [self addGestures:imageView];
}

- (void)stickersViewDidDisappear{
    self.stickersVCIsVisible = false;
    [self hideToolbar:false];
}


-(void)addGestures:(UIView *)view{
    //Gestures
    self.view.userInteractionEnabled = true;
    
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    panGesture.minimumNumberOfTouches = 1;
    panGesture.maximumNumberOfTouches = 1;
    panGesture.delegate = self;
    [self.view addGestureRecognizer:panGesture];
    
    UIPinchGestureRecognizer* pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
    pinchGesture.delegate = self;
    [self.view addGestureRecognizer:pinchGesture];
    
    UIRotationGestureRecognizer* rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationGesture:)];
    rotationGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:rotationGestureRecognizer];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self.view addGestureRecognizer:tapGesture];
    
}

- (void)textViewDidChange:(UITextView *)textView {
    double rotation = atan2(textView.transform.b, textView.transform.a);
    if(rotation == 0){
        CGRect oldFrame = textView.frame;
        CGSize sizeToFit =  [textView sizeThatFits:CGSizeMake(oldFrame.size.width, CGFLOAT_MAX)];
        oldFrame.size = CGSizeMake(oldFrame.size.width, sizeToFit.height);
        textView.frame = oldFrame;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.isTyping = true;
    self.lastTextViewTransform =  textView.transform;
    self.lastTextViewTransCenter = textView.center;
    self.lastTextViewFont = textView.font;
    self.activeTextView = textView;
    [textView.superview bringSubviewToFront:textView];
    textView.font = [UIFont fontWithName:@"Helvetica" size:30];
    [UIView animateWithDuration:0.3 animations:^{
        textView.transform = CGAffineTransformIdentity;
        textView.center = CGPointMake(UIScreen.mainScreen.bounds.size.width/2, UIScreen.mainScreen.bounds.size.height/5);
    } completion:nil];
    
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if(CGAffineTransformEqualToTransform(self.lastTextViewTransform, CGAffineTransformIdentity) || self.lastTextViewFont == nil){
        return;
    }
    self.activeTextView = nil;
    textView.font = self.lastTextViewFont;
    [UIView animateWithDuration:0.3 animations:^{
        textView.transform = self.lastTextViewTransform;
        textView.center = self.lastTextViewTransCenter;
    } completion:nil];
}

@end
