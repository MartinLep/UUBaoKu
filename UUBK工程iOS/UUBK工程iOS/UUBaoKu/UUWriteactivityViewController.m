//
//  UUWriteactivityViewController.m
//  UUBaoKu
//
//  Created by admin on 16/11/11.
//  Copyright © 2016年 loongcrown. All rights reserved.
//======================写活动============================

#import "UUWriteactivityViewController.h"
#import "UUPersonalPhotoViewController.h"
#import "UUCQTextView.h"
#import "XHDatePickerView.h"
#import "NSDate+Extension.h"
#import "UUWhoCanSeeViewController.h"
#import "PhotosView.h"
@interface UUWriteactivityViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate>

// tableVIew
@property(strong,nonatomic)UITableView *writeactivityTableView;
//活动描述
@property(strong,nonatomic)UUCQTextView *textView ;
@property(strong,nonatomic)NSString *textViewStr;
//活动名称
@property(strong,nonatomic)UITextField *UIactivitynameTextField;
@property(strong,nonatomic)NSString *UIactivitynameTextFieldStr;
//报名时间
@property(strong,nonatomic)UILabel *registrationBeginsLabel;
@property(strong,nonatomic)NSString *registrationBeginsLabelStr;
//报名结束
@property(strong,nonatomic)UILabel *registrationEndLabel;
@property(strong,nonatomic)NSString *registrationEndLabelStr;
//活动地点label
@property(strong,nonatomic)UITextField *activityPlaceText;
@property(strong,nonatomic)NSString *activityPlaceTextStr;
//活动开始时间
@property(strong,nonatomic)UILabel *activityBeginLabel;
@property(strong,nonatomic)NSString *activityBeginStr;
//活动结束时间
@property(strong,nonatomic)NSString *activityEndStr;
@property(strong,nonatomic)UILabel *activityEndLabel;
//活动人数
@property(strong,nonatomic)UITextField *activityPeopleNum;
@property(strong,nonatomic)NSString *activityPeopleNumStr;
//报名费用
@property(strong,nonatomic)UILabel *activityRegistrationMoney;



@property(strong,nonatomic)NSString *activityRegistrationMoneyStr;
//谁可以看
@property(strong,nonatomic)UUWhoCanSeeViewController *whocan;
@property(strong,nonatomic)UILabel *whocanseeLabel;
@property(strong,nonatomic)NSString *whocanseeStr;
@property(strong,nonatomic)NSString *whocanseeNsstring;
//报名费用
@property(strong,nonatomic)UITextField *activityRegistrationMoneytextfield;
//
@property(strong,nonatomic)NSArray *visitRoleStr;
//活动介绍
@property(strong,nonatomic)UITextView *activityTextView;
@property(strong,nonatomic)NSString *activitydiscribStr;
// 第一段  图片view
@property(strong,nonatomic)UIView *photoView;
//多选图片
@property(strong,nonatomic)PhotosView *photoViewcontroller;
//图片cell高度

@property(assign,nonatomic)int photoHeight;

@property(assign,nonatomic)CGRect keyboardFrame;

@property (nonatomic,strong)NSDate *signUpStratDate;
@property (nonatomic,strong)NSDate *activityStartDate;
@property (nonatomic,strong)NSDate *signUpEndDate;
@property (nonatomic,assign)NSInteger selectId;
@end

@implementation UUWriteactivityViewController

- (void)pickerViewFrameChanged{
    [self upload];
    [self.writeactivityTableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.visitRoleStr = @[@"0"];
    self.photoView = [[UIView alloc] initWithFrame:CGRectMake(0, 125, self.view.width, 110)];
    self.showInView = self.photoView;
    [self initPickerView];
    self.UIactivitynameTextFieldStr =@"";
    [self setUpForDismisskeyboard];
    self.navigationItem.title =@"写活动";
    self.writeactivityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-64)];
    self.writeactivityTableView.separatorColor=[UIColor colorWithRed:230/255.0 green:233/255.0 blue:237/255.0 alpha:1];
    self.writeactivityTableView.delegate =self;
    self.writeactivityTableView.dataSource =self;
    [self.view addSubview:self.writeactivityTableView];
    //navigation  右侧按钮
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 24.5)];
    rightButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17.5];
    [rightButton setTitle:@"发表" forState:UIControlStateNormal];
    rightButton.fy_acceptEventInterval = 1.0;
    [rightButton setTitleColor:MainCorlor forState:UIControlStateNormal];
    
    [rightButton addTarget:self action:@selector(Published)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
 }

