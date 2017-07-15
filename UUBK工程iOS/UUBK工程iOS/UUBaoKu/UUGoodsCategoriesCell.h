//
//  UUGoodsCategoriesCell.h
//  UUBaoKu
//
//  Created by dev2 on 2017/5/18.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CategoryDelegate <NSObject>

- (void)selectedCategoryWithTag:(NSInteger)tag;

@end
@interface UUGoodsCategoriesCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *firstGradeLab;
@property (weak, nonatomic) IBOutlet UILabel *secondGradeLab;
@property (weak, nonatomic) IBOutlet UILabel *thirdGradeLab;

@property(weak,nonatomic)id<CategoryDelegate>delegate;
@end
