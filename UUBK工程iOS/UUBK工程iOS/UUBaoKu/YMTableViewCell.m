//
//  YMTableViewCell.m
//  WFCoretext
//
//  Created by 阿虎 on 14/10/28.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
// 2 3 2 2 2 3 1 3 2 1

#import "YMTableViewCell.h"
#import "WFReplyBody.h"
#import "ContantHead.h"
#import "YMTapGestureRecongnizer.h"
#import "WFHudView.h"

#define kImageTag 9999


@implementation YMTableViewCell
{
    
    YMTextData *tempDate;
    UIImageView *replyImageView;
    UIView *_linkBackView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        _userHeaderImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 42, TableHeader)];
        _userHeaderImage.backgroundColor = [UIColor clearColor];
        CALayer *layer = [_userHeaderImage layer];
        [layer setMasksToBounds:YES];
        [layer setBorderColor:[[UIColor colorWithRed:63/255.0 green:107/255.0 blue:252/255.0 alpha:1.0] CGColor]];
        [self.contentView addSubview:_userHeaderImage];
        //点击头像  进入别人的朋友圈的按钮
        _friendMessageBtn = [[YMButton alloc] initWithFrame:CGRectMake(20, 5, 42, TableHeader)];
        
       
        
        [self.contentView addSubview:_friendMessageBtn];
        
        
        
        _userNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(20 + TableHeader + 20-15, 5, screenWidth - 120, TableHeader/2)];
        _userNameLbl.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        _userNameLbl.textAlignment = NSTextAlignmentLeft;
        _userNameLbl.font = [UIFont systemFontOfSize:15.0];
        _userNameLbl.textColor = [UIColor colorWithRed:30/255.0 green:76/255.0 blue:129/255.0 alpha:1.0];
        [self.contentView addSubview:_userNameLbl];
        
        
        
        
        _imageArray = [[NSMutableArray alloc] init];
        _ymTextArray = [[NSMutableArray alloc] init];
        _ymShuoshuoArray = [[NSMutableArray alloc] init];
        _ymFavourArray = [[NSMutableArray alloc] init];
        
        __foldBtn = [UIButton buttonWithType:0];
        [__foldBtn setTitle:@"展开" forState:0];
        __foldBtn.backgroundColor = [UIColor clearColor];
        __foldBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [__foldBtn setTitleColor:[UIColor grayColor] forState:0];
        [__foldBtn addTarget:self action:@selector(foldText) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:__foldBtn];
        
        replyImageView = [[UIImageView alloc] init];
        
        replyImageView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
        [self.contentView addSubview:replyImageView];
        
        _replyBtn = [YMButton buttonWithType:0];
        _replyBtn.tag = 0;
        //点赞
        [_replyBtn setImage:[UIImage imageNamed:@"评论按钮"] forState:0];
        //评论
        _likeBtn = [YMButton buttonWithType:0];
        _likeBtn.tag = 1;
        [_likeBtn setImage:[UIImage imageNamed:@"朋友圈点赞"] forState:0];
        
        [self.contentView addSubview:_replyBtn];
        [self.contentView addSubview:_likeBtn];
        
        _timeLab = [[UILabel alloc]init];
        _timeLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
        _timeLab.textColor = UUGREY;
        
        [self.contentView addSubview:_timeLab];
        
        _delBtn = [YMButton buttonWithType:0];
        [_delBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_delBtn setTitleColor:[UIColor colorWithRed:30/255.0 green:76/255.0 blue:129/255.0 alpha:1] forState:UIControlStateNormal];
        _delBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:_delBtn];
        _favourImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _favourImage.image = [UIImage imageNamed:@"zan.png"];
        [self.contentView addSubview:_favourImage];
        
       //链接
        _linkBackView = [[UIView alloc]initWithFrame:CGRectZero];
        _linkBackView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
        
        [self.contentView addSubview:_linkBackView];
        //查看  详情
        
//        _eventDetails= [[UIButton alloc] init];
//        _eventDetails.backgroundColor = [UIColor redColor];
//        
//        [self.contentView addSubview:_eventDetails];
//        
//         
        _activityBtn = [[YMButton alloc] initWithFrame:CGRectZero];