#pragma tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 11;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
     if (indexPath.row ==0) {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];//根据indexPath准确地取出一行，而不是从cell重用队列中取出
           if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 33, 60, 15.5)];
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        label.textColor = MainCorlor;
        label.text =@"活动名称";
        [cell addSubview:label];
         
        UITextField *activityTextfield = [[UITextField alloc] initWithFrame:CGRectMake(self.view.width-15.5-105-90, 29.5, 200, 21)];
         activityTextfield.tag = indexPath.row;
        activityTextfield.delegate =self;
        [[UITextField appearance] setTintColor:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1]];
        
        self.UIactivitynameTextField = activityTextfield;
        activityTextfield.borderStyle = UITextBorderStyleNone;
        NSLog(@"活动名称命名＝－＝－%@",self.UIactivitynameTextFieldStr);
        if (![self.UIactivitynameTextFieldStr isEqualToString:@""]) {
            self.UIactivitynameTextField.text = self.UIactivitynameTextFieldStr;
        }else{
            
            
        }
        activityTextfield.placeholder = @"请输入活动名称";
        activityTextfield.delegate = self;
        activityTextfield.returnKeyType = UIReturnKeyDone;
        activityTextfield.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        activityTextfield.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        activityTextfield.textAlignment = NSTextAlignmentRight;
        [cell addSubview:activityTextfield];

         return cell;
        
       
    }else if (indexPath.row ==1){
        
        
        static NSString *CellIdentifier = @"Cell1";
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];//根据indexPath准确地取出一行，而不是从cell重用队列中取出
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(17.5, 24.3, 60, 15.5)];
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        label.textColor = MainCorlor;
        label.text =@"活动描述";
        [cell addSubview:label];
        
 

        UITextView *activityTextView = [[UITextView alloc] initWithFrame:CGRectMake(17.5, 54.2, self.view.width-35, 75)];
        
        activityTextView.delegate =self;
        activityTextView.tag = indexPath.row;
        self.activityTextView = activityTextView;
        if (!self.textViewStr) {
            activityTextView.text = @"请输入详细的活动描述";
            activityTextView.textColor = UUGREY;
        }else{
            activityTextView.text = self.textViewStr;
            activityTextView.textColor = UUBLACK;
        }
        
        activityTextView.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        
        activityTextView.textAlignment = NSTextAlignmentLeft;
        
        [cell addSubview:activityTextView];
        
        [cell addSubview:self.photoView];
        
        return cell;
    
    }else if(indexPath.row ==2){
        
        static NSString *CellIdentifier = @"Cell2";
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];//根据indexPath准确地取出一行，而不是从cell重用队列中取出
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16.5, 17.3, 80, 15.5)];
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        label.textColor = MainCorlor;
        label.text = @"活动地点";
        
        [cell addSubview:label];
        
        UITextField *activitylocationTextfield = [[UITextField alloc] initWithFrame:CGRectMake(self.view.width-15.5-105-90, 14.3, 200, 21)];
        activitylocationTextfield.delegate = self;
        self.activityPlaceText = activitylocationTextfield;
        activitylocationTextfield.tag = indexPath.row;
        [activitylocationTextfield setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:15]];
        activitylocationTextfield.borderStyle = UITextBorderStyleNone;
        if (![self.activityPlaceTextStr isEqualToString:@""]) {
            self.activityPlaceText.text = self.activityPlaceTextStr;
        }else{

        
        }
        
        activitylocationTextfield.placeholder = @"请输入活动地点";
        activitylocationTextfield.delegate = self;
        activitylocationTextfield.returnKeyType = UIReturnKeyDone;
        activitylocationTextfield.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        
        activitylocationTextfield.textAlignment = NSTextAlignmentRight;
        
        [cell addSubview:activitylocationTextfield];
          return cell;
    }else if(indexPath.row==3){
        
        static NSString *CellIdentifier = @"Cell3";
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];//根据indexPath准确地取出一行，而不是从cell重用队列中取出
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16.5, 23.7, 200, 15.5)];
        
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        
        self.registrationBeginsLabel = label;
        
        label.textColor = MainCorlor;
        
        label.text = @"报名开始时间";
        
        [cell addSubview:label];
        
        
        UILabel *registrationBeginsLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width-15.5-110-90, 20.8, 200, 21)];
        
        registrationBeginsLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        self.registrationBeginsLabel = registrationBeginsLabel;
        
        if (!self.registrationBeginsLabelStr) {
            self.registrationBeginsLabel.text = @"请选择时间";
            registrationBeginsLabel.textColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1];
        }else{
            self.registrationBeginsLabel.text = self.registrationBeginsLabelStr;
            registrationBeginsLabel.textColor = UUBLACK;
        }
        registrationBeginsLabel.textAlignment = NSTextAlignmentRight;
        
        [cell addSubview:registrationBeginsLabel];
   
        return cell;

    }else if(indexPath.row==4){
        
        
        static NSString *CellIdentifier = @"Cell4";
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];//根据indexPath准确地取出一行，而不是从cell重用队列中取出
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

        
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16.5, 23.5, 200, 15.5)];
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        label.textColor = MainCorlor;
        label.text = @"报名结束时间";
        
        [cell addSubview:label];
        
        
        UILabel *registrationEndLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width-15.5-200, 20.8, 200, 21)];
        registrationEndLabel.textAlignment = NSTextAlignmentLeft;
        registrationEndLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        self.registrationEndLabel =registrationEndLabel;
        registrationEndLabel.textAlignment = NSTextAlignmentRight;
        if (!self.registrationEndLabelStr) {
            self.registrationEndLabel.text = @"请选择时间";
            registrationEndLabel.textColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1];
        }else{
            self.registrationEndLabel.text = self.registrationEndLabelStr;
            registrationEndLabel.textColor = UUBLACK;
        }
    
        
        [cell addSubview:registrationEndLabel];
        return cell;
        
    }else if(indexPath.row==5){
        
        static NSString *CellIdentifier = @"Cell5";
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];//根据indexPath准确地取出一行，而不是从cell重用队列中取出
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }


        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16.5, 23.4, 200, 15.5)];
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        label.textColor = MainCorlor;
        label.text = @"活动开始时间";
        
        [cell addSubview:label];
 
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width-15.5-200, 20.8, 200, 21)];
        self.activityBeginLabel = nameLabel;
        nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        nameLabel.textColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1];
        nameLabel.textAlignment = NSTextAlignmentRight;
        
        if (!self.activityBeginStr) {
            self.activityBeginLabel.text = @"请选择时间";
            self.activityBeginLabel.textColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1];
        }else{
            self.activityBeginLabel.text = self.activityBeginStr;
            self.activityBeginLabel.textColor = UUBLACK;
        }
        
        
        
        [cell addSubview:nameLabel];
        return cell;
        
    }else if(indexPath.row==6){
        static NSString *CellIdentifier = @"Cell6";
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];//根据indexPath准确地取出一行，而不是从cell重用队列中取出
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16.5, 23.2, 200, 15.5)];
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        label.textColor = MainCorlor;
        label.text = @"活动结束时间";
        
        [cell addSubview:label];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width-15.5-200, 20.8, 200, 21)];
        self.activityEndLabel = nameLabel;
        nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        nameLabel.textAlignment = NSTextAlignmentRight;
        nameLabel.textColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1];
        
        if (!self.activityEndStr) {
            self.activityEndLabel.text = @"请选择时间";
            self.activityEndLabel.textColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1];
        }else{
            self.activityEndLabel.text = self.activityEndStr;
            self.activityEndLabel.textColor = UUBLACK;
        }
        
        [cell addSubview:nameLabel];
        return cell;
        
    }else if(indexPath.row==7){
        static NSString *CellIdentifier = @"Cell7";
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];//根据indexPath准确地取出一行，而不是从cell重用队列中取出
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16.5, 17.3, 100, 15.5)];
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        label.textColor = MainCorlor;
        label.text = @"活动人数";
        
        [cell addSubview:label];
        
        //不限制  按钮 让费用清零
        UIButton *zeroBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width-200.5, 14.3, 75, 21)];
        [zeroBtn addTarget:self action:@selector(zeroBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        zeroBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [zeroBtn setTitle:@"不限制" forState:UIControlStateNormal];
        zeroBtn.layer.borderWidth = 0.5;
        if (!zeroBtn.selected) {
            zeroBtn.layer.borderColor = UUBLACK.CGColor;
        }else{
            zeroBtn.layer.borderColor = UURED.CGColor;
        }
        
        [zeroBtn setTitleColor:UUBLACK forState:UIControlStateNormal];
        [zeroBtn setTitleColor:UURED forState:UIControlStateSelected];
        [cell addSubview:zeroBtn];
        
        
        UITextField *activityTextfield = [[UITextField alloc] initWithFrame:CGRectMake(self.view.width-15.5-75, 14.3, 75, 21)];
        
        activityTextfield.delegate =self;
        
        activityTextfield.borderStyle = UITextBorderStyleNone;
        activityTextfield.tag = indexPath.row;
        
        self.activityPeopleNum =activityTextfield;
        activityTextfield.placeholder = @"请输入人数";
        activityTextfield.delegate = self;
        activityTextfield.returnKeyType = UIReturnKeyDone;
        activityTextfield.keyboardType = UIKeyboardTypeNumberPad;
        if (![self.activityPeopleNumStr isEqualToString:@""]) {
            self.activityPeopleNum.text = self.activityPeopleNumStr;
        }else{
       
        
        }
        
        activityTextfield.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        activityTextfield.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        activityTextfield.textAlignment = NSTextAlignmentRight;
        [cell addSubview:activityTextfield];
        
        
        return cell;
        
    }
    else if(indexPath.row==8){
        static NSString *CellIdentifier = @"Cell8";
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];//根据indexPath准确地取出一行，而不是从cell重用队列中取出
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16.5, 24, 100, 15.5)];
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        label.textColor = MainCorlor;
        label.text = @"报名费用";
        
        [cell addSubview:label];
        
        
        UITextField *activityTextfield = [[UITextField alloc] initWithFrame:CGRectMake(self.view.width-80-36.5, 21, 80, 21)];
        
        
        activityTextfield.delegate = self;
        activityTextfield.tag = indexPath.row;
        activityTextfield.borderStyle = UITextBorderStyleNone;
        self.activityRegistrationMoneytextfield =activityTextfield;
        activityTextfield.placeholder = @"请输入金额";
        activityTextfield.delegate = self;
        activityTextfield.returnKeyType = UIReturnKeyDone;
