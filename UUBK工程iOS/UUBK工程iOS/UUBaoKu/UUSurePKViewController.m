//
//  UUSurePKViewController.m
//  UUBaoKu
//
//  Created by admin on 16/10/22.
//  Copyright © 2016年 loongcrown. All rights reserved.
//===========================确定 发起摇一摇==================================

#import "UUSurePKViewController.h"
#import "UIView+Ex.h"
#import "UUSurePKTableViewCell.h"
#import "UUPKViewController.h"


@interface UUSurePKViewController ()

@property(strong,nonatomic)UITableView *SurePKtableView;
//冠军名称
@property(strong,nonatomic)UILabel *championLabel;
//冠军图标
@property(strong,nonatomic)UIImageView *championImageView;
//冠军胜利次数
@property(strong,nonatomic)NSString *championNum;
//亚军名称
@property(strong,nonatomic)UILabel *runnerLabel;
//亚军图标
@property(strong,nonatomic)UIImageView *runnerImageView;
//亚军胜利次数
@property(strong,nonatomic)NSString *runnerNum;
//季军名称
@property(strong,nonatomic)UILabel *ThirdLabel;
//季军图标
@property(strong,nonatomic)UIImageView *ThirdImageView;
//季军胜利次数
@property(strong,nonatomic)NSString *ThirdNum;

//排名array
@property(strong,nonatomic)NSArray *SortArray;
//冠军label
@property(strong,nonatomic)UILabel *ThirdWinLabel;


//冠军分享次数
@property(strong,nonatomic)UILabel *winlabel;
//亚军分享次数
@property(strong,nonatomic)UILabel *winlabel1;
//季军分享次数
@property(strong,nonatomic)UILabel *winlabel2;


//冠军头像
@property(strong,nonatomic)UIImageView *iconView;
//亚军头像
@property(strong,nonatomic)UIImageView *iconView1;
//季军头像

@property(strong,nonatomic)UIImageView *iconView2;


//冠军名称
@property(strong,nonatomic)UILabel *nameLabel;
//亚军名称
@property(strong,nonatomic)UILabel *nameLabel1;
//季军名称
@property(strong,nonatomic)UILabel *nameLabel2;

@end



@implementation UUSurePKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self getUUSurePKData];
    
    self.SortArray = [NSArray new];
    
    self.navigationItem.title =@"发起摇一摇PK";
    
    self.view.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:246/255.0];
    
 }
