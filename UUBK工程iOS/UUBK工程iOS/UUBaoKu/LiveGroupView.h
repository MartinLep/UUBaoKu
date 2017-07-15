//
//  LiveGroupView.h
//  UUBaoKu
//
//  Created by 漪珊 on 2017/4/8.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LiveGroupViewDelegate <NSObject>

- (void)setGroup;

@end
@interface LiveGroupView : UIView
@property (weak, nonatomic) IBOutlet UIButton *groupSetBtn;
@property (nonatomic, weak) id<LiveGroupViewDelegate>delegate;
@end
