//
//  EvaluateViewController.m
//  PhotoSelector
//
//  Created by 洪雯 on 2017/1/12.
//  Copyright © 2017年 洪雯. All rights reserved.
//

#import "EvaluateViewController.h"

#import "BRPlaceholderTextView.h"

#import "UIImageView+WebCache.h"

#import "AFNetworking.h"

#import "UUWhoCanSeeViewController.h"
#import "SVProgressHUD.h"

#define iphone4 (CGSizeEqualToSize(CGSizeMake(320, 480), [UIScreen mainScreen].bounds.size))
#define iphone5 (CGSizeEqualToSize(CGSizeMake(320, 568), [UIScreen mainScreen].bounds.size))
#define iphone6 (CGSizeEqualToSize(CGSizeMake(375, 667), [UIScreen mainScreen].bounds.size))
#define iphone6plus (CGSizeEqualToSize(CGSizeMake(414, 736), [UIScreen mainScreen].bounds.size))
//默认最大输入字数为  kMaxTextCount  300
#define kMaxTextCount 300
#define HeightVC [UIScreen mainScreen].bounds.size.height//获取设备高度
#define WidthVC [UIScreen mainScreen].bounds.size.width//获取设备宽度

@interface EvaluateViewController ()<UIScrollViewDelegate,UITextViewDelegate>
{
    float _TimeNUMX;
    float _TimeNUMY;
    int _FontSIZE;
    float allViewHeight;
    //备注文本View高度
    float noteTextHeight;
    UITextView *_contentTV;
}

/**
 *  主视图-
 */
@property (nonatomic, strong) UIScrollView *mianScrollView;
@property (nonatomic, strong) BRPlaceholderTextView *noteTextView;
//背景x
@property (nonatomic, strong) UIView *noteTextBackgroudView;
//文字个数提示label
@property (nonatomic, strong) UILabel *textNumberLabel;
//图片
@property (nonatomic,strong) UIImageView *photoImageView;

//文字介绍
@property (nonatomic,copy) NSString *typeStr;
@property (nonatomic,copy) NSString *upPeople;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,strong) UIView * lineVCThree;
@property (nonatomic,strong) UIButton * sureBtn;
@property (nonatomic,strong) NSMutableDictionary * upDic;
@property (nonatomic,strong) NSMutableArray * photoArr;
@property (nonatomic,copy)   NSString * photoStr;
@property (nonatomic,copy)   NSString * star_level;
@property (nonatomic,copy)   NSString * modelUrl;
@property(strong,nonatomic)UIView *addressView;
@property(strong,nonatomic)NSMutableArray *photoMutableArray;
@property(strong,nonatomic)UIImageView *imageVIew;
//下拉菜单
@property(strong,nonatomic)UIButton *addBtn;
@property(strong,nonatomic)NSString *addressstr;

//谁可以看
@property(strong,nonatomic)UILabel *whocanseeLabel;
@property(strong,nonatomic)NSString *whocanseeStr;


@property(strong,nonatomic)NSArray *imgs;
@property(strong,nonatomic)NSMutableArray *goodsIdList ;

@property(assign,nonatomic)NSInteger recommendType;
//保存数据的可变数组
@property(strong,nonatomic)NSMutableArray *NewEditShareMutableArray;
@property(strong,nonatomic)NSString *contentText;

//tableview

@property(strong,nonatomic)UUWhoCanSeeViewController *whocan;

@property(assign,nonatomic)NSInteger stars;
@property(strong,nonatomic)NSString *words;
@property(strong,nonatomic)NSArray *visitRoleStr;

@property(assign,nonatomic)NSInteger selectId;



@end

