//
//  SendOrderCell.h
//  UUBaoKu
//
//  Created by 漪珊 on 2017/3/31.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUBaseTableViewCell.h"

@interface SendOrderCell : UUBaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detail;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end
