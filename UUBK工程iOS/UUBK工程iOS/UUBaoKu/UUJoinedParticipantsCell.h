//
//  UUJoinedParticipantsCell.h
//  UUBaoKu
//
//  Created by dev2 on 2017/5/8.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUJoinedParticipantsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong)NSArray *imagesData;
@end
