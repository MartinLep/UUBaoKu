//
//  UUmergeViewController.m
//  UUBaoKu
//
//  Created by admin on 16/10/22.
//  Copyright © 2016年 loongcrown. All rights reserved.
//
//========================合并到指定分享圈==============================
#import "UUmergeViewController.h"
#import "UIView+Ex.h"
#import "UUaddaimsTableViewCell.h"

@interface UUmergeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)UITableView *mergeTableView;
@property(strong,nonatomic)UITextField *addadmin;
//存放目标联系人的字典
@property(strong,nonatomic)NSDictionary *addaimsDic;

//转让朋友圈
@property(assign,nonatomic)int subOfTargetUser;
//用户编号
@property(assign,nonatomic)NSNumber *targetUserId;


@end

@implementation UUmergeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.subOfTargetUser = 0;
    [self setUpForDismisskeyboard];
    self.navigationItem.title =@"合并到指定分享圈";
    self.mergeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-49)];

    self.mergeTableView.delegate =self;
    self.mergeTableView.dataSource =self;
    
    UIView *mergetableFootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-301.5)];
    mergetableFootView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:242/255.0 alpha:1];
    
    self.mergeTableView.tableFooterView = mergetableFootView;
    
    [self.view addSubview:self.mergeTableView];
    
    
    
    
    //navigation  右侧按钮
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 25)];
    rightButton.layer.masksToBounds = YES;
    rightButton.layer.cornerRadius = 2.5;
    
    rightButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.5];
    [rightButton setTitle:@"合并" forState:UIControlStateNormal];
   
    rightButton.backgroundColor = MainCorlor;
    
    [rightButton addTarget:self action:@selector(merge)forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem= rightItem;
    
    
    
}

