//
//  UUactivityMoreDataTableViewCell.h
//  UUBaoKu
//
//  Created by admin on 16/11/12.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyActivityDelegate <NSObject>

- (void)surnActivityWithIndexPath:(NSIndexPath *)indexPath;
- (void)applyActivityWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface UUactivityMoreDataTableViewCell : UITableViewCell<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *myActivityBegin;
@property (weak, nonatomic) IBOutlet UIButton *SureBtn;
@property (weak, nonatomic) IBOutlet UILabel *releaseTime;

@property (weak, nonatomic) IBOutlet UIButton *AppealBtn;

- (IBAction)sureActivityAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *detailsBtn;

- (IBAction)applyActivityAction:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UIImageView *userIcon;

@property (weak, nonatomic) IBOutlet UILabel *userName;


@property (weak, nonatomic) IBOutlet UILabel *titleActivityTitle;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIView *imageContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageContentHeight;

@property(weak,nonatomic)id<MyActivityDelegate>delegate;

//图片数组
@property(strong,nonatomic)NSArray *imgsArray;


+ (instancetype)cellWithTableView:(UITableView *)tableView;


-(void)imageFrame;
@end