//      NSLog(@"报名费用＝－＝－%@",self.activityRegistrationMoneyStr);
      
        if (![self.activityRegistrationMoneyStr isEqualToString:@""]) {
            
           activityTextfield.text = self.activityRegistrationMoneyStr;
            
        }else{
            
            
        }
        activityTextfield.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        activityTextfield.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        activityTextfield.keyboardType = UIKeyboardTypeNumberPad;
        activityTextfield.textAlignment = NSTextAlignmentRight;
        activityTextfield.tag = indexPath.row;
        [cell addSubview:activityTextfield];
        
          
        UILabel *yuanLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width-14-15, 21, 15, 21)];
        yuanLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        yuanLabel.textAlignment = NSTextAlignmentRight;
        yuanLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        yuanLabel.text = @"元";
        [cell addSubview:yuanLabel];
        
        
        return cell;
        
    }else if(indexPath.row==9){
        static NSString *CellIdentifier = @"Cell9";
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];//根据indexPath准确地取出一行，而不是从cell重用队列中取出
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width-260-14, 7, 260, 15.5)];
        label.textColor = MainCorlor;
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
        label.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
        
        label.text = @"警告，请勿通过报名费用牟取暴利，一经发现追究法律责任";
        
        [cell addSubview:label];
         return cell;
    }else{
        static NSString *CellIdentifier = @"Cell10";
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];//根据indexPath准确地取出一行，而不是从cell重用队列中取出
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16.5, 24, 100, 15.5)];
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        label.textColor = MainCorlor;
        label.text = @"谁可以看";
            
        [cell addSubview:label];
              
        UILabel *whocanseeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width-221-5, 23, 200, 21)];
        self.whocanseeLabel = whocanseeLabel;
        self.whocanseeLabel.text = @"所有好友可见";
        whocanseeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        whocanseeLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        whocanseeLabel.textAlignment = NSTextAlignmentRight;
        [cell addSubview:whocanseeLabel];
          
          
          
          
        return cell;
    }
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    if (indexPath.row ==0) {
        return 72.8;
    }else if (indexPath.row ==1){
        NSLog(@"这一行刷新了，刷新了");
        return 125+(self.imageArray.count/4+1)*((kScreenWidth - 64)/4.0+15)+40;
    }else if (indexPath.row ==2){
    
    
        return 56.1;
    }else if (indexPath.row ==3||indexPath.row==4||indexPath.row==5){
        
    
        return 62.7;
    }else if (indexPath.row==6){
    
        return 62.6;
    }else if (indexPath.row ==7){
    
    
        return 62.5;
    }else if (indexPath.row ==8){
    
        return 62.5;
    
    }else if (indexPath.row ==9){
        
        return 35.3;
        
    }else{
    
        return 62.5;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row==0) {

    }else if (indexPath.row==2){
    
    
    }else if (indexPath.row==3){
    
        XHDatePickerView *datepicker = [[XHDatePickerView alloc] initWithCompleteBlock:^(NSDate *startDate,NSDate *endDate) {
            NSLog(@"\n开始时间： %@",startDate);
            self.registrationBeginsLabelStr = [startDate stringWithFormat:@"yyyy-MM-dd HH:mm"];
            self.registrationBeginsLabel.text =[startDate stringWithFormat:@"yyyy-MM-dd HH:mm"];
            self.registrationBeginsLabel.textColor = [UIColor blackColor];
            self.signUpStratDate = startDate;
            
        }];
        datepicker.datePickerStyle = DateStyleShowMonthDayHourMinute;
        datepicker.dateType = DateTypeStartDate;
        datepicker.minLimitDate = [NSDate date];
        
        [self.view addSubview:datepicker];
        
    }else if (indexPath.row==4){
        XHDatePickerView *datepicker = [[XHDatePickerView alloc] initWithCompleteBlock:^(NSDate *startDate,NSDate *endDate) {
            NSLog(@"\n开始时间： %@",startDate);
            self.registrationEndLabelStr = [startDate stringWithFormat:@"yyyy-MM-dd HH:mm"];
            self.registrationEndLabel.text =[startDate stringWithFormat:@"yyyy-MM-dd HH:mm"];
            self.registrationEndLabel.textColor = [UIColor blackColor];
            self.signUpEndDate = startDate;
            
        }];
        datepicker.datePickerStyle = DateStyleShowMonthDayHourMinute;
        datepicker.dateType = DateTypeStartDate;
        if (self.signUpStratDate) {
            datepicker.minLimitDate = [self.signUpStratDate dateByAddingMinutes:1];
        }else{
            datepicker.minLimitDate = [NSDate date];
        }
        [self.view addSubview:datepicker];
    
    }else if (indexPath.row==5){
        XHDatePickerView *datepicker = [[XHDatePickerView alloc] initWithCompleteBlock:^(NSDate *startDate,NSDate *endDate) {
            NSLog(@"\n开始时间： %@",startDate);
            self.activityBeginStr = [startDate stringWithFormat:@"yyyy-MM-dd HH:mm"];
            self.activityBeginLabel.text =[startDate stringWithFormat:@"yyyy-MM-dd HH:mm"];
            self.activityBeginLabel.textColor = [UIColor blackColor];
            self.activityStartDate = startDate;
            
        }];
        datepicker.datePickerStyle = DateStyleShowMonthDayHourMinute;
        datepicker.dateType = DateTypeStartDate;
        if (self.signUpEndDate) {
            datepicker.minLimitDate = [self.signUpEndDate dateByAddingMinutes:1];
        }else{
            datepicker.minLimitDate = [NSDate date];
        }
        
        [self.view addSubview:datepicker];
        
        
        
    
    }else if (indexPath.row==6){
        XHDatePickerView *datepicker = [[XHDatePickerView alloc] initWithCompleteBlock:^(NSDate *startDate,NSDate *endDate) {
            NSLog(@"\n开始时间： %@",startDate);
            self.activityEndLabel.text = [startDate stringWithFormat:@"yyyy-MM-dd HH:mm"];
            self.activityEndLabel.textColor = [UIColor blackColor];
            self.activityEndStr =[startDate stringWithFormat:@"yyyy-MM-dd HH:mm"];
        }];
        datepicker.datePickerStyle = DateStyleShowMonthDayHourMinute;
        datepicker.dateType = DateTypeStartDate;
        if (self.activityStartDate) {
            datepicker.minLimitDate = [self.activityStartDate dateByAddingMinutes:1];
        }else{
            datepicker.minLimitDate = [NSDate date];
        }
        [self.view addSubview:datepicker];

    
    
    }else if (indexPath.row==7){
    
    
    }else if (indexPath.row==8){
    
    
    }else if (indexPath.row==10){
        UUWhoCanSeeViewController *whoCan = [[UUWhoCanSeeViewController alloc] init];
        whoCan.setWhoCanSee = ^(NSArray *array, NSInteger selectedId) {
            self.selectId = selectedId;
            self.visitRoleStr = array;
            if (selectedId == 0) {
                self.whocanseeLabel.text = @"所有好友可见";
            }else if (selectedId == 1){
                self.whocanseeLabel.text = @"仅自己可见";
            }else{
                self.whocanseeLabel.text = @"部分好友可见";
            }
        };
        whoCan.selectedId = self.selectId;
        whoCan.WhoCanSeeIdArray = self.visitRoleStr;
        [self.navigationController pushViewController:whoCan animated:YES];
    
    }else{

    
    
    }
 }


