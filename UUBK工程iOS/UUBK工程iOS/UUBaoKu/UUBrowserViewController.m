//
//  UUBrowserViewController.m
//  UUBaoKu
//
//  Created by admin on 17/3/14.
//  Copyright © 2017年 loongcrown. All rights reserved.
//======================浏览器==================

#import "UUBrowserViewController.h"
#import "UUShareView.h"

@interface UUBrowserViewController ()<UIWebViewDelegate>
//浏览器webview
@property(strong,nonatomic)UIWebView *BrowserwebView;
@property(strong,nonatomic)UIView *shareView;


@end

@implementation UUBrowserViewController

- (UIView *)shareView{
    if (!_shareView) {
        _shareView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _shareView.backgroundColor = [UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:0.7];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareViewHiden)];
        [_shareView addGestureRecognizer:tap];
        UUShareView *contentView = [[UUShareView alloc]initWithFrame:CGRectMake(0, self.view.height-320, kScreenWidth, 320)];
        [_shareView addSubview:contentView];
    }
    return _shareView;
}

- (void)shareViewHiden{
    [_shareView removeFromSuperview];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title =@"优宝库-手机导航";
    //navigation  右侧按钮
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15.7, 20)];
    
    [rightButton setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
    
    [rightButton addTarget:self action:@selector(shareShow)forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem= rightItem;

    
    
    _BrowserwebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.height-64)];
    
    
    _BrowserwebView.delegate = self;
    
    [_BrowserwebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr?self.urlStr:@"http://uu.dev.loongcrown.com"]]];
    
    
    _BrowserwebView.backgroundColor = [UIColor whiteColor];
    
   
    
   
    [self.view addSubview:_BrowserwebView];
    
    
}

- (void)shareShow{
    
   [self.view addSubview:self.shareView];

}

//几个代理方法

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    //    NSLog(@"webViewDidStartLoad");
    
}

- (void)webViewDidFinishLoad:(UIWebView *)web{
   
    //    self.title = [_webView stringByEvaluatingJavaScriptFromString:self.post_title];
    
    //    self.navigationItem.title =self.post_title;
    
    //    NSLog(@"webViewDidFinishLoad");
    
}

-(void)webView:(UIWebView*)webView  DidFailLoadWithError:(NSError*)error{
    
    //    NSLog(@"DidFailLoadWithError");
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1],UITextAttributeTextColor,nil]];

}


@end