-(void)MakeUI{
     UIView *View = [[UIView alloc] initWithFrame:CGRectMake(19, 34.5, self.view.width-38, 198.5)];
    View.layer.masksToBounds = YES;
    View.layer.cornerRadius = 10;
    View.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:View];
    
    
    UIImageView *marksView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 21.4)];
    [marksView setImage:[UIImage imageNamed:@"左括号"]];
    [View addSubview:marksView];
    UIImageView *marksView1 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width-38-30, 170, 25, 21.4)];
    [marksView1 setImage:[UIImage imageNamed:@"右括号"]];
    [View addSubview:marksView1];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.width-59.5)/2, 5, 60, 60)];
    [imageView setImage:[UIImage imageNamed:@"Pk图标"]];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 30;
    
    [self.view addSubview:imageView];
    
    
    NSString *str =@"选择发起摇一摇PK 系统会自动为你匹配最近一段时间同样发起PK的分享圈";
    
    
    NSString *str1 =@"在选择发起PK后的第一个周六中午12点开始PK 同时会自动跟新分享圈公告";
    
    
    NSString *str2 = @"发动你的圈友们一起来参与PK吧";
    
    
    UILabel *descLable=[[UILabel alloc] init];
    [descLable setNumberOfLines:0];
    descLable.lineBreakMode = UILineBreakModeCharacterWrap;
    descLable.text = str;
    descLable.font = [UIFont systemFontOfSize:12];
    descLable.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
    
    UIFont *font = [UIFont fontWithName:@"Arial" size:13];
    CGSize size = CGSizeMake(self.view.width-19*2-21*2, MAXFLOAT);
    CGSize labelsize = [str sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeCharacterWrap];
    
    [descLable setFrame:CGRectMake(21, 43.5,self.view.width-19*2-21*2, labelsize.height)];
    [View addSubview:descLable];
    
    UILabel *descLable1=[[UILabel alloc] init];
    [descLable1 setNumberOfLines:0];
    descLable1.lineBreakMode = UILineBreakModeCharacterWrap;
    descLable1.text = str1;
    descLable1.font = [UIFont systemFontOfSize:13];
    descLable1.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
    
    
    [descLable1 setFrame:CGRectMake(21, 90,self.view.width-19*2-21*2, labelsize.height)];
    [View addSubview:descLable1];
    
    UILabel *descLable2=[[UILabel alloc] init];
    [descLable2 setNumberOfLines:0];
    descLable2.lineBreakMode = UILineBreakModeCharacterWrap;
    descLable2.text = str2;
    descLable2.font = [UIFont systemFontOfSize:13];
    descLable2.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
    
    
    [descLable2 setFrame:CGRectMake(21, 135,self.view.width-19*2-21*2, labelsize.height)];
    [View addSubview:descLable2];
    
    UIButton *Btn = [[UIButton alloc] initWithFrame:CGRectMake(26.5, 259, self.view.width-26.6-26, 40)];
    Btn.layer.masksToBounds = YES;
    Btn.layer.cornerRadius =2.5;
    Btn.backgroundColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
    [Btn addTarget:self action:@selector(Initiated) forControlEvents:UIControlEventTouchUpInside];
    [Btn setTitle:@"发起摇一摇PK" forState:UIControlStateNormal];
    Btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    [self.view addSubview:Btn];
    
    
    UILabel *testLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.view.width-150)/2, 316, 150, 18.5)];
    testLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    
     testLabel.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
    testLabel.textAlignment = NSTextAlignmentCenter;
    
    NSMutableAttributedString *AttributedStr11 = [[NSMutableAttributedString alloc]initWithString:@"优物宝库PK排行榜前三甲"];
    
    
    [AttributedStr11 addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:13]
     
                          range:NSMakeRange(8, 3)];
    
    [AttributedStr11 addAttribute:NSForegroundColorAttributeName
     
                          value:MainCorlor
     
                          range:NSMakeRange(9, 3)];
    
    testLabel.attributedText = AttributedStr11;
   
    [self.view addSubview:testLabel];
    
    
 //    [self.view addSubview:label];
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(18.5, 343.7, self.view.width-18.5*2, 180)];
    
    sectionView.backgroundColor = [UIColor whiteColor];
    
    //两根分割线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 60,  self.view.width-18.5*2, 2)];
    
    line.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    
    
    [sectionView addSubview:line];
    
    
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 120,  self.view.width-18.5*2, 2)];
    
    line1.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    
    
    [sectionView addSubview:line1];
    //第一行
    UILabel *championLabel = [[UILabel alloc] initWithFrame:CGRectMake(9.5, 21, 7, 17.5)];
    self.championLabel = championLabel;
    championLabel.textColor= [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
    championLabel.font = [UIFont fontWithName:@"SFNSDisplay-Regular" size:15];
    championLabel.text = @"1";
    
    [sectionView addSubview:championLabel];
    
    //奖杯
    UIImageView*
    TrophyimageView = [[UIImageView alloc] initWithFrame:CGRectMake(25.5, 19.3, 24.3, 25)];
    [TrophyimageView setImage:[UIImage imageNamed:@"金奖杯"]];
    
    [sectionView addSubview:TrophyimageView];
    //头像
    UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(69.5, 14.5, 40, 40)];
    self.iconView = iconView;
    [iconView setImage:[UIImage imageNamed:@"PKred"]];
    iconView.layer.masksToBounds = YES;
    iconView.layer.cornerRadius = 20;
    [sectionView addSubview:iconView];
    //名称
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(127.5, 11.5, 250, 21)];
    
    self.nameLabel = nameLabel;
    
    nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    nameLabel.text = @"George Pearson";
    nameLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
    [sectionView addSubview:nameLabel];
    
    //
    UILabel *WinLabel = [[UILabel alloc]initWithFrame:CGRectMake(120.5, 37, 120, 14)];
    
    WinLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    
    WinLabel.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
    WinLabel.textAlignment = NSTextAlignmentCenter;
    
    WinLabel.text = @"带领自己的分享圈胜利了";
    [sectionView addSubview:WinLabel];
    
    UILabel *winlabel0 = [[UILabel alloc] initWithFrame:CGRectMake(120.5+120, 37, 30, 14)];
    self.winlabel = winlabel0;
    winlabel0.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    
    winlabel0.textColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
    if (self.SortArray.count>0) {
        NSLog(@"前三甲的数据-=--=%@",[self.SortArray[0] valueForKey:@"winNum"]);
        
        winlabel0.text =[NSString stringWithFormat:@"%@",[self.SortArray[0] valueForKey:@"winNum"]];

    }
    
    
    [sectionView addSubview:winlabel0];
    
    //次
    UILabel *timesLabel0 = [[UILabel alloc] initWithFrame:CGRectMake(120.5+120+30-20, 37, 30, 14)];
    
    timesLabel0.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    
    timesLabel0.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
    timesLabel0.text = @"次！";
    
    [sectionView addSubview:timesLabel0];
    

   [self.view addSubview:sectionView];
    
 

}
//发起摇一摇PK
-(void)Initiated{
    
    [self showOkayCancelAlert];
    [self getPKData];


}
//  弹窗  警示框
- (void)showOkayCancelAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"匹配成功" message:@"本周六中午12点开始PK！召集你的圈友一起摇一摇吧！" preferredStyle:UIAlertControllerStyleAlert];
    //    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"提示内容" preferredStyle:UIAlertControllerStyleActionSheet];
    
    
   
    
    
    
    
    
    UIAlertAction *cancelAction =[UIAlertAction actionWithTitle:@"返回分享圈首页" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        UIViewController *viewCtl = self.navigationController.viewControllers[0];
        
        [self.navigationController popToViewController:viewCtl animated:YES];
        

    }];
    
    
    
    [cancelAction setValue:MainCorlor forKey:@"titleTextColor"];
    
    
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

