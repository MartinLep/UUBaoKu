//
//  UUMeWantShareViewController.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/9.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUMeWantShareViewController.h"
#import <ShareSDK/ShareSDK.h>
@interface UUMeWantShareViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightSpaceWidth;
@property (weak, nonatomic) IBOutlet UITextView *contentTV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewHeight;
- (IBAction)QQShareAction:(UIButton *)sender;
- (IBAction)WXShareAction:(UIButton *)sender;
- (IBAction)SinaShareAction:(UIButton *)sender;
- (IBAction)QQZoneShareAction:(UIButton *)sender;
- (IBAction)WXCircleShareAction:(UIButton *)sender;


@end

@implementation UUMeWantShareViewController

- (void)getMyShareData{
    NSDictionary *para = @{@"UserId":UserId};
    [NetworkTools postReqeustWithParams:para UrlString:kAString(DOMAIN_NAME, WANTED_SHARE) successBlock:^(id responseObject) {
        _contentTV.text = responseObject[@"data"];
    } failureBlock:^(NSError *error) {
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUNG_COLOR;
    self.backViewHeight.constant = 106*SCALE_WIDTH;
    self.spaceWidth.constant = 25*SCALE_WIDTH;
    self.contentTV.delegate = self;
    self.rightSpaceWidth.constant = self.spaceWidth.constant;
    [self getMyShareData];
    // Do any additional setup after loading the view from its nib.
}

- (UIToolbar *)addToolbar
{
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 50)];
    //    UIToolbar *toolbar =[[UIToolbar alloc] init];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(numberFieldCancle)];
    //    UIBarButtonItem *left = [[UIBarButtonItem alloc]init];
    UIBarButtonItem *sapce = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolbar.items = @[sapce,bar];
    
    return toolbar;
}

-(void)numberFieldCancle{
    
    [self.contentTV resignFirstResponder];
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    textView.inputAccessoryView = [self addToolbar];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)QQShareAction:(UIButton *)sender {
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:self.contentTV.text
                                     images:[UIImage imageNamed:@""] //传入要分享的图片
                                        url:[NSURL URLWithString:_contentTV.text]
                                      title:@"优物宝库"
                                       type:SSDKContentTypeAuto];
    
    //进行分享
    [ShareSDK share:SSDKPlatformSubTypeQQFriend //传入分享的平台类型
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....}];
         if (!error) {
             
         }
     }];
}

- (IBAction)WXShareAction:(UIButton *)sender {
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:self.contentTV.text
                                     images:[UIImage imageNamed:@""] //传入要分享的图片
                                        url:[NSURL URLWithString:_contentTV.text]
                                      title:@"分享标题"
                                       type:SSDKContentTypeAuto];
    
    //进行分享
    [ShareSDK share:SSDKPlatformSubTypeWechatSession //传入分享的平台类型
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....}];
     }];

}

- (IBAction)SinaShareAction:(UIButton *)sender {
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:self.contentTV.text
                                     images:[UIImage imageNamed:@""] //传入要分享的图片
                                        url:[NSURL URLWithString:_contentTV.text]
                                      title:@"分享标题"
                                       type:SSDKContentTypeAuto];
    
    //进行分享
    [ShareSDK share:SSDKPlatformTypeSinaWeibo //传入分享的平台类型
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....}];
     }];

}

- (IBAction)QQZoneShareAction:(UIButton *)sender {
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:self.contentTV.text
                                     images:[UIImage imageNamed:@""] //传入要分享的图片
                                        url:[NSURL URLWithString:_contentTV.text]
                                      title:@"分享标题"
                                       type:SSDKContentTypeAuto];
    
    //进行分享
    [ShareSDK share:SSDKPlatformSubTypeQZone //传入分享的平台类型
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....}];
     }];
}

- (IBAction)WXCircleShareAction:(UIButton *)sender {
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:self.contentTV.text
                                     images:[UIImage imageNamed:@""] //传入要分享的图片
                                        url:[NSURL URLWithString:_contentTV.text]
                                      title:@"分享标题"
                                       type:SSDKContentTypeAuto];
    
    //进行分享
    [ShareSDK share:SSDKPlatformSubTypeWechatTimeline //传入分享的平台类型
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....}];
     }];
}
@end