-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"可选数组为＝－＝－%@",self.photoViewcontroller.photoMutableArray);
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = BACKGROUNG_COLOR;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:UURED}];
    
}

-(void)Published{
    
    [self.view endEditing:YES];
    
    if (self.UIactivitynameTextFieldStr.length == 0){
        [self showAlert:@"请输入活动名称"];
    }else if (self.textViewStr.length == 0){
        [self showAlert:@"请输入详细的活动描述"];
    }else if (self.photoMutableArray.count == 0){
        [self showAlert:@"请至少上传一张图片"];
    }else if (self.activityPlaceText.text.length==0){
        [self showAlert:@"请输入活动地点"];
    }else if (self.registrationBeginsLabelStr.length == 0){
        [self showAlert:@"请选择报名开始时间"];
    }else if (self.registrationEndLabelStr.length == 0){
        [self showAlert:@"请选择报名结束时间"];
    }else if (self.activityBeginStr.length == 0){
        [self showAlert:@"请选择活动开始时间"];
    }else if (self.activityEndStr.length == 0){
        [self showAlert:@"请选择活动结束时间"];
    }else if (self.activityPeopleNumStr.length == 0){
        [self showAlert:@"请确定活动人数"];
    }else if (self.activityRegistrationMoneyStr.length == 0){
        [self showAlert:@"请输入报名费用"];
    }else{
         [self getWriteactivityData];
    }
}

