//
//  UUWebfriendrecommentTableViewCell.m
//  UUBaoKu
//
//  Created by admin on 17/1/11.
//  Copyright © 2017年 loongcrown. All rights reserved.
//＝＝＝＝＝＝＝＝＝＝＝＝＝网友推荐＝＝＝＝＝＝＝＝＝＝＝

#import "UUWebfriendrecommentTableViewCell.h"
#import "UUrecommendTableViewCell.h"
#import "UURecommendeddetailsTableViewCell.h"
#import "UUNetGoodsModel.h"

@interface UUWebfriendrecommentTableViewCell ()<UITableViewDelegate,UITableViewDataSource,RecommentDelegate>
@end
@implementation UUWebfriendrecommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.WebuitableView.delegate =self;
    self.WebuitableView.dataSource =self;
    self.WebuitableView.frame = CGRectMake(0, 0, self.width, self.height);
    self.WebuitableView.scrollEnabled = NO;
}

- (void)goGoodsDetailWithCell:(UUrecommendTableViewCell *)cell{
    [self.delegate goToGoodsDetailWithGoodsId:cell.goodsId OrUrl:cell.url];
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"UUWebfriendrecommentTableViewCell";
    UUWebfriendrecommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"UUWebfriendrecommentTableViewCell" owner:nil options:nil][0];
    }
    
    return cell;
}

- (void)setModel:(UUNetFriendsRecommendModel *)model{
    _model = model;
    [self.WebuitableView reloadData];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        UUrecommendTableViewCell *cell = [UUrecommendTableViewCell cellWithTableView:tableView ];
        cell.goodsModel = [[UUNetGoodsModel alloc]initWithDict:self.model.goodsList[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    }else{
        UURecommendeddetailsTableViewCell *cell = [UURecommendeddetailsTableViewCell cellWithTableView:tableView];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.userIcon sd_setImageWithURL:[NSURL URLWithString:_model.userIcon] placeholderImage:HolderImage];
        cell.userName.text = _model.userName;
        cell.words.text =_model.words;
        return cell;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.webfriendArray.count;
    if (section==0) {
        return _model.goodsList.count;
    }else{
        return 1;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0) {
        
         return 108.5;
        
    }else{
        return 71;
    
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

/**
 *  下面两个方法解决cell分割线不到左边界的问题
 */
-(void)viewDidLayoutSubviews {
    
    if ([self.WebuitableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.WebuitableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.WebuitableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.WebuitableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    if ([self.WebuitableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.WebuitableView setSeparatorInset:UIEdgeInsetsMake(0, 45, 0, 0)];
        
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


@end