@implementation EvaluateViewController
{
    UIButton *_releaseBtn;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _contentText = @"";
    self.imgs = [[NSArray alloc] init];
    self.goodsIdList = [[NSMutableArray alloc] init];
    self.NewEditShareMutableArray = [[NSMutableArray alloc] init];
    
    self.stars = 0;
    self.words = @"";
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 21)];
    
    [rightButton setTitleColor:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1] forState:UIControlStateNormal];
    
    [rightButton setTitle:@"发表" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(whocanseelist)forControlEvents:UIControlEventTouchUpInside];
    _releaseBtn = rightButton;
    
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem= rightItem;

    
    
    self.whocanseeLabel.text = @"未设置";
    
    
    self.addressstr = @"";
 
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BACKGROUNG_COLOR;
    
    self.navigationItem.title = @"写朋友圈消息";
    
    self.modelUrl = @"图片地址";
    self.typeStr = @"类型";
    self.upPeople = @"上传者";
    self.address = @"地  址 : %@";
    self.star_level = @"1";
    [self createUI];
}
//navigation  颜色
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:UURED}];
    
}
- (void)createUI{
    _mianScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WidthVC, kScreenHeight-64)];
    _mianScrollView.contentSize =CGSizeMake(kScreenWidth, kScreenHeight-64);
    _mianScrollView.bounces =YES;
    _mianScrollView.showsVerticalScrollIndicator = false;
    _mianScrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_mianScrollView];
    [_mianScrollView setDelegate:self];
    self.showInView = _mianScrollView;
    
    /** 初始化collectionView */
    [self initPickerView];
    
    [self initViews];
    
}

/**
 *  初始化视图
 */
- (void)initViews{
    UIView * lineVCOne = [[UIView alloc] initWithFrame:CGRectMake(0, 130*_TimeNUMY, WidthVC, 10*_TimeNUMY)];
    lineVCOne.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UILabel * evaluateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20*_TimeNUMX, lineVCOne.frame.origin.y+lineVCOne.frame.size.height+10*_TimeNUMY, 50*_TimeNUMX, 30*_TimeNUMY)];
    evaluateLabel.text = @"总体";
    evaluateLabel.font = [UIFont systemFontOfSize:14.0+_FontSIZE];
    
    UIView * rView = [[UIView alloc]initWithFrame:CGRectMake(80*_TimeNUMX, lineVCOne.frame.origin.y+lineVCOne.frame.size.height+5*_TimeNUMY, 150*_TimeNUMX, 40*_TimeNUMY)];
    //    rView.ratingType = INTEGER_TYPE;//整颗星
    //    rView.delegate = self;
    
    UIView * lineVCTwo = [[UIView alloc] initWithFrame:CGRectMake(0, evaluateLabel.frame.origin.y+evaluateLabel.frame.size.height+10*_TimeNUMY, WidthVC, 10*_TimeNUMY)];
    lineVCTwo.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //文本输入框
    _noteTextView = [[BRPlaceholderTextView alloc]init];
    _noteTextView.keyboardType = UIKeyboardTypeDefault;
    //文字样式
    [_noteTextView setFont:[UIFont fontWithName:@"Heiti SC" size:15.5]];
    _noteTextView.maxTextLength = kMaxTextCount;
    [_noteTextView setTextColor:[UIColor blackColor]];
    _noteTextView.delegate = self;
    _noteTextView.font = [UIFont boldSystemFontOfSize:15.5];
    _noteTextView.placeholder= @"    这一刻的想法...";
    self.noteTextView.returnKeyType = UIReturnKeyDone;
    [self.noteTextView setPlaceholderColor:[UIColor lightGrayColor]];
    [self.noteTextView setPlaceholderOpacity:1];
    _noteTextView.textContainerInset = UIEdgeInsetsMake(5, 15, 5, 15);
    
    _textNumberLabel = [[UILabel alloc]init];
    _textNumberLabel.textAlignment = NSTextAlignmentRight;
    _textNumberLabel.font = [UIFont boldSystemFontOfSize:12];
    _textNumberLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    _textNumberLabel.backgroundColor = [UIColor whiteColor];
    _textNumberLabel.text = [NSString stringWithFormat:@"0/%d    ",kMaxTextCount];
    
    self.lineVCThree = [[UIView alloc] init];
    self.lineVCThree.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
   
    
    
    self.addressView = [[UIView alloc] init];
    
    self.addressView.backgroundColor = [UIColor whiteColor];
    
    
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 16, 10.3)];
    
    [imageView setImage:[UIImage imageNamed:@"可见"]];
    
    
    
    [self.addressView addSubview:imageView];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(48, 9.5, 60, 21)];
    label.text = @"谁可以看";
    label.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    [self.addressView addSubview:label];
    
    
    UILabel *whocanseeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width-220, 9.5, 200, 20)];
    self.whocanseeLabel = whocanseeLabel;
    self.whocanseeLabel.text = @"所有好友可见";
    self.visitRoleStr = @[@"0"];
    whocanseeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    whocanseeLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
    
    whocanseeLabel.textAlignment = NSTextAlignmentRight;
    
    
    [self.addressView addSubview:whocanseeLabel];

    
    //跳转到谁可以看的按钮
    UIButton *Button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 30)];
    [Button addTarget:self action:@selector(addressList) forControlEvents:UIControlEventTouchUpInside];
    
    [self.addressView addSubview:Button];
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 1, kScreenWidth, 125)];
    contentView.backgroundColor = [UIColor whiteColor];
    [_mianScrollView addSubview:contentView];
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 100)];
    [contentView addSubview:textView];
    textView.delegate = self;
    textView.text = @"这一刻的想法...";
    textView.textColor = UUGREY;
    textView.font = [UIFont systemFontOfSize:15];
    _contentTV = textView;
