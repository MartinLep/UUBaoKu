//
//  UUOwnMoneyViewController.m
//  UUBaoKu
//
//  Created by admin on 16/12/7.
//  Copyright © 2016年 loongcrown. All rights reserved.
//＝＝＝＝＝＝＝＝＝＝＝＝＝赚取私房钱＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝

#import "UUOwnMoneyViewController.h"

@interface UUOwnMoneyViewController ()<UITableViewDelegate,UITableViewDataSource>

//tableView
@property(strong,nonatomic)UITableView *OWnMoneytableView;
@end

@implementation UUOwnMoneyViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title =@"赚私房钱";
    self.OWnMoneytableView= [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-64)] ;
    self.OWnMoneytableView.delegate =self;
    self.OWnMoneytableView.dataSource =self;
    
    [self.view addSubview:self.OWnMoneytableView];
   
}

#pragma tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==0) {
        return 1;
    }else if(section ==1){
        
        return 1;
        
    }else{
        
        return 8;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        UITableViewCell *coinsNumbercell = [[UITableViewCell alloc] init];
        
        UILabel *coinsNumberlabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 11.5, 117.5, 21)];
        coinsNumberlabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        coinsNumberlabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        coinsNumberlabel.text = @"库币数量：";
        [coinsNumbercell addSubview:coinsNumberlabel];
        
        UILabel *coinsNumberStrlabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 11.5, 117.5, 21)];
        coinsNumberStrlabel.textColor = [UIColor colorWithRed:235/255.0 green:74/255.0 blue:72/255.0 alpha:1];
        coinsNumberStrlabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        coinsNumberStrlabel.text = @"15498";
        [coinsNumbercell addSubview:coinsNumberStrlabel];
        
        
        
        //提醒label
        UILabel *remindLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width-134.5, 12.5, 60, 21)];
        remindLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        remindLabel.text = @"签到提醒";
        remindLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [coinsNumbercell addSubview:remindLabel];
        //开关
        UISwitch *remindSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(309.5, 9, 25.5, 18)];
        
        
        
        [coinsNumbercell addSubview:remindSwitch];
        
        return coinsNumbercell;
    }else if (indexPath.section ==2){
        //每日签到
        if (indexPath.row==0) {
            UITableViewCell *checkCell = [[UITableViewCell alloc] init];
            
            UIImageView *checkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(19, 17.5, 25, 25)];
            [checkImageView setImage:[UIImage imageNamed:@"每日签到"]];
//            checkImageView.backgroundColor = [UIColor redColor];
            [checkCell addSubview:checkImageView];
            
            //每日签到 label
            UILabel *checkLabel = [[UILabel alloc] initWithFrame:CGRectMake(58.5, 12, 60, 21)];
            checkLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            checkLabel.text =@"每日签到";
            checkLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
            [checkCell addSubview:checkLabel];
            
            //签到说明
            UILabel *checkDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(58.5, 33, 187, 15)];
            checkDataLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
            checkDataLabel.text = @"连续签到，奖励库币翻倍，签到赚库币";
            checkDataLabel.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
            [checkCell addSubview:checkDataLabel];
            
            //签到按钮
            UIButton *checkBtn = [[UIButton alloc] initWithFrame:CGRectMake(286.5, 19, 59, 26.5)];
            checkBtn.backgroundColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
            checkBtn.layer.masksToBounds = YES;
            checkBtn.layer.cornerRadius = 5;
            [checkBtn setTitle:@"签到" forState:UIControlStateNormal];
            [checkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            checkBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
            [checkCell addSubview:checkBtn];
            
            
            return checkCell;
            //分享商品
        }else if (indexPath.row==1){
            UITableViewCell *shareGoodsCell = [[UITableViewCell alloc] init];
            
            UIImageView *shareGoodsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(19, 16.5, 25, 27.2)];
            [shareGoodsImageView setImage:[UIImage imageNamed:@"分享商品"]];
            
            [shareGoodsCell addSubview:shareGoodsImageView];
            
            //分享商品 label
            UILabel *shareGoodsLabel = [[UILabel alloc] initWithFrame:CGRectMake(58.5, 12, 60, 21)];
            shareGoodsLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            shareGoodsLabel.text =@"分享商品";
            shareGoodsLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
            [shareGoodsCell addSubview:shareGoodsLabel];
            
            //分享说明 label
            UILabel *shareGoodsDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(58.5, 33, 178.5, 15)];
            shareGoodsDataLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
            shareGoodsDataLabel.text = @"好货大家分享，分享后还能赚20库币";
            shareGoodsDataLabel.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
            [shareGoodsCell addSubview:shareGoodsDataLabel];
            
            //分享按钮 button
            UIButton *shareGoodsBtn = [[UIButton alloc] initWithFrame:CGRectMake(286.5, 19, 59, 26.5)];
            shareGoodsBtn.backgroundColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
            shareGoodsBtn.layer.masksToBounds = YES;
            shareGoodsBtn.layer.cornerRadius = 5;
            [shareGoodsBtn setTitle:@"分享" forState:UIControlStateNormal];
            [shareGoodsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            shareGoodsBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
            [shareGoodsCell addSubview:shareGoodsBtn];
            
            
            return shareGoodsCell;
            //邀请会员
        }else if (indexPath.row==2){
        
            UITableViewCell *inviteMembersCell = [[UITableViewCell alloc] init];
            
            UIImageView *inviteMembersImageView = [[UIImageView alloc] initWithFrame:CGRectMake(19, 17.5, 25, 25)];
            
            [inviteMembersImageView setImage:[UIImage imageNamed:@"邀请会员"]];
            
            [inviteMembersCell addSubview:inviteMembersImageView];
            
            //邀请会员 label
            UILabel *inviteMembersLabel = [[UILabel alloc] initWithFrame:CGRectMake(58.5, 12, 60, 21)];
            inviteMembersLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            inviteMembersLabel.text =@"邀请会员";
            inviteMembersLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
            [inviteMembersCell addSubview:inviteMembersLabel];
            
            //邀请 说明 label
            UILabel *inviteMembersDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(58.5, 33, 211.5, 15)];
            inviteMembersDataLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
            inviteMembersDataLabel.text = @"邀请好友注册会员，成功邀请1人赚200库币";
            inviteMembersDataLabel.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
            [inviteMembersCell addSubview:inviteMembersDataLabel];
            
            //邀请按钮 button
            UIButton *inviteMembersBtn = [[UIButton alloc] initWithFrame:CGRectMake(286.5, 19, 59, 26.5)];
            inviteMembersBtn.backgroundColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
            inviteMembersBtn.layer.masksToBounds = YES;
            inviteMembersBtn.layer.cornerRadius = 5;
            [inviteMembersBtn setTitle:@"邀请" forState:UIControlStateNormal];
            [inviteMembersBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            inviteMembersBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
            [inviteMembersCell addSubview:inviteMembersBtn];
            
            
            return inviteMembersCell;
        //升级蜂忙士
        }else if (indexPath.row ==3){
            UITableViewCell *upgradeWorkerCell = [[UITableViewCell alloc] init];
            
            UIImageView *upgradeWorkerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(19, 15.5, 25, 29.2)];
            [upgradeWorkerImageView setImage:[UIImage imageNamed:@"升级蜂忙士"]];
            
            
            [upgradeWorkerCell addSubview:upgradeWorkerImageView];
            
            //升级蜂忙士 label
            UILabel *upgradeWorkerLabel = [[UILabel alloc] initWithFrame:CGRectMake(58.5, 12, 100, 21)];
            upgradeWorkerLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            upgradeWorkerLabel.text =@"升级蜂忙士";
            upgradeWorkerLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
            [upgradeWorkerCell addSubview:upgradeWorkerLabel];
            
            //升级说明 label
            UILabel *upgradeWorkerDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(58.5, 33, 196, 15)];
            upgradeWorkerDataLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
            upgradeWorkerDataLabel.text = @"升级蜂忙士，升级成功您将赚得500库币";
            upgradeWorkerDataLabel.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
            [upgradeWorkerCell addSubview:upgradeWorkerDataLabel];
            
            //邀请按钮 button
            UIButton *inviteMembersBtn = [[UIButton alloc] initWithFrame:CGRectMake(286.5, 19, 59, 26.5)];
            inviteMembersBtn.backgroundColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
            inviteMembersBtn.layer.masksToBounds = YES;
            inviteMembersBtn.layer.cornerRadius = 5;
            [inviteMembersBtn setTitle:@"升级" forState:UIControlStateNormal];
            [inviteMembersBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            inviteMembersBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
            [upgradeWorkerCell addSubview:inviteMembersBtn];
            
            
            return upgradeWorkerCell;
            //即日必砍
        }else if (indexPath.row ==4){
            UITableViewCell *nowCutCell = [[UITableViewCell alloc] init];
            
            UIImageView *nowCutImageView = [[UIImageView alloc] initWithFrame:CGRectMake(18.5, 15.5, 26, 25.5)];
            [nowCutImageView setImage:[UIImage imageNamed:@"每日必砍"]];
            [nowCutCell addSubview:nowCutImageView];
            
            //即日必砍 label
            UILabel *nowCutLabel = [[UILabel alloc] initWithFrame:CGRectMake(58.5, 12, 60, 21)];
            nowCutLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            nowCutLabel.text =@"即日必砍";
            nowCutLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
            [nowCutCell addSubview:nowCutLabel];
            
            //即日必砍说明 label
            UILabel *nowCutDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(58.5, 33, 220, 15)];
            nowCutDataLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
            nowCutDataLabel.text = @"每天帮好友砍砍价，赚砍掉金额的10%库币";
            nowCutDataLabel.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
            [nowCutCell addSubview:nowCutDataLabel];
            
            //砍价按钮 button
            UIButton *nowCutBtn = [[UIButton alloc] initWithFrame:CGRectMake(286.5, 19, 59, 26.5)];
            nowCutBtn.backgroundColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
            nowCutBtn.layer.masksToBounds = YES;
            nowCutBtn.layer.cornerRadius = 5;
            [nowCutBtn setTitle:@"砍价" forState:UIControlStateNormal];
            [nowCutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            nowCutBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
            [nowCutCell addSubview:nowCutBtn];
            
            
            return nowCutCell;
            //爆抢团
        }else if (indexPath.row ==5){
            UITableViewCell *gunGroupCell = [[UITableViewCell alloc] init];
            
            UIImageView *gunGroupImageView = [[UIImageView alloc] initWithFrame:CGRectMake(19, 15.5, 24.9, 27.1)];
            [gunGroupImageView setImage:[UIImage imageNamed:@"爆抢团"]];
            [gunGroupCell addSubview:gunGroupImageView];
            
            //爆抢团 label
            UILabel *gunGroupLabel = [[UILabel alloc] initWithFrame:CGRectMake(58.5, 12, 60, 21)];
            gunGroupLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            gunGroupLabel.text =@"爆抢团";
            gunGroupLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
            [gunGroupCell addSubview:gunGroupLabel];
            
            //爆抢团说明 label
            UILabel *nowCutDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(58.5, 33, 187, 15)];
            nowCutDataLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
            nowCutDataLabel.text = @"组团好货抢到爆仓，抢不到不要钱";
            nowCutDataLabel.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
            [gunGroupCell addSubview:nowCutDataLabel];
            
            //爆抢团按钮 button
            UIButton *nowCutBtn = [[UIButton alloc] initWithFrame:CGRectMake(286.5, 19, 59, 26.5)];
            nowCutBtn.backgroundColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
            nowCutBtn.layer.masksToBounds = YES;
            nowCutBtn.layer.cornerRadius = 5;
            [nowCutBtn setTitle:@"去赚钱" forState:UIControlStateNormal];
            [nowCutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            nowCutBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
            [gunGroupCell addSubview:nowCutBtn];
            
            
            return gunGroupCell;
            //0元购
        }else if (indexPath.row ==6){
            UITableViewCell *noMoneyCell = [[UITableViewCell alloc] init];
            
            UIImageView *noMoneyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(19, 17.5, 25, 25)];
            [noMoneyImageView setImage:[UIImage imageNamed:@"0元购"]];
            [noMoneyCell addSubview:noMoneyImageView];
            
            //爆抢团 label
            UILabel *noMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(58.5, 12, 60, 21)];
            noMoneyLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            noMoneyLabel.text =@"0元购";
            noMoneyLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
            [noMoneyCell addSubview:noMoneyLabel];
            
            //爆抢团说明 label
            UILabel *noMoneyDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(58.5, 33, 200, 15)];
            noMoneyDataLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
            noMoneyDataLabel.text = @"呼朋唤友噌宝贝，零元还包邮，手慢就没";
            noMoneyDataLabel.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
            [noMoneyCell addSubview:noMoneyDataLabel];
            
            //爆抢团按钮 button
            UIButton *noMoneyCutBtn = [[UIButton alloc] initWithFrame:CGRectMake(286.5, 19, 59, 26.5)];
            noMoneyCutBtn.backgroundColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
            noMoneyCutBtn.layer.masksToBounds = YES;
            noMoneyCutBtn.layer.cornerRadius = 5;
            [noMoneyCutBtn setTitle:@"去赚钱" forState:UIControlStateNormal];
            [noMoneyCutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            noMoneyCutBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
            [noMoneyCell addSubview:noMoneyCutBtn];
            
            
            
            
            
            return noMoneyCell;
            //天天攒好运
        }else if (indexPath.row ==7){
            UITableViewCell *saveLuckCell = [[UITableViewCell alloc] init];
            
            UIImageView *saveLuckImageView = [[UIImageView alloc] initWithFrame:CGRectMake(19, 17, 25, 25.9)];
            
            [saveLuckImageView setImage:[UIImage imageNamed:@"天天攒好运"]];
            
            
            [saveLuckCell addSubview:saveLuckImageView];
            
            //天天攒好运 label
            UILabel *saveLuckLabel = [[UILabel alloc] initWithFrame:CGRectMake(58.5, 12, 200, 21)];
            saveLuckLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            saveLuckLabel.text =@"天天攒好运";
            saveLuckLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
            [saveLuckCell addSubview:saveLuckLabel];
            
            //天天攒好运说明 label
            UILabel *noMoneyDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(58.5, 33, 220, 15)];
            noMoneyDataLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
            noMoneyDataLabel.text = @"运气越攒越好，奇迹马上驾到，试试见分晓";
            noMoneyDataLabel.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
            [saveLuckCell addSubview:noMoneyDataLabel];
            
            //爆抢团按钮 button
            UIButton *noMoneyCutBtn = [[UIButton alloc] initWithFrame:CGRectMake(286.5, 19, 59, 26.5)];
            noMoneyCutBtn.backgroundColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
            noMoneyCutBtn.layer.masksToBounds = YES;
            noMoneyCutBtn.layer.cornerRadius = 5;
            [noMoneyCutBtn setTitle:@"去赚钱" forState:UIControlStateNormal];
            [noMoneyCutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            noMoneyCutBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
            [saveLuckCell addSubview:noMoneyCutBtn];
            
            
            
            
            
            return saveLuckCell;
        }

    }
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    return cell;

}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {
        return 44;
    }else if (indexPath.section ==1){
    
        return 190;
    }else{
    
        return 60;
    }
  }
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }else{
    return 4.5;
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1],UITextAttributeTextColor,nil]];
    
}

@end
