/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "EaseChatBarMoreView.h"
#import "UUMoreBarButton.h"
#define CHAT_BUTTON_SIZE 50
#define CHAT_BUTTON_HEIGHT 70
#define INSETS 10
#define MOREVIEW_COL 4
#define MOREVIEW_ROW 2
#define MOREVIEW_BUTTON_TAG 1000

@implementation UIView (MoreView)

- (void)removeAllSubview
{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

@end

@interface EaseChatBarMoreView ()<UIScrollViewDelegate>
{
    EMChatToolbarType _type;
    NSInteger _maxIndex;
}

@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) UIButton *photoButton;
@property (nonatomic, strong) UIButton *takePicButton;
@property (nonatomic, strong) UIButton *locationButton;
@property (nonatomic, strong) UIButton *videoButton;
@property (nonatomic, strong) UIButton *audioCallButton;
@property (nonatomic, strong) UIButton *videoCallButton;
@property (nonatomic, strong) UIButton *redPacketButton;
@property (nonatomic, strong) UIButton *collectionButton;
@property (nonatomic, strong) UIButton *recommendButton;

@end

@implementation EaseChatBarMoreView

+ (void)initialize
{
    // UIAppearance Proxy Defaults
    EaseChatBarMoreView *moreView = [self appearance];
    moreView.moreViewBackgroundColor = [UIColor whiteColor];
}

- (instancetype)initWithFrame:(CGRect)frame type:(EMChatToolbarType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _type = type;
        [self setupSubviewsForType:_type];
    }
    return self;
}