//    [_mianScrollView addSubview:_noteTextBackgroudView];
//    [_mianScrollView addSubview:_noteTextView];
//    [_mianScrollView addSubview:_textNumberLabel];
   
    [_mianScrollView addSubview:self.sureBtn];
    [_mianScrollView addSubview:self.addressView];
    
    
    [_noteTextBackgroudView addSubview:self.photoImageView];

    
    [_noteTextBackgroudView addSubview:evaluateLabel];
    [_noteTextBackgroudView addSubview:rView];
    
    
    [self updateViewsFrame];
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    textView.text = _contentText;
    textView.textColor = UUBLACK;
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    _contentText = textView.text;
}
- (void)textViewEndEditing:(UITextView *)textView{
    _contentText = textView.text;
    if (_contentText.length==0) {
        textView.text= @"这一刻的想法...";
        textView.textColor = UUGREY;
    }
}
/**
 *  界面布局 frame
 */


- (void)updateViewsFrame{
    
    if (!allViewHeight) {
        allViewHeight = 0;
    }
    if (!noteTextHeight) {
        noteTextHeight = 150*_TimeNUMY;
    }
    
    _noteTextBackgroudView.frame = CGRectMake(0, 0, WidthVC, 200*_TimeNUMY);
    
    //文本编辑框
    _noteTextView.frame = CGRectMake(0, 0, WidthVC, noteTextHeight);
    
    //文字个数提示Label
    _textNumberLabel.frame = CGRectMake(0, _noteTextView.frame.origin.y + _noteTextView.frame.size.height-15*_TimeNUMY      , WidthVC-10*_TimeNUMX, 15*_TimeNUMY);
    
    self.lineVCThree.frame = CGRectMake(0*_TimeNUMX,_noteTextView.frame.origin.y+_noteTextView.frame.size.height, WidthVC, 10*_TimeNUMY);
    
    //photoPicker
    
    
   [self updatePickerViewFrameY:0];
    
    
    self.addressView.frame = CGRectMake(0,[self getPickerViewFrame].origin.y+[self getPickerViewFrame].size.height+30*_TimeNUMY+150, self.view.frame.size.width, 40);
    
    
    
    self.sureBtn.frame = CGRectMake(20*_TimeNUMX, [self getPickerViewFrame].origin.y+[self getPickerViewFrame].size.height+30*_TimeNUMY+150, WidthVC-40*_TimeNUMX, 40*_TimeNUMY);
    
    allViewHeight = self.sureBtn.frame.origin.y+self.sureBtn.frame.size.height+10*_TimeNUMY+200;
    
    _mianScrollView.contentSize = self.mianScrollView.contentSize = CGSizeMake(0,allViewHeight);
    [self updatePickerViewFrameY:150];
}

/**
 *  恢复原始界面布局
 */
