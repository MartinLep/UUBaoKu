//
//  UUannouncementDataViewController.m
//  UUBaoKu
//
//  Created by admin on 16/10/24.
//  Copyright © 2016年 loongcrown. All rights reserved.
//
//========================分享圈公告===============================
#import "UUannouncementDataViewController.h"
#import "UIView+Ex.h"
#import "UILabel+UULeftTopAlign.h"
@interface UUannouncementDataViewController ()

@property(strong,nonatomic)NSDictionary *announcementDict;

@end

@implementation UUannouncementDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self getannouncementData];
    
    self.navigationItem.title =@"分享圈公告";
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:242/255.0 alpha:1];
    
    
   
}
-(void)MakeUI{
    UIView *announcementDataView = [[UIView alloc] initWithFrame:CGRectMake(12.5, 14.5,self.view.width-25, 350)];

    announcementDataView.backgroundColor = [UIColor whiteColor];
    //产品介绍
    UILabel *TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10,announcementDataView.width-20, 50)];
    TitleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17.5];
    TitleLabel.text =[self.announcementDict valueForKey:@"title"];
    
    TitleLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
    TitleLabel.textAlignment = NSTextAlignmentLeft;
    
    
    
    TitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    TitleLabel.numberOfLines = 0;
    
    CGRect textFrame = TitleLabel.frame;
    
    TitleLabel.frame = CGRectMake(10, 10, announcementDataView.width-20, textFrame.size.height=[TitleLabel.text boundingRectWithSize:CGSizeMake(10, 200) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:TitleLabel.font,NSFontAttributeName, nil] context:nil].size.height);
    
    TitleLabel.frame = CGRectMake(10, 10, announcementDataView.width-20, 50);
    [announcementDataView addSubview:TitleLabel];
    
    
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 64, 200, 21)];
    
    timeLabel.text =[self.announcementDict valueForKey:@"createTimeFormat"];
    
    [announcementDataView addSubview:timeLabel];
        
    //产品介绍
    NSString *str = [self.announcementDict valueForKey:@"content"];
    
    UILabel *descLable=[[UILabel alloc] init];
    
    
   
    [descLable setNumberOfLines:0];
    descLable.lineBreakMode = UILineBreakModeCharacterWrap;
    descLable.text = str;
    descLable.font = [UIFont systemFontOfSize:15];
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    CGSize size = CGSizeMake(announcementDataView.width-20, MAXFLOAT);
    CGSize labelsize = [str sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeCharacterWrap];
    [descLable setFrame:CGRectMake(10, 95,announcementDataView.width-20, labelsize.height)];
    [announcementDataView addSubview:descLable];
    
    [self.view addSubview:announcementDataView];

}

//获取数据
-(void)getannouncementData{
    NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Bulletin&a=getBulletinDetail"];
    
//    NSString *str=[NSString stringWithFormat:@"%@Bulletin/getBulletinDetail",notWebsite];
    NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSDictionary *dic = @{@"bulletinId":self.bulletinId};
    
//    NSLog(@"公告详情－＝－%@",dic);
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        NSLog(@"公告详情＝＝＝%@",responseObject);
        self.announcementDict = [responseObject valueForKey:@"data"];
       
        [self MakeUI];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];
}





@end
