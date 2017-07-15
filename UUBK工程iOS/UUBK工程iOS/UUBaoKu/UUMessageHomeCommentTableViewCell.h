//
//  UUMessageHomeCommentTableViewCell.h
//  UUBaoKu
//
//  Created by admin on 16/12/28.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUMessageHomeCommentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