//发表数据
-(void)getWriteactivityData{
    if (self.photoMutableArray.count>0) {
        NSMutableArray *PicArray = [[NSMutableArray alloc] init];
        
        for (int i=0; i<self.photoMutableArray.count; i++) {
            
            [PicArray addObject:[self.photoMutableArray[i] valueForKey:@"savename"]];
        }
        NSData *data=[NSJSONSerialization dataWithJSONObject:PicArray options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Moment&a=addMoment"];
        
        NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
        NSArray *arr1 = self.visitRoleStr;
        NSData *data2=[NSJSONSerialization dataWithJSONObject:arr1 options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonStr2=[[NSString alloc]initWithData:data2 encoding:NSUTF8StringEncoding];
        
        
        NSLog(@"活动需要的金额%@",self.activityRegistrationMoneyStr);
        NSDictionary *dic =@{@"address":self.activityPlaceText.text,
                             @"content":self.textViewStr,
                             @"endTime":self.activityEndStr,
                             @"imgs":jsonStr,
                             @"number":self.activityPeopleNum.text,
                             @"price":self.activityRegistrationMoneyStr,
                             @"signEndTime":[self.registrationEndLabelStr substringToIndex:10],
                             @"signStartTime":[self.registrationBeginsLabelStr substringToIndex:10],
                             @"title":self.UIactivitynameTextFieldStr,
                             @"type":@"4",
                             @"userId":UserId,
                             @"startTime":self.activityBeginStr,
                             @"visitRole":jsonStr2
                             
                             };
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [NetworkTools postReqeustWithParams:dic UrlString:urlStr successBlock:^(id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"发表活动获取到的值是==%@",responseObject);
            if ([[responseObject valueForKey:@"code"] intValue]==200) {
                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter]postNotificationName:RECOMMEND_RELEASE_SUCCESSED object:nil];
            }
        } failureBlock:^(NSError *error) {
            
        }];
            
    }else{
        [self showAlert:@"请选择至少一张图片"];
    }
}

