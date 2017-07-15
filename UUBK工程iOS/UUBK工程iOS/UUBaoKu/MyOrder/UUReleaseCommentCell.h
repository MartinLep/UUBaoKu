//
//  UUReleaseCommentCell.h
//  UUBaoKu
//
//  Created by dev2 on 2017/5/24.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReleaseCommentDelegate <NSObject>

- (void)releaseComment;

@end
@interface UUReleaseCommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *isAnonymous;
@property (strong,nonatomic)void(^(setAnonymous))(BOOL isAnonymous);
@property (nonatomic,weak)id<ReleaseCommentDelegate>delegate;
- (IBAction)selectAnonymous:(UIButton *)sender;
- (IBAction)releaseComment:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *releaseBtn;

@end
