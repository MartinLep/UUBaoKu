//
//  UUSponsorPKViewController.m
//  UUBaoKu
//
//  Created by dev2 on 2017/6/5.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUSponsorPKViewController.h"

@interface UUSponsorPKViewController ()
- (IBAction)sponsorAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIView *thirdView;
@property (weak, nonatomic) IBOutlet UIImageView *firstIcon;
@property (weak, nonatomic) IBOutlet UILabel *firstName;
@property (weak, nonatomic) IBOutlet UILabel *firstDesc;
@property (weak, nonatomic) IBOutlet UIImageView *secondIcon;
@property (weak, nonatomic) IBOutlet UILabel *secondName;
@property (weak, nonatomic) IBOutlet UILabel *secondDesc;
@property (weak, nonatomic) IBOutlet UIImageView *thirdIcon;
@property (weak, nonatomic) IBOutlet UILabel *thirdName;
@property (weak, nonatomic) IBOutlet UILabel *thirdDesc;

@end

@implementation UUSponsorPKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发起摇一摇PK";
    [self getPKData];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getPKData{
    NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Zone&a=getPkRank"];
    [NetworkTools postReqeustWithParams:nil UrlString:str successBlock:^(id responseObject) {
        NSLog(@"..........%@............",responseObject);
        if ([responseObject[@"code"]integerValue] == 200) {
            NSArray *dataSource = responseObject[@"data"];
            if (dataSource.count > 0) {
                
            }else{
                [self showHint:@"暂无三甲数据"];
                self.firstView.hidden = YES;
                self.secondView.hidden = YES;
                self.thirdView.hidden = YES;
            }
        }else{
            [self showHint:responseObject[@"message"]];
            
        }
    } failureBlock:^(NSError *error) {
        
    }];
}
- (IBAction)sponsorAction:(id)sender {
    [self getSponsorPKData];
}

//  弹窗  警示框
- (void)showOkayCancelAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"匹配成功" message:@"本周六中午12点开始PK！召集你的圈友一起摇一摇吧！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction =[UIAlertAction actionWithTitle:@"返回分享圈首页" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        UIViewController *viewCtl = self.navigationController.viewControllers[0];
        
        [self.navigationController popToViewController:viewCtl animated:YES];
        
        
    }];
    [cancelAction setValue:MainCorlor forKey:@"titleTextColor"];
    
    
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)getSponsorPKData{
    
    NSString *urlStr=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Zone&a=addPk"];
    NSDictionary *dic = @{@"userId":[NSString stringWithFormat:@"%@",UserId]};
    [NetworkTools postReqeustWithParams:dic UrlString:urlStr successBlock:^(id responseObject) {
        NSLog(@"...........%@................",responseObject);
        
        if ([responseObject[@"code"]integerValue] == 000000) {
            [self showOkayCancelAlert];
        }else{
            [self showOkayCancelAlert];
            [self showHint:responseObject[@"message"]];
        }
    } failureBlock:^(NSError *error) {
        
    }];
}

@end
