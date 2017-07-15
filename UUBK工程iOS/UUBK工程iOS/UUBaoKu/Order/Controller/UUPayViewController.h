//
//  UUPayViewController.h
//  UUBaoKu
//
//  Created by dev2 on 2017/5/11.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUBaseViewController.h"

@interface UUPayViewController : UUBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSString *orderNO;
@property (nonatomic,strong)NSString *orderType;
@property (nonatomic,strong)NSString *money;
@property (nonatomic,strong)NSString *consignee;
@property (nonatomic,strong)NSString *address;
@end