//
//        
        [_activityBtn setTitle:@"查看活动详情" forState:UIControlStateNormal];
        [_activityBtn setTitleColor:[UIColor colorWithRed:263/255.0 green:74/255.0 blue:72/255.0 alpha:1] forState:UIControlStateNormal];
        [_activityBtn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:15]];
//
//      [_moreDataBtn setBackgroundColor:[UIColor redColor]];
        [_activityBtn.layer setBorderColor:UURED.CGColor];
//
//        _moreDataBtn.layer.masksToBounds = YES;
        _activityBtn.layer.cornerRadius = 2.5;
        [_activityBtn.layer setBorderWidth:0.5];
//        //设置边界的宽度
//        
        [self.contentView addSubview:_activityBtn];
    }
    return self;
}

- (void)foldText{
    
    if (tempDate.foldOrNot == YES) {
        tempDate.foldOrNot = NO;
        [__foldBtn setTitle:@"收起" forState:0];
    }else{
        tempDate.foldOrNot = YES;
        [__foldBtn setTitle:@"展开" forState:0];
    }
    
    [_delegate changeFoldState:tempDate onCellRow:self.stamp];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setYMViewWith:(YMTextData *)ymData{
  
    tempDate = ymData;
    
#pragma mark -  //头像 昵称 简介
    
//    _userHeaderImage.image = [UIImage imageNamed:tempDate.messageBody.posterImgstr];
    
    
    
    NSString *str =tempDate.messageBody.posterImgstr;
    [_userHeaderImage sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    _userNameLbl.text = tempDate.messageBody.posterName;
//    _userIntroLbl.text = tempDate.messageBody.posterIntro;
    
    //移除说说view 避免滚动时内容重叠
    for ( int i = 0; i < _ymShuoshuoArray.count; i ++) {
        WFTextView * imageV = (WFTextView *)[_ymShuoshuoArray objectAtIndex:i];
        if (imageV.superview) {
            [imageV removeFromSuperview];
            
        }
    }
    
    [_ymShuoshuoArray removeAllObjects];
  
#pragma mark - // /////////添加说说view

    WFTextView *textView = [[WFTextView alloc] initWithFrame:CGRectMake(offSet_X+47, 5 + TableHeader/2.0, screenWidth - 2 * offSet_X-2*47, 0)];
    textView.delegate = self;
    textView.attributedData = ymData.attributedDataShuoshuo;
    textView.isFold = ymData.foldOrNot;
    textView.isDraw = YES;
    textView.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
    
    [textView setOldString:ymData.showShuoShuo andNewString:ymData.completionShuoshuo];
    [self.contentView addSubview:textView];
    
    BOOL foldOrnot = ymData.foldOrNot;
    float hhhh = foldOrnot?ymData.shuoshuoHeight:ymData.unFoldShuoHeight;
    
    textView.frame = CGRectMake(offSet_X+47, 5 + TableHeader/2.0, screenWidth - 2 * offSet_X-47, hhhh);
    
    [_ymShuoshuoArray addObject:textView];
    
    
    
    //按钮
    __foldBtn.frame = CGRectMake(offSet_X - 10+47, 5 + TableHeader/2.0 + hhhh + 10 , 50, 20 );
//    _moreDataBtn.frame = CGRectMake(67, self.height-34, 127, 33);
    
    if (ymData.islessLimit) {//小于最小限制 隐藏折叠展开按钮
        
        __foldBtn.hidden = YES;
        
        
        
    }else{
        __foldBtn.hidden = NO;
    }
    
    
    if (tempDate.foldOrNot == YES) {
        
        [__foldBtn setTitle:@"展开" forState:0];
    }else{
        
        [__foldBtn setTitle:@"收起" forState:0];
    }
    
#pragma mark - /////// //图片部分
    for (int i = 0; i < [_imageArray count]; i++) {
        
        UIImageView * imageV = (UIImageView *)[_imageArray objectAtIndex:i];
        imageV.contentMode = UIViewContentModeScaleAspectFill;
        imageV.backgroundColor = BACKGROUNG_COLOR;
        [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_imageArray[i]]]];
        
        if (imageV.superview) {
            [imageV removeFromSuperview];
            
        }
     }
    [_imageArray removeAllObjects];
    
    CGFloat spacing = (kScreenWidth - offSet_X - 47 - 80*3)/3.0;
    for (int  i = 0; i < [ymData.showImageArray count]; i++) {
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(offSet_X+47+ spacing*(i%3) + 80*(i%3), TableHeader/2.0-10 + 10 * ((i/3) + 1) + (i/3) *  ShowImage_H + hhhh + kDistance + (ymData.islessLimit?0:30), 80, ShowImage_H)];
        image.userInteractionEnabled = YES;
        
        YMTapGestureRecongnizer *tap = [[YMTapGestureRecongnizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [image addGestureRecognizer:tap];
        tap.appendArray = ymData.showImageArray;
        image.backgroundColor = [UIColor clearColor];
        image.tag = kImageTag + i;
//        image.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[ymData.showImageArray objectAtIndex:i]]];
        NSString *str = [NSString stringWithFormat:@"%@",[ymData.showImageArray objectAtIndex:i]];
        [image sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:PLACEHOLDIMAGE];
        
        [self.contentView addSubview:image];
        [_imageArray addObject:image];
        
    }
    
   
#pragma mark 链接部分

//    _linkBackView.frame = CGRectMake(offSet_X+47, backView_Y - 10 + balanceHeight + 5 + kReplyBtnDistance, screenWidth - offSet_X * 2-47, backView_H + 20 - 8);
#pragma mark - /////点赞部分
    //移除点赞view 避免滚动时内容重叠
    for ( int i = 0; i < _ymFavourArray.count; i ++) {
        WFTextView * imageV = (WFTextView *)[_ymFavourArray objectAtIndex:i];
        if (imageV.superview) {
            [imageV removeFromSuperview];
         }
    }
     [_ymFavourArray removeAllObjects];
    float origin_Y = 10;
    NSUInteger scale_Y = ymData.showImageArray.count - 1;
    float balanceHeight = 0; //纯粹为了解决没图片高度的问题
    if (ymData.showImageArray.count == 0) {
        scale_Y = 0;
        balanceHeight = - ShowImage_H - kDistance ;
    }
    
    float backView_Y = 0;
    float backView_H = 0;
     //评论 textview
    
    //链接部分
    _linkBackView.frame = CGRectMake(offSet_X+47, TableHeader/2.0-10 + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30) + balanceHeight , !ymData.messageBody.linkUrl?0: screenWidth - offSet_X * 2-47, !ymData.messageBody.linkUrl?0:33);
    
    UIImageView *linkImage = [[UIImageView alloc]initWithFrame:CGRectMake(4, 4, 46, 46)];
    [_linkBackView addSubview:linkImage];
    
    [linkImage sd_setImageWithURL:[NSURL URLWithString:tempDate.messageBody.linkUrl] placeholderImage:PLACEHOLDIMAGE];
    UILabel *linkTitle = [[UILabel alloc]initWithFrame:CGRectMake(59, 16, _linkBackView.frame.size.width - 59 - 5, 22.5)];
    linkTitle.font = [UIFont systemFontOfSize:16];
    linkTitle.text = ymData.messageBody.posterIntro;
    if (!ymData.messageBody.linkUrl) {
        linkImage.frame = CGRectZero;
        linkTitle.frame = CGRectZero;
    }

    //活动详情按钮
    _activityBtn.frame = CGRectMake(offSet_X+47, TableHeader/2.0-10 + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30) + balanceHeight , ymData.messageBody.isActivite==0?0: 127, !ymData.messageBody.isActivite?0:33);
    WFTextView *favourView = [[WFTextView alloc] initWithFrame:CGRectMake(offSet_X + 30+47, TableHeader/2.0-10 + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30) + balanceHeight + kReplyBtnDistance+(ymData.messageBody.isActivite==0?0:40)+ (!ymData.messageBody.linkUrl?0:54), screenWidth - 2 * offSet_X - 30-47, 0)];
    
    favourView.delegate = self;
    favourView.attributedData = ymData.attributedDataFavour;
    favourView.isDraw = YES;
    favourView.isFold = NO;
    favourView.canClickAll = NO;
    favourView.textColor = [UIColor colorWithRed:30/255.0 green:76/255.0 blue:129/255.0 alpha:1];
    [favourView setOldString:ymData.showFavour andNewString:ymData.completionFavour];
    favourView.frame = CGRectMake(offSet_X + 30+47,TableHeader/2.0-10 + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30)+(ymData.messageBody.isActivite==0?0:40)+ (!ymData.messageBody.linkUrl?0:54) + balanceHeight + kReplyBtnDistance, screenWidth - offSet_X * 2 - 30-47, ymData.favourHeight);
    [self.contentView addSubview:favourView];
    backView_H += ((ymData.favourHeight == 0)?(-kReply_FavourDistance):ymData.favourHeight);
    [_ymFavourArray addObject:favourView];
    