- (void)setupSubviewsForType:(EMChatToolbarType)type
{
    //self.backgroundColor = [UIColor clearColor];
    self.accessibilityIdentifier = @"more_view";
    
    _scrollview = [[UIScrollView alloc] init];
    _scrollview.pagingEnabled = YES;
    _scrollview.showsHorizontalScrollIndicator = NO;
    _scrollview.showsVerticalScrollIndicator = NO;
    _scrollview.delegate = self;
    [self addSubview:_scrollview];
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.currentPage = 0;
    _pageControl.tintColor = UUGREY;
    _pageControl.numberOfPages = 2;
    [self addSubview:_pageControl];
    
    CGFloat insets = (self.frame.size.width - 4 * CHAT_BUTTON_SIZE) / 5;
    
    _photoButton =[UUMoreBarButton buttonWithType:UIButtonTypeCustom];
    _photoButton.accessibilityIdentifier = @"image";
    [_photoButton setFrame:CGRectMake(insets, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_HEIGHT)];
    [_photoButton setImage:[UIImage imageNamed:@"group_2"] forState:UIControlStateNormal];
    [_photoButton setTitle:@"图片" forState:UIControlStateNormal];
    _photoButton.titleLabel.font = [UIFont systemFontOfSize:10];
    [_photoButton addTarget:self action:@selector(photoAction) forControlEvents:UIControlEventTouchUpInside];
    _photoButton.tag = MOREVIEW_BUTTON_TAG;
    [_scrollview addSubview:_photoButton];
    
    _locationButton =[UUMoreBarButton buttonWithType:UIButtonTypeCustom];
    _locationButton.accessibilityIdentifier = @"location";
    [_locationButton setFrame:CGRectMake(insets * 2 + CHAT_BUTTON_SIZE, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_HEIGHT)];
    [_locationButton setImage:[UIImage imageNamed:@"group_5"] forState:UIControlStateNormal];
    [_locationButton setTitle:@"位置" forState:UIControlStateNormal];
    _locationButton.titleLabel.font = [UIFont systemFontOfSize:10];
    [_locationButton addTarget:self action:@selector(locationAction) forControlEvents:UIControlEventTouchUpInside];
    _locationButton.tag = MOREVIEW_BUTTON_TAG + 1;
    [_scrollview addSubview:_locationButton];
    
    _takePicButton =[UUMoreBarButton buttonWithType:UIButtonTypeCustom];
    [_takePicButton setFrame:CGRectMake(insets * 3 + CHAT_BUTTON_SIZE * 2, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_HEIGHT)];
    [_takePicButton setImage:[UIImage imageNamed:@"group"] forState:UIControlStateNormal];
    [_takePicButton setTitle:@"拍照" forState:UIControlStateNormal];
    _takePicButton.titleLabel.font = [UIFont systemFontOfSize:10];
    [_takePicButton addTarget:self action:@selector(takePicAction) forControlEvents:UIControlEventTouchUpInside];
    _takePicButton.tag = MOREVIEW_BUTTON_TAG + 2;
    _maxIndex = 2;
    [_scrollview addSubview:_takePicButton];

    CGRect frame = self.frame;
    if (type == EMChatToolbarTypeChat) {
        frame.size.height = 180;
        _audioCallButton =[UUMoreBarButton buttonWithType:UIButtonTypeCustom];
        [_audioCallButton setFrame:CGRectMake(insets * 4 + CHAT_BUTTON_SIZE * 3, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_HEIGHT)];
        [_audioCallButton setImage:[UIImage imageNamed:@"group_8"] forState:UIControlStateNormal];
        [_audioCallButton setTitle:@"语音通话" forState:UIControlStateNormal];
        _audioCallButton.titleLabel.font = [UIFont systemFontOfSize:10];
        [_audioCallButton addTarget:self action:@selector(takeAudioCallAction) forControlEvents:UIControlEventTouchUpInside];
        _audioCallButton.tag = MOREVIEW_BUTTON_TAG + 3;
        [_scrollview addSubview:_audioCallButton];
        
        _videoCallButton =[UUMoreBarButton buttonWithType:UIButtonTypeCustom];
        [_videoCallButton setFrame:CGRectMake(insets, 10 * 2 + CHAT_BUTTON_HEIGHT, CHAT_BUTTON_SIZE , CHAT_BUTTON_HEIGHT)];
        [_videoCallButton setImage:[UIImage imageNamed:@"group_4"] forState:UIControlStateNormal];
        [_videoCallButton setTitle:@"视频通话" forState:UIControlStateNormal];
        _videoCallButton.titleLabel.font = [UIFont systemFontOfSize:10];
        [_videoCallButton addTarget:self action:@selector(takeVideoCallAction) forControlEvents:UIControlEventTouchUpInside];
        _videoCallButton.tag =MOREVIEW_BUTTON_TAG + 4;
        _maxIndex = 4;
        [_scrollview addSubview:_videoCallButton];
        _videoButton =[UUMoreBarButton buttonWithType:UIButtonTypeCustom];
        [_videoButton setFrame:CGRectMake(insets*2 + CHAT_BUTTON_SIZE, 10 * 2 + CHAT_BUTTON_HEIGHT, CHAT_BUTTON_SIZE , CHAT_BUTTON_HEIGHT)];
        [_videoButton setImage:[UIImage imageNamed:@"group_7"] forState:UIControlStateNormal];
        [_videoButton setTitle:@"视频" forState:UIControlStateNormal];
        _videoButton.titleLabel.font = [UIFont systemFontOfSize:10];
        [_videoButton addTarget:self action:@selector(takeVideoAction) forControlEvents:UIControlEventTouchUpInside];
        _videoButton.tag =MOREVIEW_BUTTON_TAG + 5;
        _maxIndex = 5;
        [_scrollview addSubview:_videoButton];
        _redPacketButton =[UUMoreBarButton buttonWithType:UIButtonTypeCustom];
        [_redPacketButton setFrame:CGRectMake(insets*3 + CHAT_BUTTON_SIZE*2, 10 * 2 + CHAT_BUTTON_HEIGHT, CHAT_BUTTON_SIZE , CHAT_BUTTON_HEIGHT)];
        [_redPacketButton setImage:[UIImage imageNamed:@"group_66"] forState:UIControlStateNormal];
        [_redPacketButton setTitle:@"红包" forState:UIControlStateNormal];
        _redPacketButton.titleLabel.font = [UIFont systemFontOfSize:10];
        [_redPacketButton addTarget:self action:@selector(takeRedPacketAction) forControlEvents:UIControlEventTouchUpInside];
        _redPacketButton.tag =MOREVIEW_BUTTON_TAG + 6;
        _maxIndex = 6;
        [_scrollview addSubview:_redPacketButton];
        _collectionButton =[UUMoreBarButton buttonWithType:UIButtonTypeCustom];
        [_collectionButton setFrame:CGRectMake(insets*4 + CHAT_BUTTON_SIZE*3, 10 * 2 + CHAT_BUTTON_HEIGHT, CHAT_BUTTON_SIZE , CHAT_BUTTON_HEIGHT)];
        [_collectionButton setImage:[UIImage imageNamed:@"group_9"] forState:UIControlStateNormal];
        [_collectionButton setTitle:@"收藏" forState:UIControlStateNormal];
        _collectionButton.titleLabel.font = [UIFont systemFontOfSize:10];
        [_collectionButton addTarget:self action:@selector(takeCollectionAction) forControlEvents:UIControlEventTouchUpInside];
        _collectionButton.tag =MOREVIEW_BUTTON_TAG + 7;
        _maxIndex = 7;
        [_scrollview addSubview:_collectionButton];
        _recommendButton =[UUMoreBarButton buttonWithType:UIButtonTypeCustom];
        [_recommendButton setFrame:CGRectMake(insets+self.frame.size.width, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_HEIGHT)];
        [_recommendButton setImage:[UIImage imageNamed:@"group_10"] forState:UIControlStateNormal];
        [_recommendButton setTitle:@"推荐" forState:UIControlStateNormal];
        _recommendButton.titleLabel.font = [UIFont systemFontOfSize:10];
        [_recommendButton addTarget:self action:@selector(takeRecommendAction) forControlEvents:UIControlEventTouchUpInside];
        _recommendButton.tag =MOREVIEW_BUTTON_TAG + 8;
        _maxIndex = 8;
        [_scrollview addSubview:_recommendButton];
    }
    else if (type == EMChatToolbarTypeGroup)
    {
        _videoButton =[UUMoreBarButton buttonWithType:UIButtonTypeCustom];
        [_videoButton setFrame:CGRectMake(insets * 4 + CHAT_BUTTON_SIZE * 3, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_HEIGHT)];
        [_videoButton setImage:[UIImage imageNamed:@"group_7"] forState:UIControlStateNormal];
        [_videoButton setTitle:@"视频" forState:UIControlStateNormal];
        _videoButton.titleLabel.font = [UIFont systemFontOfSize:10];
        [_videoButton addTarget:self action:@selector(takeVideoAction) forControlEvents:UIControlEventTouchUpInside];
        _videoButton.tag =MOREVIEW_BUTTON_TAG + 3;
        [_scrollview addSubview:_videoButton];
        _redPacketButton =[UUMoreBarButton buttonWithType:UIButtonTypeCustom];
        [_redPacketButton setFrame:CGRectMake(insets, 10 * 2 + CHAT_BUTTON_HEIGHT, CHAT_BUTTON_SIZE , CHAT_BUTTON_HEIGHT)];
        [_redPacketButton setImage:[UIImage imageNamed:@"group_66"] forState:UIControlStateNormal];
        [_redPacketButton setTitle:@"红包" forState:UIControlStateNormal];
        _redPacketButton.titleLabel.font = [UIFont systemFontOfSize:10];
        [_redPacketButton addTarget:self action:@selector(takeRedPacketAction) forControlEvents:UIControlEventTouchUpInside];
        _redPacketButton.tag =MOREVIEW_BUTTON_TAG + 4;
        _maxIndex = 4;
        [_scrollview addSubview:_redPacketButton];
        
        _collectionButton =[UUMoreBarButton buttonWithType:UIButtonTypeCustom];
        [_collectionButton setFrame:CGRectMake(insets*2 + CHAT_BUTTON_SIZE, 10 * 2 + CHAT_BUTTON_HEIGHT, CHAT_BUTTON_SIZE , CHAT_BUTTON_HEIGHT)];
        [_collectionButton setImage:[UIImage imageNamed:@"group_9"] forState:UIControlStateNormal];
        [_collectionButton setTitle:@"收藏" forState:UIControlStateNormal];
        _collectionButton.titleLabel.font = [UIFont systemFontOfSize:10];
        [_collectionButton addTarget:self action:@selector(takeCollectionAction) forControlEvents:UIControlEventTouchUpInside];
        _collectionButton.tag =MOREVIEW_BUTTON_TAG + 7;
        _maxIndex = 5;
        [_scrollview addSubview:_collectionButton];
        _recommendButton =[UUMoreBarButton buttonWithType:UIButtonTypeCustom];
        [_recommendButton setFrame:CGRectMake(insets*3 + CHAT_BUTTON_SIZE*2, 10 * 2 + CHAT_BUTTON_HEIGHT, CHAT_BUTTON_SIZE , CHAT_BUTTON_HEIGHT)];
        [_recommendButton setImage:[UIImage imageNamed:@"group_10"] forState:UIControlStateNormal];
        [_recommendButton setTitle:@"推荐" forState:UIControlStateNormal];
        _recommendButton.titleLabel.font = [UIFont systemFontOfSize:10];
        [_recommendButton addTarget:self action:@selector(takeRecommendAction) forControlEvents:UIControlEventTouchUpInside];
        _recommendButton.tag =MOREVIEW_BUTTON_TAG + 8;
        _maxIndex = 6;
        [_scrollview addSubview:_recommendButton];
        frame.size.height = 180;
    }
    self.frame = frame;
    _scrollview.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
    if (type == EMChatToolbarTypeChat) {
        _scrollview.contentSize = CGSizeMake(_scrollview.width*2, _scrollview.height);
    }
    _pageControl.frame = CGRectMake(0, CGRectGetHeight(frame) - 20, CGRectGetWidth(frame), 20);
    _pageControl.hidden = _pageControl.numberOfPages<=1;
}

