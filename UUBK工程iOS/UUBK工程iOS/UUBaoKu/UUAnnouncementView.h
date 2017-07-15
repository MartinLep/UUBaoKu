//
//  UUAnnouncementView.h
//  UUBaoKu
//
//  Created by dev2 on 2017/6/28.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AnnounceDelegate<NSObject>
- (void)goToMoreAnnounce;
@end
@interface UUAnnouncementView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *descLab;
@property (nonatomic,weak)id<AnnounceDelegate>delegate;
- (IBAction)moreAnnouncementAction:(id)sender;

@end