//    if (_ymFavourArray.count !=0) {
//        //查看详情按钮的位置
//        self.eventDetails.frame =CGRectMake(67, TableHeader + 10 * (((int)_ymFavourArray.count/3) + 1) + ((int)_ymFavourArray.count/3) *  ShowImage_H + hhhh + kDistance + (ymData.islessLimit?0:30)+80+10, 127, 33);
//    }else{
//    
//    
//        self.eventDetails.frame =CGRectMake(67, TableHeader + 10 * ((0/3) + 1) + (0) *  ShowImage_H + hhhh + kDistance + (ymData.islessLimit?0:30), 127, 33);
//
//    
//    
//    }
//    

    
    
    //   self.eventDetails = [[UIButton alloc] initWithFrame:CGRectMake(offSet_X + 30+47, TableHeader + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30) + balanceHeight + kReplyBtnDistance, screenWidth - 2 * offSet_X - 30-47, 0)];
//    self.eventDetails.backgroundColor = [UIColor redColor];
//    
//    [self addSubview:self.eventDetails];
    
//点赞图片的位置
    _favourImage.frame = CGRectMake(offSet_X+47 , favourView.frame.origin.y, (ymData.favourHeight == 0)?0:20,(ymData.favourArray.count == 0)?0:20);
    
    
    
