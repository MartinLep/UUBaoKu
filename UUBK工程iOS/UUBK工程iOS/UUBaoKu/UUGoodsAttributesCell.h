//
//  UUGoodsAttributesCell.h
//  UUBaoKu
//
//  Created by dev2 on 2017/5/18.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UUGoodsAttributesCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *brand;
@property (weak, nonatomic) IBOutlet UITextField *expiredDate;
@property (weak, nonatomic) IBOutlet UITextField *rightAge;
@property (weak, nonatomic) IBOutlet UITextField *goodsNo;
@property (weak, nonatomic) IBOutlet UITextField *packaging;
@property (weak, nonatomic) IBOutlet UITextField *salePlace;
@property (weak, nonatomic) IBOutlet UIView *contentBackView;
@property (nonatomic, strong)NSArray *dataSource;

@end
