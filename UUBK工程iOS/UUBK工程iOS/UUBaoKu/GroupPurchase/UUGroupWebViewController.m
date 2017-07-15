//
//  UUGroupWebViewController.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/20.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUGroupWebViewController.h"
#import <WebKit/WebKit.h>
#import "UUGroupTabBarController.h"
#import "UUMakeMoneyViewController.h"
#import "UUShareView.h"

@interface UUGroupWebViewController ()<
WKUIDelegate,
WKNavigationDelegate,
WKScriptMessageHandler>
@property(nonatomic,strong)WKWebView *webView;
@property(nonatomic,strong)UIView *shareView;
@end

@implementation UUGroupWebViewController
- (UIView *)shareView{
    if (!_shareView) {
        _shareView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _shareView.backgroundColor = [UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:0.7];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareViewHiden)];
        [_shareView addGestureRecognizer:tap];
        UUShareView *contentView = [[UUShareView alloc]initWithFrame:CGRectMake(0, kScreenWidth-320-49, kScreenWidth, 320)];
        [_shareView addSubview:contentView];
    }
    return _shareView;
}

- (void)shareViewHiden{
    [_shareView removeFromSuperview];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUNG_COLOR;
    [self setUpWebView];
    // Do any additional setup after loading the view.
}

- (void)Share{
    [self.view addSubview:self.shareView];
}
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:UURED}];
}

- (void)setUpWebView{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.preferences.minimumFontSize = 18;
    self.webView = [[WKWebView alloc]initWithFrame:self.view.bounds configuration:config];
    [self.view addSubview:self.webView];
    NSString *urlStr;
    
    if (self.webType == GroupTJJXDetailWebType) {
        self.title = @"拼团详情";
        urlStr = [NSString stringWithFormat:@"http://g2.uubaoku.com/TeamBuy/GroupDetail?orderno=%@&isapp=1",self.orderNo];
    }
    if (self.webType == GroupXYJoinWebType) {
        self.title = @"邀请参团";
        urlStr = [NSString stringWithFormat:@"http://g2.uubaoku.com/payment/orderdetail?orderno=%@&isapp=1",self.orderNo];
    }else if (self.webType == GroupXYDetailWebType){
        self.title = @"幸运详情";
        urlStr = [NSString stringWithFormat:@"http://g2.uubaoku.com/issuedetail/%@?isapp=1",self.orderNo];
    }else if (self.webType == GroupTJJXJoinWebType){
        self.title = @"邀请参团";
        urlStr = [NSString stringWithFormat:@"http://g2.uubaoku.com/TeamBuy/GroupDetail?orderno=%@&sharety&isapp=1",self.orderNo];
    }else if (self.webType == GroupBQJoinWebType){
        self.title = @"邀请参团";
        urlStr = [NSString stringWithFormat:@"http://g2.uubaoku.com/team/joindetail/%@?enjoiy=1&isapp=1",self.teamId];
    }else if(self.webType == GroupBQDetailWebType){
        self.title = @"拼团详情";
        urlStr = [NSString stringWithFormat:@"http://g2.uubaoku.com/team/joindetail/%@/?isapp=1",self.orderNo];
    }else if (self.webType == GroupXYCheckNumWebType){
        self.title = @"参团号码";
        urlStr = @"http://g2.uubaoku.com/viewluck/3726?isapp=1";
    }else if (self.webType== GroupQYDetailWebType){
        self.title = @"幸运详情";
        urlStr = @"http://g2.uubaoku.com/issuedetail/190?isapp = 1";
    }else if (self.webType == GroupBQLuckyDetailWebType){
        self.title = @"幸运详情";
        urlStr = [NSString stringWithFormat:@"http://g2.uubaoku.com/team/teamrewarddetail/%@?isapp=1",self.orderNo];
    }
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    WKUserContentController *userCC = config.userContentController;
    [userCC addScriptMessageHandler:self name:@"back"];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"%@",webView.URL.absoluteString);
    
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSURL *URL = navigationAction.request.URL;
    NSString *urlStr = [NSString stringWithFormat:@"%@",URL];
    NSLog(@"%@",urlStr);
    NSArray *components = [urlStr componentsSeparatedByString:@"|"];
    NSLog(@"=components=====%@",components);
    
    
    NSString *str1 = [components objectAtIndex:0];
    NSLog(@"str1:::%@",str1);
    
    
    NSArray *array2 = [str1 componentsSeparatedByString:@"/"];
    NSLog(@"array2:====%@",array2);
    
    
    NSInteger coun = array2.count;
    NSString *method = array2[coun-1];
    NSLog(@"method:===%@",method);
    if ([urlStr isEqualToString:@"http://g.uubaoku.com/Team/Index"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        UUGroupTabBarController *groupVC = [UUGroupTabBarController new];
        groupVC.selectedIndex = 3;
        [self presentViewController:groupVC animated:YES completion:nil];

    }else if ([urlStr isEqualToString:@"http://m.uubaoku.com/Activity/PrivateSavings"]){
        decisionHandler(WKNavigationActionPolicyCancel);
        [self.navigationController pushViewController:[UUMakeMoneyViewController new] animated:YES];
    }else if ([urlStr isEqualToString:@"http://m.uubaoku.com/Activity/PrivateSavings"]){
        decisionHandler(WKNavigationActionPolicyCancel);
        
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