//    _moreDataBtn.frame = CGRectMake(67, TableHeader + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30) + balanceHeight + kReplyBtnDistance-34, 127, 33);
    
  
#pragma mark - ///// //最下方回复部分
    for (int i = 0; i < [_ymTextArray count]; i++) {
        
        WFTextView * ymTextView = (WFTextView *)[_ymTextArray objectAtIndex:i];
        if (ymTextView.superview) {
            [ymTextView removeFromSuperview];
         }
    }
    
    [_ymTextArray removeAllObjects];
  
    for (int i = 0; i <  tempDate.messageBody.timeStrArr.count; i++) {
        _timeLab.text =tempDate.messageBody.timeStrArr[i];
    }
    for (int i = 0; i < ymData.replyDataSource.count; i ++ ) {
        
        WFTextView *_ilcoreText = [[WFTextView alloc] initWithFrame:CGRectMake(offSet_X+47,TableHeader/2.0-10 + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30) + balanceHeight + kReplyBtnDistance + ymData.favourHeight + (ymData.favourHeight == 0?0:kReply_FavourDistance)-47*2+(ymData.messageBody.isActivite==0?0:40)+ (!ymData.messageBody.linkUrl?0:54), screenWidth - offSet_X * 2, 0)];
        
        if (i == 0) {
            backView_Y = TableHeader/2.0-10 + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30)+(ymData.messageBody.isActivite==0?0:40)+ (!ymData.messageBody.linkUrl?0:54);
        }
        
        _ilcoreText.delegate = self;
        _ilcoreText.replyIndex = i;
        _ilcoreText.isFold = NO;
        _ilcoreText.attributedData = [ymData.attributedDataReply objectAtIndex:i];
        _ilcoreText.textColor = [UIColor colorWithRed:36/255.0 green:80/255.0 blue:132/255.0 alpha:1];
        
        WFReplyBody *body = (WFReplyBody *)[ymData.replyDataSource objectAtIndex:i];
        
        NSString *matchString;
//评论回复的问题＝＝
//        if ([body.repliedUser isEqualToString:@""]) {
            matchString = [NSString stringWithFormat:@"%@:%@",body.replyUser,body.replyInfo];
            