-(void)resumeOriginalFrame{
    _noteTextBackgroudView.frame = CGRectMake(0, 0, WidthVC, 200*_TimeNUMY);
    //文本编辑框
    _noteTextView.frame = CGRectMake(0, 40*_TimeNUMY, WidthVC, noteTextHeight);
    
    //文字个数提示Label
    _textNumberLabel.frame = CGRectMake(0, _noteTextView.frame.origin.y + _noteTextView.frame.size.height-15*_TimeNUMY      , WidthVC-10*_TimeNUMX, 15*_TimeNUMY);
}

- (void)pickerViewFrameChanged{
    [self updateViewsFrame];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    //当前输入字数
    _textNumberLabel.text = [NSString stringWithFormat:@"%lu/%d    ",(unsigned long)_noteTextView.text.length,kMaxTextCount];
    if (_noteTextView.text.length > kMaxTextCount) {
        _textNumberLabel.textColor = [UIColor redColor];
    }else{
        _textNumberLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    }
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    [self textChanged];
    return YES;
}

//文本框每次输入文字都会调用  -> 更改文字个数提示框
- (void)textViewDidChangeSelection:(UITextView *)textView{
    //
    _textNumberLabel.text = [NSString stringWithFormat:@"%lu/%d    ",(unsigned long)_noteTextView.text.length,kMaxTextCount];
    if (_noteTextView.text.length > kMaxTextCount) {
        _textNumberLabel.textColor = [UIColor redColor];
    }
    else{
        _textNumberLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    }
    [self textChanged];
}

/**
 *  文本高度自适应
 */
-(void)textChanged{
    
    CGRect orgRect = self.noteTextView.frame;//获取原始UITextView的frame
    
    //获取尺寸
    CGSize size = [self.noteTextView sizeThatFits:CGSizeMake(self.noteTextView.frame.size.width, MAXFLOAT)];
    
    orgRect.size.height=size.height+10;//获取自适应文本内容高度
    
    
    //如果文本框没字了恢复初始尺寸
//    if (orgRect.size.height > 150) {
//        noteTextHeight = orgRect.size.height;
//    }else{
        noteTextHeight = 150;
//    }
    
    [self updateViewsFrame];
}




#pragma mark - UIScrollViewDelegate
//用户向上偏移到顶端取消输入,增强用户体验
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 0) {
        [self.view endEditing:YES];
    }
}


#pragma mark 点击出大图方法
- (void)ClickImage:(UIButton *)sender{
    
    NSLog(@"调用的这个方法＝－＝－");
    
}

#pragma mark 确定评价的方法
- (void)ClickSureBtn:(UIButton *)sender{
   
    
    self.photoArr = [[NSMutableArray alloc] initWithArray:[self getBigImageArray]];
    
    if (self.photoArr.count >6){
        NSLog(@"最多上传6张照片!");
        
    }else if (self.photoArr.count == 0){
        NSLog(@"请上传照片!");
        
    }else{
        
        /** 上传的接口方法 */
        if (![self.addressstr isEqualToString:@""]) {
            
            
//             [self sureAction];
            
            
            
            
        }
    }
}

