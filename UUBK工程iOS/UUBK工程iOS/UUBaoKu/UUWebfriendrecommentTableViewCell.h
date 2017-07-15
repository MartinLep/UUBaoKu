//
//  UUWebfriendrecommentTableViewCell.h
//  UUBaoKu
//
//  Created by admin on 17/1/11.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUNetFriendsRecommendModel.h"

@protocol NetFriendsDelegate<NSObject>
- (void)goToGoodsDetailWithGoodsId:(NSString *)goodsId OrUrl:(NSString *)url;
@end
@interface UUWebfriendrecommentTableViewCell : UITableViewCell
@property(weak,nonatomic)id<NetFriendsDelegate>delegate;
@property (weak, nonatomic) IBOutlet UITableView *WebuitableView;
@property(strong,nonatomic)NSDictionary *webfriendDict;
@property(strong,nonatomic)NSArray *webfriendArray;
@property(strong,nonatomic)UUNetFriendsRecommendModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