- (void)takeVideoAction{
    if(_delegate && [_delegate respondsToSelector:@selector(moreViewTakeVideoAction:)]){
        [_delegate moreViewTakeVideoAction:self];
    }
}

- (void)takeRedPacketAction{
    if(_delegate && [_delegate respondsToSelector:@selector(moreViewTakeRedPacketAction:)]){
        [_delegate moreViewTakeRedPacketAction:self];
    }
}

- (void)takeCollectionAction{
    if(_delegate && [_delegate respondsToSelector:@selector(moreViewTakeCollectionAction:)]){
        [_delegate moreViewTakeCollectionAction:self];
    }
}

- (void)takeRecommendAction{
    if(_delegate && [_delegate respondsToSelector:@selector(moreViewTakeRecommendAction:)]){
        [_delegate moreViewTakeRecommendAction:self];
    }
}

- (void)insertItemWithImage:(UIImage *)image highlightedImage:(UIImage *)highLightedImage title:(NSString *)title
{
    CGFloat insets = (self.frame.size.width - MOREVIEW_COL * CHAT_BUTTON_SIZE) / 5;
    CGRect frame = self.frame;
    _maxIndex++;
    NSInteger pageSize = MOREVIEW_COL*MOREVIEW_ROW;
    NSInteger page = _maxIndex/pageSize;
    NSInteger row = (_maxIndex%pageSize)/MOREVIEW_COL;
    NSInteger col = _maxIndex%MOREVIEW_COL;
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreButton setFrame:CGRectMake(page * CGRectGetWidth(self.frame) + insets * (col + 1) + CHAT_BUTTON_SIZE * col, INSETS + INSETS * 2 * row + CHAT_BUTTON_SIZE * row, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [moreButton setImage:image forState:UIControlStateNormal];
    [moreButton setImage:highLightedImage forState:UIControlStateHighlighted];
    [moreButton addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
    moreButton.tag = MOREVIEW_BUTTON_TAG+_maxIndex;
    [_scrollview addSubview:moreButton];
    [_scrollview setContentSize:CGSizeMake(CGRectGetWidth(self.frame) * (page + 1), CGRectGetHeight(self.frame))];
    [_pageControl setNumberOfPages:page + 1];
    if (_maxIndex >=5) {
        frame.size.height = 150;
        _scrollview.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
        _pageControl.frame = CGRectMake(0, CGRectGetHeight(frame) - 20, CGRectGetWidth(frame), 20);
    }
    self.frame = frame;
    _pageControl.hidden = _pageControl.numberOfPages<=1;
}

- (void)updateItemWithImage:(UIImage *)image highlightedImage:(UIImage *)highLightedImage title:(NSString *)title atIndex:(NSInteger)index
{
    UIView *moreButton = [_scrollview viewWithTag:MOREVIEW_BUTTON_TAG+index];
    if (moreButton && [moreButton isKindOfClass:[UIButton class]]) {
        [(UIButton*)moreButton setImage:image forState:UIControlStateNormal];
        [(UIButton*)moreButton setImage:highLightedImage forState:UIControlStateHighlighted];
    }
}

- (void)removeItematIndex:(NSInteger)index
{
    UIView *moreButton = [_scrollview viewWithTag:MOREVIEW_BUTTON_TAG+index];
    if (moreButton && [moreButton isKindOfClass:[UIButton class]]) {
        [self _resetItemFromIndex:index];
        [moreButton removeFromSuperview];
    }
}

#pragma mark - private

- (void)_resetItemFromIndex:(NSInteger)index
{
    CGFloat insets = (self.frame.size.width - MOREVIEW_COL * CHAT_BUTTON_SIZE) / 5;
    CGRect frame = self.frame;
    for (NSInteger i = index + 1; i<_maxIndex + 1; i++) {
        UIView *moreButton = [_scrollview viewWithTag:MOREVIEW_BUTTON_TAG+i];
        if (moreButton && [moreButton isKindOfClass:[UIButton class]]) {
            NSInteger moveToIndex = i - 1;
            NSInteger pageSize = MOREVIEW_COL*MOREVIEW_ROW;
            NSInteger page = moveToIndex/pageSize;
            NSInteger row = (moveToIndex%pageSize)/MOREVIEW_COL;
            NSInteger col = moveToIndex%MOREVIEW_COL;
            [moreButton setFrame:CGRectMake(page * CGRectGetWidth(self.frame) + insets * (col + 1) + CHAT_BUTTON_SIZE * col, INSETS + INSETS * 2 * row + CHAT_BUTTON_SIZE * row, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
            moreButton.tag = MOREVIEW_BUTTON_TAG+moveToIndex;
            [_scrollview setContentSize:CGSizeMake(CGRectGetWidth(self.frame) * (page + 1), CGRectGetHeight(self.frame))];
            [_pageControl setNumberOfPages:page + 1];
        }
    }
    _maxIndex--;
    if (_maxIndex >=5) {
        frame.size.height = 150;
    } else {
        frame.size.height = 80;
    }
    self.frame = frame;
    _scrollview.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
    _pageControl.frame = CGRectMake(0, CGRectGetHeight(frame) - 20, CGRectGetWidth(frame), 20);
    _pageControl.hidden = _pageControl.numberOfPages<=1;
}

#pragma setter
//- (void)setMoreViewColumn:(NSInteger)moreViewColumn
//{
//    if (_moreViewColumn != moreViewColumn) {
//        _moreViewColumn = moreViewColumn;
//        [self setupSubviewsForType:_type];
//    }
//}
//
//- (void)setMoreViewNumber:(NSInteger)moreViewNumber
//{
//    if (_moreViewNumber != moreViewNumber) {
//        _moreViewNumber = moreViewNumber;
//        [self setupSubviewsForType:_type];
//    }
//}

- (void)setMoreViewBackgroundColor:(UIColor *)moreViewBackgroundColor
{
    _moreViewBackgroundColor = moreViewBackgroundColor;
    if (_moreViewBackgroundColor) {
        [self setBackgroundColor:_moreViewBackgroundColor];
    }
}

/*
- (void)setMoreViewButtonImages:(NSArray *)moreViewButtonImages
{
    _moreViewButtonImages = moreViewButtonImages;
    if ([_moreViewButtonImages count] > 0) {
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)view;
                if (button.tag < [_moreViewButtonImages count]) {
                    NSString *imageName = [_moreViewButtonImages objectAtIndex:button.tag];
                    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
                }
            }
        }
    }
}

- (void)setMoreViewButtonHignlightImages:(NSArray *)moreViewButtonHignlightImages
{
    _moreViewButtonHignlightImages = moreViewButtonHignlightImages;
    if ([_moreViewButtonHignlightImages count] > 0) {
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)view;
                if (button.tag < [_moreViewButtonHignlightImages count]) {
                    NSString *imageName = [_moreViewButtonHignlightImages objectAtIndex:button.tag];
                    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
                }
            }
        }
    }
}*/

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset =  scrollView.contentOffset;
    if (offset.x == 0) {
        _pageControl.currentPage = 0;
    } else {
        int page = offset.x / CGRectGetWidth(scrollView.frame);
        _pageControl.currentPage = page;
    }
}

#pragma mark - action

- (void)takePicAction{
    if(_delegate && [_delegate respondsToSelector:@selector(moreViewTakePicAction:)]){
        [_delegate moreViewTakePicAction:self];
    }
}

- (void)photoAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewPhotoAction:)]) {
        [_delegate moreViewPhotoAction:self];
    }
}

- (void)locationAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewLocationAction:)]) {
        [_delegate moreViewLocationAction:self];
    }
}

- (void)takeAudioCallAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewAudioCallAction:)]) {
        [_delegate moreViewAudioCallAction:self];
    }
}

- (void)takeVideoCallAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewVideoCallAction:)]) {
        [_delegate moreViewVideoCallAction:self];
    }
}

- (void)moreAction:(id)sender
{
    UIButton *button = (UIButton*)sender;
    if (button && _delegate && [_delegate respondsToSelector:@selector(moreView:didItemInMoreViewAtIndex:)]) {
        [_delegate moreView:self didItemInMoreViewAtIndex:button.tag-MOREVIEW_BUTTON_TAG];
    }
}

@end
