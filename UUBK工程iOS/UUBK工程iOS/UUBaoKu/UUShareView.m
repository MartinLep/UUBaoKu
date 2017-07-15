//
//  UUShareView.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/10.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUShareView.h"
#import <ShareSDK/ShareSDK.h>
#import "UUFaceToFaceShareViewController.h"
#import "UUAddMemberListViewController.h"

@implementation UUShareView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI{
    self.shareView = [[[NSBundle mainBundle]loadNibNamed:@"UUShareView" owner:self options:nil]lastObject];
    self.shareView.frame = self.bounds;
    [self addSubview:self.shareView];
}

- (IBAction)WXShareAvtion:(UIButton *)sender {
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:_model.GoodsName
                                     images:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_model.GoodsImage]]] //传入要分享的图片
                                        url:[NSURL URLWithString:_model.ShareUrl]
                                      title:@"我发现一件不错的商品哦"
                                       type:SSDKContentTypeAuto];
    
    //进行分享
    [ShareSDK share:SSDKPlatformTypeWechat //传入分享的平台类型
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....}];
     }];
}

- (IBAction)QQShareAction:(UIButton *)sender {
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:_model.GoodsName
                                     images:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_model.GoodsImage]]] //传入要分享的图片
                                        url:[NSURL URLWithString:_model.ShareUrl]
                                      title:@"我发现一件不错的商品哦"
                                       type:SSDKContentTypeAuto];
    //进行分享
    [ShareSDK share:SSDKPlatformTypeQQ //传入分享的平台类型
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....}];
     }];
}

- (IBAction)WXCircleAction:(UIButton *)sender {
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:_model.GoodsName
                                     images:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_model.GoodsImage]]] //传入要分享的图片
                                        url:[NSURL URLWithString:_model.ShareUrl]
                                      title:@"我发现一件不错的商品哦"
                                       type:SSDKContentTypeAuto];
    
    //进行分享
    [ShareSDK share:SSDKPlatformSubTypeWechatTimeline //传入分享的平台类型
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....}];
     }];
}

- (UIViewController *)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
- (IBAction)FaceShareAction:(UIButton *)sender {
    UUFaceToFaceShareViewController *faceShare = [[UUFaceToFaceShareViewController alloc]init];
    faceShare.model= self.model;
    [[self viewController].navigationController pushViewController:faceShare animated:YES];
    
}

- (IBAction)SinaShareAction:(UIButton *)sender {
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:_model.GoodsName
                                     images:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_model.GoodsImage]]] //传入要分享的图片
                                        url:[NSURL URLWithString:_model.ShareUrl]
                                      title:@"我发现一件不错的商品哦"
                                       type:SSDKContentTypeAuto];
    //进行分享
    [ShareSDK share:SSDKPlatformTypeSinaWeibo //传入分享的平台类型
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....}];
     }];
}

- (IBAction)SMSShareAction:(UIButton *)sender {
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:kAString(_model.ShareUrl, _model.GoodsName)
                                     images:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_model.GoodsImage]]] //传入要分享的图片
                                        url:[NSURL URLWithString:_model.ShareUrl]
                                      title:@"我发现一件不错的商品哦"
                                       type:SSDKContentTypeAuto];
    //进行分享
    [ShareSDK share:SSDKPlatformTypeSMS //传入分享的平台类型
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....}];
     }];
}

- (IBAction)CopyLinkAction:(UIButton *)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _model.ShareUrl;
}


- (IBAction)QQZoneShareAction:(UIButton *)sender {
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@ %@",_model.GoodsName,_model.ShareUrl]
                                     images:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_model.GoodsImage]]] //传入要分享的图片
                                        url:[NSURL URLWithString:_model.ShareUrl]
                                      title:@"我发现一件不错的商品哦"
                                       type:SSDKContentTypeAuto];
    //进行分享
    [ShareSDK share:SSDKPlatformSubTypeQZone//传入分享的平台类型
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....}];
     }];
}

- (IBAction)FriendShareAction:(UIButton *)sender {
    UUAddMemberListViewController *memberList = [UUAddMemberListViewController new];
    memberList.isShare = 1;
    memberList.shareModel = self.model;
    [[self viewController].navigationController pushViewController:memberList animated:YES];
}


@end
