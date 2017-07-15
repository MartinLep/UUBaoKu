//
//  UUGoodsShelfCell.h
//  UUBaoKu
//
//  Created by dev2 on 2017/5/18.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShelfDelegate <NSObject>

- (void)shelfSelected;

@end
@interface UUGoodsShelfCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *descLab;
@property(weak,nonatomic)id<ShelfDelegate>delegate;
@end
