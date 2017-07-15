//
//  UUBatchSettingFirstCell.h
//  UUBaoKu
//
//  Created by dev2 on 2017/5/23.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingDelegate <NSObject>

- (void)batchSettingAction;

@end
@interface UUBatchSettingFirstCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *settingBtn;
@property (weak, nonatomic) id<SettingDelegate>delegate;

@end
