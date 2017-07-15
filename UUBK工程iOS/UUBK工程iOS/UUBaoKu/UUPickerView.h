//
//  UUPickerView.h
//  UUBaoKu
//
//  Created by dev2 on 2017/5/19.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUAddressModel.h"
#import "UUCategoryModel.h"

typedef enum {
    PickerViewAddressType,
    PickerViewNormalType,
    PickerViewCategoryType
}PickerType;

@interface UUPickerView : UIView

@property (strong,nonatomic)void(^(selectedAddress))(UUAddressModel *address);
@property (strong,nonatomic)void(^(selectedCategory))(UUCategoryModel *category);
@property (strong,nonatomic)void(^(selectedResponse))(NSString *response);
@property (strong,nonatomic)NSArray *dataSource;
- (instancetype)initWithFrame:(CGRect)frame andType:(PickerType )pickerType;
@end
