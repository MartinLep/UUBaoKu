//
//  UUSearchMemberCell.h
//  UUBaoKu
//
//  Created by dev2 on 2017/5/15.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchDelegate <NSObject>

- (void)segmentSelectedWithTag:(NSInteger )tag;
- (void)searchActionWithMobile:(NSString *)mobile;
@end
@interface UUSearchMemberCell : UITableViewCell
- (IBAction)searchAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UILabel *descLab;
@property (weak, nonatomic) IBOutlet UILabel *numDescLab;
@property (weak, nonatomic) IBOutlet UILabel *descLab1;
@property (weak, nonatomic) IBOutlet UILabel *descLab2;
@property (weak,nonatomic) id<SearchDelegate>delegate;
@end
