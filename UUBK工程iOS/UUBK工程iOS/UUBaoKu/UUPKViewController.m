//
//  UUPKViewController.m
//  UUBaoKu
//
//  Created by admin on 16/10/22.
//  Copyright © 2016年 loongcrown. All rights reserved.
//==========================摇一摇 PK===================================

#import "UUPKViewController.h"
#import "UUInitiatedPKTableViewCell.h"
#import "UIView+Ex.h"
//
@interface UUPKViewController ()<UITableViewDataSource,UITableViewDelegate>
//PK
@property(strong,nonatomic)UITableView *PKTableView;
@end

@implementation UUPKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title =@"发起摇一摇PK";
    self.PKTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    
    self.PKTableView.delegate = self;
    self.PKTableView.dataSource =self;
    
    
    
    [self.view addSubview:self.PKTableView];
}


#pragma tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UUInitiatedPKTableViewCell *cell = [UUInitiatedPKTableViewCell cellWithTableView:tableView];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone]; 
    [cell.backBtn addTarget:self action:@selector(Back) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 315.5;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 10;
    
}

-(void)Back{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