#pragma mark 返回不同型号的机器的倍数值
- (float)BackTimeNUMX {
    float numX = 0.0;
    if (iphone4) {
        numX = 320 / 375.0;
        return numX;
    }
    if (iphone5) {
        numX = 320 / 375.0;
        return numX;
    }
    if (iphone6) {
        return 1.0;
    }
    if (iphone6plus) {
        numX = 414 / 375.0;
        return numX;
    }else{
        numX = 414 / 375.0;
        return numX;
    }
    
}
- (float)BackTimeNUMY {
    float numY = 0.0;
    if (iphone4) {
        numY = 480 / 667.0;
        _FontSIZE = -2;
        return numY;
    }
    if (iphone5) {
        numY = 568 / 667.0;
        _FontSIZE = -2;
        return numY;
    }
    if (iphone6) {
        _FontSIZE = 0;
        return 1.0;
    }
    if (iphone6plus) {
        numY = 736 / 667.0;
        _FontSIZE = 2;
        return numY;
    }
    return numY;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)upload{
   
    [self.view endEditing:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *forString = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", forString];
    NSLog(@"图片名＝＝%@",fileName);
       
    
    NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=User&a=uploadImg"];
    
    NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
//    NSDictionary *dic = @{@"id":gerenuserid,@"type":@"rank"};
//    
//    NSLog(@"自己的userid－－－－%@",gerenuserid);

    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i=0; i<self.arrSelected.count; i++) {
           
            UIImage *img = [self getBigIamgeWithALAsset:self.arrSelected[i]];
            NSData *imgData=UIImageJPEGRepresentation(img, 0.8);
            NSString *fileName = [NSString stringWithFormat:@"%@_%d.jpg", forString,i];
            [formData appendPartWithFileData:imgData name:@"file[]" fileName:fileName mimeType:@"image/jpeg"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.imageVIew removeFromSuperview];
        self.photoMutableArray = [responseObject valueForKey:@"data"];
        [self releaseMessage];
    
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.imageVIew removeFromSuperview];
        _releaseBtn.userInteractionEnabled = YES;
          [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"上传失败%@",error);
        
        //        [self uploadDataWithStatus:NO];
    }];
}

//跳转到谁可以看的界面的方法

-(void)addressList{    
    UUWhoCanSeeViewController *whoCan = [[UUWhoCanSeeViewController alloc] init];
    whoCan.setWhoCanSee = ^(NSArray *array, NSInteger selectedId) {
        self.selectId = selectedId;
        self.visitRoleStr = array;
        if (selectedId == 0) {
            self.whocanseeLabel.text = @"所有好友可见";
        }else if (selectedId == 1){
            self.whocanseeLabel.text = @"仅自己可见";
        }else{
            self.whocanseeLabel.text = @"部分好友可见";
        }
    };
    whoCan.selectedId = self.selectId;
    whoCan.WhoCanSeeIdArray = self.visitRoleStr;
    [self.navigationController pushViewController:whoCan animated:YES];
}

//自动消失的提示框
- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}
- (void)showAlert:(NSString *) _message{//时间
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"提示", @"Location", nil) message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:1.5f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
}
-(void)whocanseelist{
    [self.view endEditing:YES];
    _releaseBtn.userInteractionEnabled = NO;
    NSLog(@"发布文字");
    if (_contentText.length == 0) {
        _releaseBtn.userInteractionEnabled = YES;
        [self showAlert:@"发布内容不能为空"];
    }else if (self.imageArray.count == 0){
        [self showAlert:@"请至少上传一张图片"];
        _releaseBtn.userInteractionEnabled = YES;
    }else{
        [self upload];
        
    }
}


- (void)releaseMessage{
    NSMutableArray *PicArray = [[NSMutableArray alloc] init];
    
    for (int i=0; i<self.photoMutableArray.count; i++) {
        
        [PicArray addObject:[self.photoMutableArray[i] valueForKey:@"savename"]];
    }
    NSLog(@"重复设置卡片信息时候数组%@",PicArray);
    
    NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Moment&a=addMoment"];
    NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSData *data=[NSJSONSerialization dataWithJSONObject:PicArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    NSData *data1=[NSJSONSerialization dataWithJSONObject:self.visitRoleStr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr1=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    
    NSDictionary *dic =
    @{@"type":@"3",@"visitRole":jsonStr1,@"content":_contentText,@"imgs":jsonStr,@"userId":[NSString stringWithFormat:@"%@",UserId]};
    
    NSLog(@"=-=-=-%@",dic);
    [NetworkTools postReqeustWithParams:dic UrlString:urlStr successBlock:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"图文消息获取到的值是==%@",responseObject);
        if ([[responseObject valueForKey:@"code"] intValue]==200) {
            [[NSNotificationCenter defaultCenter]postNotificationName:RECOMMEND_RELEASE_SUCCESSED object:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            _releaseBtn.userInteractionEnabled = YES;
        }

    } failureBlock:^(NSError *error) {
        _releaseBtn.userInteractionEnabled = YES;
    }];

}

@end
