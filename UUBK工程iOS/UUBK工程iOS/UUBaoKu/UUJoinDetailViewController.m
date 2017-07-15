//
//  UUJoinDetailViewController.m
//  UUBaoKu
//
//  Created by dev2 on 2017/6/10.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUJoinDetailViewController.h"
#import <WebKit/WebKit.h>
@interface UUJoinDetailViewController ()<
WKUIDelegate,
WKNavigationDelegate>
@property(nonatomic,strong)WKWebView *webView;
@end
static NSString *const joinRecordCellId = @"UULuckJoinRecordCell";
@implementation UUJoinDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpWebView];
        // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:UURED}];
}
- (void)setUpWebView{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 1, kScreenWidth, kScreenHeight - 65) configuration:config];
    [self.view addSubview:self.webView];
    if (self.goodsInfo) {
        _goodsInfo = [self.goodsInfo stringByReplacingOccurrencesOfString:@"<img" withString:@"<img style = \"width:100%\""];
        [_webView loadHTMLString:_goodsInfo baseURL:nil];
    }else if (self.goodsUrl){
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.goodsUrl]]];
    }else{
        NSString *urlStr = @"";
        if ([self.title isEqualToString:@"近期揭晓"]) {
            urlStr = [NSString stringWithFormat:@"http://g2.uubaoku.com/pdetail_winrecord/%@?isapp=1",self.TuanID];
        }else if ([self.title isEqualToString:@"晒单分享"]){
            urlStr = [NSString stringWithFormat:@"http://g2.uubaoku.com/pdetail_share/%@?isapp=1",self.TuanID];
        }else{
            urlStr = [NSString stringWithFormat:@"http://g2.uubaoku.com/orderlist/%@?isapp=1",self.TuanID];
        }
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];

    }
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    
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

@end
