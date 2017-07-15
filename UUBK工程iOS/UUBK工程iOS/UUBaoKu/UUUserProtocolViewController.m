//
//  UUUserProtocolViewController.m
//  UUBaoKu
//
//  Created by dev2 on 2017/6/14.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUUserProtocolViewController.h"

@interface UUUserProtocolViewController ()

@end

@implementation UUUserProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 33, 8.9, 15)];
    
    [leftBtn setImage:[UIImage imageNamed:@"白条返回"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(backAction)forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 28, kScreenWidth- 60, 24.5)];
    [self.view addSubview:titleLab];
    titleLab.text = @"优物宝库注册协议";
    titleLab.textColor = UURED;
    titleLab.font = [UIFont systemFontOfSize:17.5];
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
    webView.scalesPageToFit = YES;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m2.uubaoku.com/Activity/AgreeMent?isapp=1"]]];
    [self.view addSubview:webView];
    // Do any additional setup after loading the view.
}


- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
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
