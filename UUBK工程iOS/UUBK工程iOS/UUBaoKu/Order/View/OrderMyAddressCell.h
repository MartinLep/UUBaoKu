//
//  OrderMyAddressCell.h
//  UUBaoKu
//
//  Created by 漪珊 on 2017/3/28.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUBaseTableViewCell.h"
@class OrderMyAddressCell;
@protocol OrderMyAddressCellDelegate<NSObject>
- (void)addressFunctionWithTag:(NSString *)tag Cell:(OrderMyAddressCell*)cell Button:(UIButton*)sender;
@end
@interface OrderMyAddressCell : UUBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *addAddresss;
@property (weak, nonatomic) IBOutlet UIButton *enterAddresslistBtn;
@property (nonatomic, weak) id<OrderMyAddressCellDelegate>delegate;
@end