#pragma tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==2) {
        if (self.addaimsDic !=nil) {
            return 1;
        }else{
            return 0;
        }
    }else{
    
    
    }
    return 1;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        UILabel *NameLabel = [[UILabel alloc] initWithFrame:CGRectMake(18.5, 0, 200, 50)];
        NameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        NameLabel.text = @"自身是否合并指定分享圈";
        
        [cell addSubview:NameLabel];
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-64, 10, 34, 20.5)];
        
        [switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        
        switchView.transform = CGAffineTransformMakeScale(0.7, 0.7);
        switchView.onTintColor = MainCorlor;
        [cell addSubview:switchView];
        
        return cell;
    }else if (indexPath.section ==1){
    
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        UILabel *Lable = [[UILabel alloc] initWithFrame:CGRectMake(58.5, 37, 49, 26.5)];
        
        Lable.font = [UIFont fontWithName:@"SFUIText-Regular" size:22];
        Lable.text =@"+86";
        Lable.textColor = [UIColor colorWithRed:93/255.0 green:93/255.0 blue:93/255.0 alpha:1];
        
        [cell addSubview:Lable];
        
        
        UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(118, 40, 200, 21)];
        
        self.addadmin = textfield;
        [textfield setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:15]];
        textfield.keyboardType = UIKeyboardTypeNumberPad;
        textfield.placeholder = @"请输入指定手机号";
        
        [cell addSubview:textfield];
        
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(45, 74.5, self.view.width-90, 1)];
        
        line.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        
        [cell addSubview:line];
        UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width/2-75, 94, 150, 30)];
        [sureBtn setTintColor:[UIColor whiteColor]];
        sureBtn.backgroundColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
        sureBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [sureBtn setTitle:@"添加目标合并人" forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(addtarget) forControlEvents:UIControlEventTouchUpInside];
        sureBtn.layer.masksToBounds = YES;
        sureBtn.layer.cornerRadius = 2.5;
        [cell addSubview:sureBtn];
        
        
        return cell;
    
    
    
    }else{
        
    
        UUaddaimsTableViewCell *cell = [UUaddaimsTableViewCell cellWithTableView:tableView];
        
        if (self.addaimsDic.count!=0||[self.addaimsDic isEqual:[NSNull null]] == NO ) {
            
            if ([[self.addaimsDic valueForKey:@"userIcon"] isEqual:[NSNull null]] == NO&&[self.addaimsDic valueForKey:@"userIcon"]!=nil) {
                [cell.addAimsicon sd_setImageWithURL:[NSURL URLWithString:[self.addaimsDic valueForKey:@"userIcon"]]];
            }
            if ([[self.addaimsDic valueForKey:@"userName"] isEqual:[NSNull null]] == NO&&[self.addaimsDic valueForKey:@"userName"]!=nil) {
                cell.userName.text =[self.addaimsDic valueForKey:@"userName"];
            }

            
            
            
        }
        
        
        return cell;
    }
    
    
   
        }
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        return 151;
    }else{
    
    
        return 50;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section==0) {
        return 1.5;
    }else if (section==1){
    
        return 16;
    }else{
    
        return 32;
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
     if (section==2) {
        UIView *sectionBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 100)];
        sectionBackView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:242/255.0 alpha:1];
        
         
         if (self.addaimsDic != nil && ![self.addaimsDic isKindOfClass:[NSNull class]] && self.addaimsDic.count != 0) {
             
             UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width/2-30, 6, 60, 21)];
             label.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
             
             label.textAlignment = NSTextAlignmentCenter;
             label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
             label.text = @"确认信息";
             
             [sectionBackView addSubview:label];
             
         }
         
           
        return sectionBackView;
    }
    UIView *sectionBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 100)];
    sectionBackView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:242/255.0 alpha:1];
    
    return sectionBackView;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

 [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//合并
-(void)merge{

    NSLog(@"合并");
    [self getmergeData];

}
-(void)addtarget{
    
    
    NSLog(@"添加目标合并人");
    [self getAddTargetData];

}
-(void)setUpForDismisskeyboard{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene = [NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification object:nil queue:mainQuene usingBlock:^(NSNotification * _Nonnull note) {
        [self.view addGestureRecognizer:singleTapGR];
    }];
    
    [nc addObserverForName:UIKeyboardWillHideNotification object:nil queue:mainQuene usingBlock:^(NSNotification * _Nonnull note) {
        [self.view removeGestureRecognizer:singleTapGR];
    }];
}
-(void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer{
    
    [self.view endEditing:YES];
}
//添加目标合并人
-(void)getAddTargetData{
   NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Zone&a=getUserByPhone"];
//    NSString *str=[NSString stringWithFormat:@"%@Zone/getUserByPhone",notWebsite];
    NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSString *addadminstr =[NSString stringWithFormat:@"%@",self.addadmin.text];
    
    NSDictionary *dic = @{@"phone":addadminstr};
    
    NSLog(@"phone====%@",self.addadmin.text);
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"添加目标合并人＝＝%@",responseObject);
        
        if ([[responseObject valueForKey:@"code"] intValue]==200) {
            self.addaimsDic = [responseObject valueForKey:@"data"];
        }else{
        
            [self showAlert:[responseObject valueForKey:@"message"]];
        
        }
        
        
        
        [self.mergeTableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];
}

//合并
-(void)getmergeData{
    
   NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Zone&a=mergeZone"];
//    NSString *str=[NSString stringWithFormat:@"%@Zone/mergeZone",notWebsite];
    NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSDictionary *dic = @{@"subOfTargetUser":[NSString stringWithFormat:@"%d",self.subOfTargetUser],@"targetUserId":@"6792",@"zoneId":self.zoneId};
    NSLog(@"参数是%@",dic);
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"合并＝＝%@",responseObject);
        if ([[responseObject valueForKey:@"code"] intValue]==200) {
            [self showAlert:@"合并成功"];
            [[NSNotificationCenter defaultCenter]postNotificationName:RECOMMEND_RELEASE_SUCCESSED object:nil];
            UIViewController *viewCtl = self.navigationController.viewControllers[0];
            [self.navigationController popToViewController:viewCtl animated:YES];
            
            
        }else{
            [self showAlert:@"合并失败"];
        
        }
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];
}

//按钮的开关
-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        self.subOfTargetUser =1;
        NSLog(@"打开");
    }else {
        self.subOfTargetUser = 0;
        NSLog(@"关闭");
    }
}
//自动消失的提示框
- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}
- (void)showAlert:(NSString *) _message{//时间
    
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"提示", @"Location", nil) message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:1.5f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
}

@end
