//
//  UUZoneDetailViewController.h
//  UUBaoKu
//
//  Created by dev2 on 2017/6/29.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUBaseViewController.h"

@interface UUZoneDetailViewController : UUBaseViewController
@property (weak, nonatomic) IBOutlet UIView *commentBackView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *commentTF;
@property (weak, nonatomic) IBOutlet UIButton *releaseBtn;
@property (nonatomic,strong)NSString *articleId;
@end
