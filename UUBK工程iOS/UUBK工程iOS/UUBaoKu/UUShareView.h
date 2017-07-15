//
//  UUShareView.h
//  UUBaoKu
//
//  Created by dev2 on 2017/5/10.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUShareInfoModel.h"

@interface UUShareView : UIView
@property (strong, nonatomic) IBOutlet UUShareView *shareView;
@property(strong,nonatomic)NSString *goodsId;
@property(strong,nonatomic)UUShareInfoModel *model;
- (IBAction)WXShareAvtion:(UIButton *)sender;
- (IBAction)QQShareAction:(UIButton *)sender;
- (IBAction)WXCircleAction:(UIButton *)sender;
- (IBAction)FaceShareAction:(UIButton *)sender;
- (IBAction)SinaShareAction:(UIButton *)sender;
- (IBAction)SMSShareAction:(UIButton *)sender;
- (IBAction)CopyLinkAction:(UIButton *)sender;
- (IBAction)QQZoneShareAction:(UIButton *)sender;
- (IBAction)FriendShareAction:(UIButton *)sender;
@end
