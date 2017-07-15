//
//  UUuserMoreDataViewController.m
//  UUBaoKu
//
//  Created by admin on 16/11/10.
//  Copyright © 2016年 loongcrown. All rights reserved.
//===================个人详细资料========================

#import "UUuserMoreDataViewController.h"

@interface UUuserMoreDataViewController ()<UITableViewDelegate,UITableViewDataSource>
//tableview
@property(strong,nonatomic)UITableView *moreDatTableView;
//选中好友的id
@property(strong,nonatomic)NSString *friendId ;
//警示框中输入的验证消息
@property(strong,nonatomic)NSString *sureStr;
@end

@implementation UUuserMoreDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self searchFriendMoredata];
    NSLog(@"个人数据的到的数据是＝－＝－＝－＝－%@",self.otheruserid);
    self.navigationItem.title = @"详细资料";
    
    self.moreDatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-64)];
    
    
   
    [self.view addSubview:self.moreDatTableView];

}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section ==0) {
        return 1;
    }
    else{
    
    
        return 5;
    }
  }
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section ==0) {
        
        UITableViewCell *cell = [[UITableViewCell alloc] init];
         [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        UIImageView *View = [[UIImageView alloc] initWithFrame:CGRectMake(24, 15.5, 65, 65)];
        View.layer.masksToBounds = YES;
        View.layer.cornerRadius = View.width/2;
        
        
        NSString *iconViewStr =[_UUserData valueForKey:@"FaceImg"];
        [View sd_setImageWithURL:[NSURL URLWithString:iconViewStr]];
        
       
        
        [cell addSubview:View];
        
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(108, 38, 200, 21)];
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17.5];
        
        label.text =[_UUserData valueForKey:@"NickName"];
        
        label.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
        
        
        [cell addSubview:label];
        return cell;
    }
     if (indexPath.row==0) {
         
        UITableViewCell *menucell = [[UITableViewCell alloc] init];
       [menucell setSelectionStyle:UITableViewCellSelectionStyleNone];
        UIImageView *menuView = [[UIImageView alloc]initWithFrame:CGRectMake(24.5, 13, 14, 23.6)];
        [menuView setImage:[UIImage imageNamed:@"手机"]];
        [menucell addSubview:menuView];
        UILabel *menulabel = [[UILabel alloc] initWithFrame:CGRectMake(48, 15.5, 105, 21)];
        menulabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        menulabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
         menulabel.text =[_UUserData valueForKey:@"Mobile"];
        [menucell addSubview:menulabel];
        return menucell;
        
    }else if (indexPath.row ==1){
        
        
            UITableViewCell *menucell = [[UITableViewCell alloc] init];
        [menucell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        
        if ([[self.UUserData valueForKey:@"IsDistributor"] intValue]==1) {
            menucell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UIImageView *menuView = [[UIImageView alloc]initWithFrame:CGRectMake(23, 16.5, 17.7, 17.5)];
            [menuView setImage:[UIImage imageNamed:@"iconfontQuanzi"]];
            [menucell addSubview:menuView];
            UILabel *menulabel = [[UILabel alloc] initWithFrame:CGRectMake(48, 15.5, 105, 21)];
            menulabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            menulabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
            menulabel.text = @"他的优物空间";
            [menucell addSubview:menulabel];

        }
        
        
        
        return menucell;
            

               
        
    }else if (indexPath.row ==3){
        
       
      
        
        UITableViewCell *menucell = [[UITableViewCell alloc] init];
         [menucell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if ([[self.UUserData valueForKey:@"IsDistributor"] intValue]==1) {
            UIImageView *menuView = [[UIImageView alloc]initWithFrame:CGRectMake(22, 15, 17.5, 20.4)];
            [menuView setImage:[UIImage imageNamed:@"升级蜂忙士"]];
            [menucell addSubview:menuView];
            UILabel *menulabel = [[UILabel alloc] initWithFrame:CGRectMake(48, 15.5, 105, 21)];
            menulabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            menulabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
            menulabel.text = @"分销等级：";
            [menucell addSubview:menulabel];
            
            
            UILabel *menulabel1 = [[UILabel alloc] initWithFrame:CGRectMake(120, 15.5, 105, 21)];
            menulabel1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            menulabel1.textColor = MainCorlor;
            menulabel1.text = [self.UUserData valueForKey:@"DistributorDegreeName"];
            [menucell addSubview:menulabel1];
            
            
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(157.5, 6, 40, 40)];
            if ([ menulabel1.text isEqualToString:@"金牌"]) {
                menulabel1.textColor = [UIColor colorWithRed:241/255.0 green:178/255.0 blue:81/255.0 alpha:1];
                [imageView setImage:[UIImage imageNamed:@"bitmap_2"] ];
            }else if ([ menulabel1.text isEqualToString:@"银花"]){
                
                menulabel1.textColor = [UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:1];
                [imageView setImage:[UIImage imageNamed:@"bitmap_3"] ];
            }else{
                
                menulabel1.textColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
                [imageView setImage:[UIImage imageNamed:@"bitmap"] ];
            }

            [menucell addSubview:imageView];

        }
        
        
        return menucell;
        
    }else if (indexPath.row ==4){
        
        UITableViewCell *menucell = [[UITableViewCell alloc] init];
       [menucell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if ([[self.UUserData valueForKey:@"IsSupplier"] intValue]==1) {
        
        
        
        
        UIImageView *menuView = [[UIImageView alloc]initWithFrame:CGRectMake(21.5, 18.5, 17.5, 17.5)];
        [menuView setImage:[UIImage imageNamed:@"申请供货商"]];
        [menucell addSubview:menuView];
        UILabel *menulabel = [[UILabel alloc] initWithFrame:CGRectMake(48, 15.5, 105, 21)];
        menulabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        menulabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        menulabel.text = @"供货等级：";
        [menucell addSubview:menulabel];
       
        UILabel *menulabel1 = [[UILabel alloc] initWithFrame:CGRectMake(120, 15.5, 105, 21)];
        menulabel1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        menulabel1.textColor = [UIColor colorWithRed:245/255.0 green:166/255.0 blue:35/255.0 alpha:1];
        
        menulabel1.text = @"货郎";
        [menucell addSubview:menulabel1];
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(157.5, 6, 40, 40)];
        imageView.backgroundColor = [UIColor redColor];
        [menucell addSubview:imageView];
            
        }

        return menucell;
        
        
    }else {
        //第二段第三行
        UITableViewCell *menucell = [[UITableViewCell alloc] init];
        
       [menucell setSelectionStyle:UITableViewCellSelectionStyleNone];
        NSArray *array = [self.UUserData valueForKey:@"Imgs"];
        if (array != nil && ![array isKindOfClass:[NSNull class]] && array.count != 0) {
            UIImageView *menuView = [[UIImageView alloc]initWithFrame:CGRectMake(24.5, 13, 18.6, 14.2)];
            [menuView setImage:[UIImage imageNamed:@"相册"]];
            [menucell addSubview:menuView];
            UILabel *menulabel = [[UILabel alloc] initWithFrame:CGRectMake(48, 10, 105, 21)];
            menulabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            menulabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
            menulabel.text = @"TA的个人相册";
            [menucell addSubview:menulabel];
            
            for (int i=0; i<array.count; i++) {
                
                if (i<2) {
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50+i*(17+75), 37.5, 75, 66)];
                    imageView.backgroundColor = [UIColor grayColor];
                    [imageView sd_setImageWithURL:[NSURL URLWithString:array[i]]];
                    
                    [menucell addSubview:imageView];
                }
            
            }
           
        }
        
        return menucell;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        return 95.5;
    }else {
    
        if (indexPath.row ==0) {
            return 50;
        }else if(indexPath.row ==1){
            if ([[self.UUserData valueForKey:@"IsDistributor"] intValue]==1) {
                return 50;
            }else{
                return 0;
                
            }
            
       
        
        }else if(indexPath.row ==2){
            NSArray *array = [self.UUserData valueForKey:@"Imgs"];
            
            
            if (array != nil && ![array isKindOfClass:[NSNull class]] && array.count != 0) {
                return 120;
            }else{
                return 0;
            
            }
            
            
            
        }else if(indexPath.row ==3){
            if ([[self.UUserData valueForKey:@"IsDistributor"] intValue]==1) {
               return 50;
            }else{
                return 0;
                
            }
            
            
            
        }else if(indexPath.row ==4){
            if ([[self.UUserData valueForKey:@"IsSupplier"] intValue]==1) {
                 return 50;
            }else{
                return 0;
        }
           
           
        }else{
        
            return 50;
        }
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==0) {
        return 2;
    }else{
    
    
        return 12;
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1],UITextAttributeTextColor,nil]];
}
-(void)searchFriendMoredata{
    
    NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Sns&a=getFriendInfo"];
    NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    
    NSDictionary *dic = @{@"friendId":self.otheruserid,@"userId":[NSString stringWithFormat:@"%@",UserId]};
    
    NSLog(@"获取他人的消息-=-=-=%@",dic);
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSLog(@"别人的信息＝－＝－%@",responseObject);
        self.UUserData = [responseObject valueForKey:@"data"];
        
        if ([[responseObject valueForKey:@"code"] intValue]==200) {
            self.moreDatTableView.delegate =self;
            self.moreDatTableView.dataSource =self;
            if ([[self.UUserData valueForKey:@"IsFriend"] intValue]==1) {
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 300)];
                
                view.backgroundColor= [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
                //给他发消息 按钮
                UIButton *Btn = [[UIButton alloc] initWithFrame:CGRectMake(26.5, 50, self.view.width-26.5*2, 40)];
                Btn.backgroundColor = [UIColor colorWithRed:263/255.0 green:74/255.0 blue:72/255.0 alpha:1];
                Btn.layer.masksToBounds= YES;
                Btn.layer.cornerRadius = 2.5;
                Btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17.5];
                [Btn setTitle:@"给Ta发消息" forState:UIControlStateNormal];
                [view addSubview:Btn];
                //删除该好友
                //给他发消息 按钮
                UIButton *Btn1 = [[UIButton alloc] initWithFrame:CGRectMake(26.5, 100, self.view.width-26.5*2, 40)];
                [Btn1 addTarget:self action:@selector(cancelBtn) forControlEvents:UIControlEventTouchUpInside];
                Btn1.backgroundColor = [UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:1];
                Btn1.layer.masksToBounds= YES;
                Btn1.layer.cornerRadius = 2.5;
                Btn1.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17.5];
                [Btn1 setTitle:@"删除该好友" forState:UIControlStateNormal];
                [view addSubview:Btn1];
                
                [self.moreDatTableView setTableFooterView:view];
            }else{
            
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 300)];
            
            view.backgroundColor= [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
            //给他发消息 按钮
            UIButton *Btn = [[UIButton alloc] initWithFrame:CGRectMake(26.5, 50, self.view.width-26.5*2, 40)];
                
                [Btn addTarget:self action:@selector(addFriendBtn) forControlEvents:UIControlEventTouchUpInside];
            Btn.backgroundColor = [UIColor colorWithRed:263/255.0 green:74/255.0 blue:72/255.0 alpha:1];
            Btn.layer.masksToBounds= YES;
            Btn.layer.cornerRadius = 2.5;
            Btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17.5];
            [Btn setTitle:@"加为好友" forState:UIControlStateNormal];
            [view addSubview:Btn];
            
            
            [self.moreDatTableView setTableFooterView:view];
                
            }

        }
        [self.moreDatTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
 }
-(void)addFriendBtn{
    
    NSString *title = NSLocalizedString(@"确认", nil);
    NSString *message = NSLocalizedString(@"请输入验证消息", nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"发送", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"The \"Okay/Cancel\" alert's other action occured.");
        
        [self addFriendAction];
        
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        // 可以在这里对textfield进行定制，例如改变背景色
        
        self.sureStr = textField.text;
    }];
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}
-(void)addFriendAction{
    NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Sns&a=sendAddRequest"];
    NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    
    NSDictionary *dic = @{@"friendId":self.otheruserid,@"userId":[NSString stringWithFormat:@"%@",UserId],@"content":self.sureStr};
    
    NSLog(@"获取他人的消息-=-=-=%@",dic);
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSLog(@"别人的信息＝－＝－%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];



}
-(void)cancelBtn{
    NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Sns&a=delFriend"];
    NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    
    NSDictionary *dic = @{@"friendId":self.otheruserid,@"userId":[NSString stringWithFormat:@"%@",UserId]};
    
    NSLog(@"获取他人的消息-=-=-=%@",dic);
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSLog(@"别人的信息＝－＝－%@",responseObject);
        
        if ([[responseObject valueForKey:@"code"] intValue]==200) {
            [self showAlert:@"已删除"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
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
