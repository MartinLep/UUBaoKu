//
//  UUXYBQViewController.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/16.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUXYBQViewController.h"
#import <WebKit/WebKit.h>
#import "UUMyShareViewController.h"
#import "UULuckGroupDetailViewController.h"
#import "UUBQDetailViewController.h"
#import "UUShareView.h"
@interface UUXYBQViewController ()<
WKUIDelegate,
WKNavigationDelegate,
WKScriptMessageHandler>
@property(nonatomic,strong)WKWebView *webView;
@property(nonatomic,strong)UIView *shareView;


@end

@implementation UUXYBQViewController
{
    UUShareView *_contentView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 8.9, 15)];
    
    [leftBtn setImage:[UIImage imageNamed:@"白条返回"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(backAction)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem=leftItem ;
    [self setUpWebView];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = BACKGROUNG_COLOR;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:UURED}];
    
}

- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setUpWebView{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.preferences.minimumFontSize = 18;
    self.webView = [[WKWebView alloc]initWithFrame:self.view.bounds configuration:config];
    [self.view addSubview:self.webView];
    NSString *urlStr = @"http://g2.uubaoku.com/team/Index/?isapp=1";
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    WKUserContentController *userCC = config.userContentController;
    [userCC addScriptMessageHandler:self name:@"back"];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"%@",webView.URL.absoluteString);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSURL *URL = navigationAction.request.URL;
    NSString *urlStr = [NSString stringWithFormat:@"%@",URL];
    NSArray *components = [urlStr componentsSeparatedByString:@"|"];
    NSLog(@"=components=====%@",components);
    
    
    NSString *str1 = [components objectAtIndex:0];
    NSLog(@"str1:::%@",str1);
    
    
    NSArray *array2 = [str1 componentsSeparatedByString:@"/"];
    NSLog(@"array2:====%@",array2);
    
    
    NSInteger coun = array2.count;
    NSString *method = array2[coun-1];
    NSLog(@"method:===%@",method);
    if ([method rangeOfString:@"EarnIntegral"].location != NSNotFound ) {
        //
        decisionHandler(WKNavigationActionPolicyCancel);
        [self.navigationController pushViewController:[UUMyShareViewController new] animated:YES];
        //        return;
    }else if ([urlStr rangeOfString:@"pubtuan"].location != NSNotFound){
        decisionHandler(WKNavigationActionPolicyCancel);
        UULuckGroupDetailViewController *luckDetail = [UULuckGroupDetailViewController new];
        luckDetail.isPutuan = 1;
        luckDetail.paraStr = method;
        [self.navigationController pushViewController:luckDetail animated:YES];
    }else if ([urlStr rangeOfString:@"pdetail"].location != NSNotFound){
        decisionHandler(WKNavigationActionPolicyCancel);
        UULuckGroupDetailViewController *luckDetail = [UULuckGroupDetailViewController new];
        luckDetail.isPutuan = 0;
        luckDetail.paraStr = method;
        [self.navigationController pushViewController:luckDetail animated:YES];
    }else if ([urlStr rangeOfString:@"detail"].location != NSNotFound||[urlStr rangeOfString:@"team/pay"].location != NSNotFound){
        decisionHandler(WKNavigationActionPolicyCancel);
        UUBQDetailViewController *BQDetail = [UUBQDetailViewController new];
        BQDetail.TeamID = method;
        [self.navigationController pushViewController:BQDetail animated:YES];
    }else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    
}
- (UIView *)shareView{
    if (!_shareView) {
        _shareView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _shareView.backgroundColor = [UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:0.7];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareViewHiden)];
        [_shareView addGestureRecognizer:tap];
        _contentView = [[UUShareView alloc]initWithFrame:CGRectMake(0, self.view.height-320-49, kScreenWidth, 320)];
        [_shareView addSubview:_contentView];
    }
    return _shareView;
}

- (void)shareViewHiden{
    [_shareView removeFromSuperview];
}

@end
