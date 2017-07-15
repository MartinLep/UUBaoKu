//
//  UUBaseTableViewCell.h
//  UUBaoKu
//
//  Created by 漪珊 on 2017/2/16.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUBaseTableViewCell : UITableViewCell
//加载非xibCell

+ (instancetype)loadNormalCellWithTabelView:(UITableView *)tableView;

//加载xibCell

+ (instancetype)loadNibCellWithTabelView:(UITableView *)tableView;
@end
