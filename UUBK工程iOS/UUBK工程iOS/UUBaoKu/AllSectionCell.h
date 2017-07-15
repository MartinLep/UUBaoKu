//
//  AllSectionCell.h
//  UUBaoKu
//
//  Created by 漪珊 on 2017/2/20.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUBaseTableViewCell.h"
@class AllSectionModel;

@interface AllSectionCell : UUBaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *sectionTiltle;
@property (nonatomic, strong) AllSectionModel *sectionModel;
@end