//        }else{
////            matchString = [NSString stringWithFormat:@"%@回复%@:%@",body.replyUser,body.repliedUser,body.replyInfo];
////            
//        }
        
        [_ilcoreText setOldString:matchString andNewString:[ymData.completionReplySource objectAtIndex:i]];
        
        _ilcoreText.frame = CGRectMake(offSet_X+47,TableHeader/2.0-10 + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30) + balanceHeight + kReplyBtnDistance + ymData.favourHeight + (ymData.favourHeight == 0?0:kReply_FavourDistance)+(ymData.messageBody.isActivite==0?0:40)+ (!ymData.messageBody.linkUrl?0:54), screenWidth - offSet_X * 2-47, [_ilcoreText getTextHeight]);
        [self.contentView addSubview:_ilcoreText];
        origin_Y += [_ilcoreText getTextHeight] + 5;
        
        backView_H += _ilcoreText.frame.size.height;
        
        [_ymTextArray addObject:_ilcoreText];
    }
    
    backView_H += (ymData.replyDataSource.count - 1)*5;
    
    
    
    if (ymData.replyDataSource.count == 0) {//没回复的时候
        
        replyImageView.frame = CGRectMake(offSet_X+47, favourView.frame.origin.y-3, screenWidth - offSet_X * 2-47,ymData.favourHeight);
        _likeBtn.frame = CGRectMake(screenWidth - offSet_X - 18 + 2,TableHeader/2.0-10 + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30) + balanceHeight + kReplyBtnDistance - 24, 18, 16);
        _replyBtn.frame = CGRectMake(screenWidth - offSet_X - 23.7 -24,TableHeader/2.0-10 + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30) + balanceHeight + kReplyBtnDistance - 24, 18, 16);
        _timeLab.frame = CGRectMake(offSet_X + 47,TableHeader/2.0-10 + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30) + balanceHeight + kReplyBtnDistance - 24+(ymData.messageBody.isActivite==0?0:40)+ (!ymData.messageBody.linkUrl?0:54), 45, 14);
        _delBtn.frame = CGRectMake(offSet_X + 47+45,TableHeader/2.0-10 + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30) + balanceHeight + kReplyBtnDistance - 24+(ymData.messageBody.isActivite==0?0:40)+ (!ymData.messageBody.linkUrl?0:54), 30, 14);
        
    }else{
        
        replyImageView.frame = CGRectMake(offSet_X+47, backView_Y - 10 + balanceHeight + 5 + kReplyBtnDistance, screenWidth - offSet_X * 2-47, backView_H + 20 - 8);//微调
        
        _likeBtn.frame = CGRectMake(screenWidth - offSet_X - 18 + 2, replyImageView.frame.origin.y - 24, 18, 16);
        _replyBtn.frame = CGRectMake(screenWidth - offSet_X - 23.7 - 24, replyImageView.frame.origin.y - 24, 18, 16);
        _timeLab.frame = CGRectMake(offSet_X + 47, replyImageView.frame.origin.y - 24, 45, 14);
        _delBtn.frame = CGRectMake(offSet_X + 47+45, replyImageView.frame.origin.y - 24, 30, 14);;
    }
    
    
   
    
    
 }

#pragma mark - ilcoreTextDelegate
- (void)clickMyself:(NSString *)clickString{
    
    //延迟调用下  可去掉 下同
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:clickString message:nil delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
        
        
    });
    
    
}


- (void)longClickWFCoretext:(NSString *)clickString replyIndex:(NSInteger)index{
  
    if (index == -1) {
        UIPasteboard *pboard = [UIPasteboard generalPasteboard];
        pboard.string = clickString;
    }else{
        [_delegate longClickRichText:_stamp replyIndex:index];
    }
    
}


- (void)clickWFCoretext:(NSString *)clickString replyIndex:(NSInteger)index{
    
    if ([clickString isEqualToString:@""] && index != -1) {
       //reply
        //NSLog(@"reply");
        [_delegate clickRichText:_stamp replyIndex:index];
    }else{
        if ([clickString isEqualToString:@""]) {
            //
        }else{
            [WFHudView showMsg:clickString inView:nil];
        }
    }
    
}

#pragma mark - 点击action
- (void)tapImageView:(YMTapGestureRecongnizer *)tapGes{
    
    [_delegate showImageViewWithImageViews:tapGes.appendArray byClickWhich:tapGes.view.tag];
    
    
}
@end
