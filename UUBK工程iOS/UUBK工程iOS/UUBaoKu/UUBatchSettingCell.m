//
//  UUBatchSettingCell.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/23.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUBatchSettingCell.h"
#import "UUBatchSettingFirstCell.h"
#import "UUBatchSettingSecondCell.h"
#import "UUGoodsSpecModel.h"

@interface UUBatchSettingCell()<
UITableViewDelegate,
UITableViewDataSource,
SettingDelegate>

@property(assign,nonatomic)BOOL batchSetting;

@end

static NSString *const firstCellId = @"UUBatchSettingFirstCell";
static NSString *const secondCellId = @"UUBatchSettingSecondCell";

@implementation UUBatchSettingCell
{
    CGFloat distributionPrice;
    CGFloat commdityPrice;
    NSInteger goodsStock;
    CGFloat goodsWeight;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:firstCellId bundle:nil] forCellReuseIdentifier:firstCellId];
    [self.tableView registerNib:[UINib nibWithNibName:secondCellId bundle:nil] forCellReuseIdentifier:secondCellId];
    // Initialization code
}

- (void)setDataSource:(NSArray *)dataSource{
    _dataSource = dataSource;
    distributionPrice = 0;
    commdityPrice = 0;
    goodsStock = 0;
    goodsWeight = 0;
    
    [self.tableView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return self.dataSource.count;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UUBatchSettingFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:firstCellId forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:firstCellId owner:nil options:nil].lastObject;
        }
        cell.delegate = self;
        if (self.dataSource.count>0) {
            cell.settingBtn.layer.borderColor = UURED.CGColor;
            [cell.settingBtn setTitleColor:UURED forState:UIControlStateNormal];
            cell.settingBtn.userInteractionEnabled = YES;
        }else{
            cell.settingBtn.userInteractionEnabled = NO;
        }
        return cell;
    }else{
        UUBatchSettingSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:secondCellId forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:secondCellId owner:nil options:nil].lastObject;
        }
        
        cell.distributionPrice.text = distributionPrice>0?[NSString stringWithFormat:@"%.2f",distributionPrice]:@"0";
        cell.commodityPrice.text = commdityPrice>0?[NSString stringWithFormat:@"%.2f",commdityPrice]:@"0";
        cell.goodsStock.text = goodsStock>0?[NSString stringWithFormat:@"%ld",goodsStock]:@"0";
        cell.goodsWeight.text = goodsWeight>0?[NSString stringWithFormat:@"%.2f",goodsWeight]:@"0";
        
        UUGoodsSpecModel *model = self.dataSource[indexPath.row];
        cell.titleLab.text = model.SpecName;
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(specEdited) forControlEvents:UIControlEventTouchUpInside];
        sureBtn.backgroundColor = UURED;
        [footer addSubview:sureBtn];
        return footer;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 40;
    }else{
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 40;
    }else{
        return 107;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}
- (void)batchSettingAction{
    UUBatchSettingSecondCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    distributionPrice = [cell.distributionPrice.text floatValue];
    commdityPrice = [cell.commodityPrice.text floatValue];
    goodsStock = [cell.goodsStock.text integerValue];
    goodsWeight = [cell.goodsWeight.text integerValue];
    [self.tableView reloadData];
}

- (void)specEdited{
    [self.delegate completedEditingWithResponse:@{@"PurchasePrice":[NSNumber numberWithFloat:commdityPrice],@"DistributionPrice":[NSNumber numberWithFloat:distributionPrice],@"GoodsWeight":[NSNumber numberWithFloat:goodsWeight],@"GoodsNum":[NSNumber numberWithInteger:goodsStock]}];
}
@end
