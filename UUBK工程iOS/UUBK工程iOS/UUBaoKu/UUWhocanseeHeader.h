//
//  UUWhocanseeHeader.h
//  UUBaoKu
//
//  Created by dev2 on 2017/6/16.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WhoCanSeeDelegate <NSObject>

- (void)selectedStatusWithIndex:(NSInteger)index;

@end
@interface UUWhocanseeHeader : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
- (IBAction)statusChangeAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
@property(weak,nonatomic)id<WhoCanSeeDelegate>delegate;
@end
