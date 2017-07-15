//
//  UUshakePlayGameViewController.m
//  UUBaoKu
//
//  Created by admin on 17/3/31.
//  Copyright © 2017年 loongcrown. All rights reserved.
//======================摇一摇玩游戏===========================

#import "UUshakePlayGameViewController.h"

@interface UUshakePlayGameViewController ()<UIWebViewDelegate>
//浏览器webview
@property(strong,nonatomic)UIWebView *PlayGamewebView;
@end

@implementation UUshakePlayGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"摇一摇玩游戏";
    _PlayGamewebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.height-64)];
    [_PlayGamewebView setScalesPageToFit:YES];
    
    _PlayGamewebView.delegate = self;
    
    [_PlayGamewebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webStr]]];
    
    
    _PlayGamewebView.backgroundColor = [UIColor whiteColor];
    
    
    
    
    [self.view addSubview:_PlayGamewebView];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//实现自适应宽度  高度
-(void)webViewDidFinishLoad:(UIWebView *)webView{

    NSString *js = @"function imgAutoFit() { \
    var imgs = document.getElementsByTagName('img'); \
    for (var i = 0; i < imgs.length; ++i) {\
    var img = imgs[i];   \
    img.style.maxWidth = %f;   \
    } \
    }";
    js = [NSString stringWithFormat:js, [UIScreen mainScreen].bounds.size.width - 20];
    
    [webView stringByEvaluatingJavaScriptFromString:js];
    [webView stringByEvaluatingJavaScriptFromString:@"imgAutoFit()"];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
