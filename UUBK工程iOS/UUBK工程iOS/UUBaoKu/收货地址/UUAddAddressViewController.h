//
//  UUAddAddressViewController.h
//  UUBaoKu
//
//  Created by dev on 17/3/2.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUBaseViewController.h"

@interface UUAddAddressViewController : UUBaseViewController<
UITableViewDelegate,
UITableViewDataSource,
UIGestureRecognizerDelegate>

@property(strong,nonatomic)UITextField *rightTF;
@property(strong,nonatomic)UILabel *rightLab;
@property(strong,nonatomic)UISwitch *defaultSwitch;
@property (strong,nonatomic)UITextField *ConsigneeTF;
@property (strong,nonatomic)UITextField *MobileTF;
@property (strong,nonatomic)UITextField *ZipCodeTF;
@property (strong,nonatomic)UITextField *StreetTF;
@property (assign,nonatomic)NSInteger isDefault;
@property (assign,nonatomic)NSInteger ProvinceID;
@property (assign,nonatomic)NSInteger cityID;
@property (assign,nonatomic)NSInteger districtID;
@property(strong,nonatomic)UITapGestureRecognizer *tap;
- (void)shoppingAddressSelect;
-(void)switchAction:(id)sender;
- (void)cancelAction;
@end
