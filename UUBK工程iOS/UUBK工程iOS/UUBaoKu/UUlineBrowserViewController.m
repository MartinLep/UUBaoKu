//
//  UUlineBrowserViewController.m
//  UUBaoKu
//
//  Created by admin on 2017/4/8.
//  Copyright © 2017年 loongcrown. All rights reserved.
//=====================通过浏览器选择商品==================================

#import "UUlineBrowserViewController.h"

@interface UUlineBrowserViewController ()<UIWebViewDelegate>
//浏览器webview
@property(strong,nonatomic)UIWebView *BrowserwebView;


@property (strong,nonatomic)NSString *currentURL;
@property (strong,nonatomic)NSString *currentTitle;
@property (strong,nonatomic)NSString *currentHTML;


@end

@implementation UUlineBrowserViewController
{
    UIButton *_rightBtn;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title =@"优宝库-手机导航";
    
    //navigation  右侧按钮
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 25)];
    rightButton.layer.masksToBounds = YES;
    rightButton.layer.cornerRadius = 2.5;
    
    rightButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.5];
    [rightButton setTitle:@"确定" forState:UIControlStateNormal];
    rightButton.backgroundColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
    
    [rightButton addTarget:self action:@selector(selectShoppingSure)forControlEvents:UIControlEventTouchUpInside];
    _rightBtn = rightButton;
    rightButton.backgroundColor = UUGREY;
    rightButton.userInteractionEnabled = NO;
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem= rightItem;
    
    _BrowserwebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.height-64)];
    
    
    _BrowserwebView.delegate = self;
    
    [_BrowserwebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://uu.dev.loongcrown.com"]]];
    
    
    _BrowserwebView.backgroundColor = [UIColor whiteColor];
    
    
    
    
    [self.view addSubview:_BrowserwebView];
}

//几个代理方法

- (void)webViewDidStartLoad:(UIWebView *)webView{
    self.title =[_BrowserwebView  stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (self.title.length ==0) {
        self.title = @"购物";
    }
    self.currentURL = _BrowserwebView.request.URL.absoluteString;
    [self addSelectedGoodsWithUrlStr:self.currentURL];
    //    NSLog(@"webViewDidStartLoad");
}
- (void)addSelectedGoodsWithUrlStr:(NSString *)urlStr{
    NSDictionary *para = @{@"userId":UserId,@"URL":urlStr};
    [NetworkTools postReqeustWithParams:para UrlString:kAString(DOMAIN_NAME, GET_GOODS_BY_URL) successBlock:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 000000) {
            _rightBtn.backgroundColor = UURED;
            _rightBtn.userInteractionEnabled = YES;
        }
    } failureBlock:^(NSError *error) {
        
    }];
}
- (void)webViewDidFinishLoad:(UIWebView *)web{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //获取当前页面的title
    
}

-(void)webView:(UIWebView*)webView  DidFailLoadWithError:(NSError*)error{
    
    //    NSLog(@"DidFailLoadWithError");
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1],UITextAttributeTextColor,nil]];
    
}
-(void)selectShoppingSure{
    self.selectedThirdGoods(self.currentURL);
    [self.navigationController popViewControllerAnimated:YES];


}
@end