-(void)registrationBeginsAlert{
    
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    
     datePicker.datePickerMode =UIDatePickerModeDate;
   
    [datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    
    datePicker.minimumDate = [NSDate date];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    [alert.view addSubview:datePicker];
    
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        //实例化一个NSDateFormatter对象
        [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式
        NSString *dataString = [dateFormat stringFromDate:datePicker.date];
        self.signUpStratDate = datePicker.date;
        //求出当天的时间字符串
        NSLog(@"%@",dataString);
        self.registrationBeginsLabel.text = dataString;
        self.registrationBeginsLabel.textColor = [UIColor blackColor];
        self.registrationBeginsLabelStr = dataString;
        }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    [ok setValue:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1] forKey:@"titleTextColor"];
    [cancel setValue:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1] forKey:@"titleTextColor"];
    [self presentViewController:alert animated:YES completion:^{
        
    }];

}
-(void)registrationEndAlert{
    
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    
    datePicker.datePickerMode =UIDatePickerModeDate;
    
    [datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    if (self.signUpStratDate) {
        datePicker.minimumDate = self.signUpStratDate;
    }else{
        datePicker.minimumDate = [NSDate date];
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    [alert.view addSubview:datePicker];
    
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        //实例化一个NSDateFormatter对象
        [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式
        NSString *dataString = [dateFormat stringFromDate:datePicker.date];
        self.signUpEndDate = datePicker.date;
        //求出当天的时间字符串
        NSLog(@"%@",dataString);
        self.registrationEndLabel.text = dataString;
        self.registrationEndLabel.textColor = [UIColor blackColor];
        self.registrationEndLabelStr = dataString;
    
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    
    [alert addAction:ok];
    [alert addAction:cancel];
    [ok setValue:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1] forKey:@"titleTextColor"];
    [cancel setValue:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1] forKey:@"titleTextColor"];
    
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];
 }