//获取数据
-(void)getUUSurePKData{
    
    NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Zone&a=getPkRank"];
//    NSString *str=[NSString stringWithFormat:@"%@Zone/getPkRank",notWebsite];
    
    NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    //    NSDictionary *dic = @{@"articleId":@"1"};
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"摇一摇数据＝＝%@",responseObject);
        
        if ([[responseObject valueForKey:@"code"] intValue]==200){
         
            
            
            self.SortArray = [responseObject valueForKey:@"data"];
            
            [self MakeUI];
            //         --- 模拟加载延迟
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if (self.SortArray.count>0) {
                    self.winlabel.text = [NSString stringWithFormat:@"%@",[self.SortArray[0] valueForKey:@"winsNum"]];
                    
                    
                    [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[self.SortArray[0] valueForKey:@"userIcon"]]]];
                    
                    
                    
                    self.nameLabel.text =[NSString stringWithFormat:@"%@",[self.SortArray[0] valueForKey:@"userName"]];
                }
                
                
               
            });

        
        }else{
        
            [self showAlert:@"获取数据失败"];
        
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];
}

//发起摇一摇pk

-(void)getPKData{
    
    NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Zone&a=addPk"];
    
//    NSString *str=[NSString stringWithFormat:@"%@Zone/addPk",notWebsite];
    NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSDictionary *dic = @{@"userId":[NSString stringWithFormat:@"%@",UserId]};
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"发起摇一摇PK＝＝%@",responseObject);
        
        
        if ([[responseObject valueForKey:@"code"] intValue]==200) {
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];
}
//自动弹窗
- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}


- (void)showAlert:(NSString *) _message{//时间
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:1.5f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
}

@end
