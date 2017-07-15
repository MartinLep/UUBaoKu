//
//  AddressBookTopCell.h
//  UUBaoKu
//
//  Created by 漪珊 on 2017/2/16.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUBaseTableViewCell.h"
@protocol AddressBookTopCellDelegate<NSObject>
- (void)lookUpMsg;
@end

@interface AddressBookTopCell : UUBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ImgOne;
@property (weak, nonatomic) IBOutlet UIImageView *ImgTwo;
@property (weak, nonatomic) IBOutlet UIButton *lookBtn;
@property (nonatomic, weak) id<AddressBookTopCellDelegate>delegate;
@end