/**
 *  下面两个方法解决cell分割线不到左边界的问题
 */

-(void)viewDidLayoutSubviews {
    if ([self.writeactivityTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.writeactivityTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.writeactivityTableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.writeactivityTableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    if ([self.writeactivityTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.writeactivityTableView setSeparatorInset:UIEdgeInsetsMake(0, 45, 0, 0)];
    }
}
/**
 * 这个方法和上面一个方法解决cell分割线不到左边界的问题
 */
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
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

-(void)upload{
    self.photoMutableArray = [NSMutableArray new];
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *forString = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", forString];
    NSLog(@"图片名＝＝%@",fileName);
    
    
    NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=User&a=uploadImg"];
    
    NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i=0; i<self.arrSelected.count; i++) {
            
            UIImage *img = [self getBigIamgeWithALAsset:self.arrSelected[i]];
            NSData *imgData=UIImageJPEGRepresentation(img, 0.8);
            
            NSString *fileName = [NSString stringWithFormat:@"%@_%d.jpg", forString,i];
            
            [formData appendPartWithFileData:imgData name:@"file[]" fileName:fileName mimeType:@"image/jpeg"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        NSLog(@"上传图片的时候success -------- >>  %@", [NSArray arrayWithObject:responseObject]);
        NSLog(@"上传图片的时候%@",responseObject);
        
        
        self.photoMutableArray = [responseObject valueForKey:@"data"];
        NSLog(@"%@",self.photoMutableArray);
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"上传失败%@",error);
        
        //        [self uploadDataWithStatus:NO];
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

//清零按钮的方法=-=-
-(void)zeroBtnAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.layer.borderColor = UURED.CGColor;
        self.activityPeopleNum.text=@" ";
        self.activityPeopleNum.enabled = NO;
        self.activityPeopleNumStr = @"0";
    }else{
        self.activityPeopleNum.text=@"";
        self.activityPeopleNum.enabled = YES;
        sender.layer.borderColor = UUGREY.CGColor;
    }
    
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    self.textViewStr = textView.text;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"活动名称string= %@",textField.text);
    if (textField==self.UIactivitynameTextField) {
        self.UIactivitynameTextFieldStr = textField.text;
    }
    if (textField==self.activityPlaceText) {
        self.activityPlaceTextStr = textField.text;
    }
    
    if (textField==self.activityPeopleNum) {
        self.activityPeopleNumStr = textField.text;
    }
    if (textField==self.activityRegistrationMoneytextfield) {
        
        self.activityRegistrationMoneyStr = textField.text;
    }
    NSLog(@"编辑结束后报名费用=-=-=-=-=-=-=-%@",self.activityRegistrationMoneyStr);
    [textField resignFirstResponder];
    self.view.frame =CGRectMake(0, 64, self.view.frame.size.width, kScreenHeight-64);
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    CGRect frame = [textField convertRect:self.writeactivityTableView.frame toView:self.view];
    //    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);//键盘高度216
    NSLog(@"%f",self.view.frame.origin.y);
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height+offset);
    
    [UIView commitAnimations];
    if (textField.keyboardType == UIKeyboardTypeNumberPad) {
        textField.inputAccessoryView = [self addToolbar];
    }
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    self.activityTextView.inputAccessoryView = [self addToolbar];
    textView.textColor = UUBLACK;
    if (!self.textViewStr) {
        textView.text = @"";
    }else{
        textView.text = self.textViewStr;
    }
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)numberFieldCancle{
    [self.view endEditing:YES];
}
- (UIToolbar *)addToolbar
{
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 50)];
    //    UIToolbar *toolbar =[[UIToolbar alloc] init];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(numberFieldCancle)];
    //    UIBarButtonItem *left = [[UIBarButtonItem alloc]init];
    UIBarButtonItem *sapce = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolbar.items = @[sapce,bar];
    
    return toolbar;
}

@end
