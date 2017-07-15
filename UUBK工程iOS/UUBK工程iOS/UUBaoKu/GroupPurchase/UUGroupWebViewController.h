//
//  UUGroupWebViewController.h
//  UUBaoKu
//
//  Created by dev2 on 2017/5/20.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUBaseViewController.h"

typedef enum{
    GroupTJJXDetailWebType=1,
    GroupTJJXJoinWebType,
    GroupBQDetailWebType=2,
    GroupBQJoinWebType,
    GroupXYDetailWebType=3,
    GroupXYJoinWebType,
    GroupXYCheckNumWebType=4,
    GroupQYDetailWebType=5,
    GroupBQLuckyDetailWebType
}GroupWebViewType;
@interface UUGroupWebViewController : UUBaseViewController
@property(assign,nonatomic)GroupWebViewType webType;
@property(strong,nonatomic)NSString *orderNo;
@property(strong,nonatomic)NSString *teamId;
@end
