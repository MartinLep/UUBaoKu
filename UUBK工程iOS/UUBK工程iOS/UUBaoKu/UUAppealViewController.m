//
//  UUAppealViewController.m
//  UUBaoKu
//
//  Created by admin on 16/11/11.
//  Copyright © 2016年 loongcrown. All rights reserved.
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝申诉＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝

#import "UUAppealViewController.h"

@interface UUAppealViewController ()<
UITableViewDelegate,
UITableViewDataSource,
UITextViewDelegate>
//申诉 tableview
@property(strong,nonatomic)UITableView *appealTableView;
@property(strong,nonatomic)NSString *words;
@end

static NSString *const textViewCellId = @"textViewCellId";
@implementation UUAppealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title =@"申诉";
    _words = @"";
     self.appealTableView  =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-64)];
    
    self.appealTableView.delegate =self;
    self.appealTableView.dataSource =self;
    [self.appealTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:textViewCellId];
    UIView *View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-64-80-43)];
    View.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 9, self.view.width-40, 15)];
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
    label.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
    label.text = @"小建议：在平台申诉前，建议你先通过App聊天系统";
    UIButton *Btn = [[UIButton alloc]initWithFrame:CGRectMake(124, 194.5, 127, 33)];
    Btn.backgroundColor= MainCorlor;
    [Btn setTitle:@"向平台申诉" forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(appealActive) forControlEvents:UIControlEventTouchUpInside];
    Btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    Btn.layer.masksToBounds = YES;
    Btn.layer.cornerRadius = 2.5;
    [View addSubview:label];
    [View addSubview:Btn];
    [self.appealTableView setTableFooterView:View];
    [self.view addSubview:self.appealTableView];
    
}

- (void)appealActive{
    if (_words.length==0) {
        [self showHint:@"请输入申诉原因" yOffset:-200];
    }else{
        NSString *urlStr = @"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Moment&a=addAppeal";
        NSDictionary *dict = @{@"momentId":self.momentId,@"userId":UserId,@"words":_words};
        [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
            if ([responseObject[@"code"] integerValue] == 200) {
                [self showHint:@"申诉成功" yOffset:-200];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self showHint:responseObject[@"message"] yOffset:-200];
            }
        } failureBlock:^(NSError *error) {
            
        }];
    }
}

#pragma tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10.5, 100, 21)];
        label.text = @"活动发起人：";
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        label.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        [cell addSubview:label];
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 10.5, 50, 21)];
        nameLabel.text =self.sponsorName;
        nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        nameLabel.textColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
        [cell addSubview:nameLabel];
        return cell;
    }else if(indexPath.row == 1){
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10.5, 100, 21)];
        label.text = @"活动标题：";
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        label.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        [cell addSubview:label];
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 10.5, 200, 21)];
        nameLabel.text = self.activeTitle;
        nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        nameLabel.textColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
        [cell addSubview:nameLabel];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:textViewCellId forIndexPath:indexPath];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textViewCellId];
        }
        UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(20, 5, kScreenWidth - 35, 120)];
        textView.text = @"请输入申诉原因";
        textView.delegate = self;
        textView.textColor = self.words.length>0?UUBLACK:UUGREY;
        [cell addSubview:textView];
        return cell;
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    textView.text = _words.length>0?_words:@"";
    textView.textColor = UUBLACK;
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    _words = textView.text;
    textView.text = _words.length>0?_words:@"请输入申诉原因";
    textView.textColor = _words.length>0?UUBLACK:UUGREY;
    return YES;
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 39;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 34;

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-64)];
    view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:242/255.0 alpha:1];
    UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(20, 7.5, self.view.width, 18.5)];
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    label.textColor = MainCorlor;
    label.text =@"您要申诉此次活动，请核对发起人与活动信息";
    [view addSubview:label];
    return view;

}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1],UITextAttributeTextColor,nil]];
    
}
@end
