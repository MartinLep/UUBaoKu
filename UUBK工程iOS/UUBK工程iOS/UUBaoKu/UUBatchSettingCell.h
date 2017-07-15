//
//  UUBatchSettingCell.h
//  UUBaoKu
//
//  Created by dev2 on 2017/5/23.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SpecEditedDelegate <NSObject>

- (void)completedEditingWithResponse:(NSDictionary *)response;

@end
@interface UUBatchSettingCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSArray *dataSource;
@property (weak, nonatomic) id<SpecEditedDelegate>delegate;
@end
