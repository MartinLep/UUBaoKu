//
//  UUGroupMemberTableViewCell.h
//  UUBaoKu
//
//  Created by dev2 on 2017/5/10.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GroupManagerDelegate <NSObject>

- (void)addMember;
- (void)deleteMember;

@end
@interface UUGroupMemberTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong,nonatomic)NSArray *memberDataSource;
@property(nonatomic,weak)id<GroupManagerDelegate>delegate;
@property(nonatomic,strong)NSString *holderId;
@end
