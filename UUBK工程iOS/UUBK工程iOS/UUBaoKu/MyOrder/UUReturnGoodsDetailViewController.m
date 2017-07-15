//
//  UUReturnGoodsDetailViewController.m
//  UUBaoKu
//
//  Created by dev on 17/3/16.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUReturnGoodsDetailViewController.h"
#import "UUGoodsOrderTableViewCell.h"
#import "UUGoodsModel.h"
#import "UUOrderListModel.h"
#import "UIImageView+WebCache.h"
#import "UUReturnDetailModel.h"
#import "UURefundReasonModel.h"
#import "UUShopProductDetailsViewController.h"
#import "UUEarnKuBiViewController.h"
#import "UUShareView.h"

@interface UUReturnGoodsDetailViewController ()<
UITableViewDelegate,
UITableViewDataSource,
UIPickerViewDelegate,
UIPickerViewDataSource,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UITextViewDelegate,
UITextFieldDelegate>
@property(strong,nonatomic)UIImageView *hearderIV;
@property(strong,nonatomic)NSTimer *timer;
@property(strong,nonatomic)UIImageView *firstCircle;
@property(strong,nonatomic)UIImageView *secondCircle;
@property(strong,nonatomic)UIImageView *thirdCircle;
@property(strong,nonatomic)UIImageView *forthCircle;
@property(strong,nonatomic)UILabel *firstLab;
@property(strong,nonatomic)UILabel *secondLab;
@property(strong,nonatomic)UILabel *thirdLab;
@property(strong,nonatomic)UILabel *forthLab;
@property(strong,nonatomic)UILabel *firstLineLab;
@property(strong,nonatomic)UILabel *secondLineLab;
@property(strong,nonatomic)UILabel *thirdLineLab;
@property(strong,nonatomic)UIView *backView;
@property(strong,nonatomic)UIView *nextBackView;
@property(strong,nonatomic)UIButton *nextBtn;
@property(strong,nonatomic)UIButton *saveBtn;
@property (nonatomic, strong) NSArray *titles;
@property(nonatomic,strong)UIView *cover;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UUReturnDetailModel *returnDetailModel;
@property(strong,nonatomic)UIPickerView *reasonPicker;
@property(strong,nonatomic)NSString *reasonString;
@property(strong,nonatomic)UILabel *reasonLab;
@property(strong,nonatomic)NSString *reasonID;
@property(strong,nonatomic)NSString *RefundType;
@property(strong,nonatomic)NSMutableArray *reasonDataSource;
@property(strong,nonatomic)UURefundReasonModel *reasonModel;
@property(strong,nonatomic)NSMutableArray *imageArray;
@property(strong,nonatomic)NSString *ProofImageUrl;
@property(strong,nonatomic)NSString *Explanation;
@property(assign,nonatomic)NSInteger SKUID;
@property(assign,nonatomic)float ShipFee;
@property(assign,nonatomic)float GoodsAmount;
@property(assign,nonatomic)NSInteger isCancel;
@property(strong,nonatomic)UITextField *expressNameTF;
@property(strong,nonatomic)UITextField *expressNumTF;
@property(assign,nonatomic)CGRect keyboardFrame;
@property(strong,nonatomic)UIView *shareView;

//热门推荐数组
@property(strong,nonatomic)NSArray *guessShopArray;
@end

@implementation UUReturnGoodsDetailViewController
static int imgNum = 1;

- (UIView *)shareView{
    if (!_shareView) {
        _shareView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _shareView.backgroundColor = [UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:0.7];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareViewHiden)];
        [_shareView addGestureRecognizer:tap];
        UUShareView *contentView = [[UUShareView alloc]initWithFrame:CGRectMake(0, self.view.height-320, kScreenWidth, 320)];
        [_shareView addSubview:contentView];
    }
    return _shareView;
}

- (void)shareViewHiden{
    [_shareView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"退换货/退款";
    _reasonDataSource = [NSMutableArray new];
    _imageArray = [NSMutableArray new];
    [self getReasonData];
    if (self.pushType == 3) {
        [self getReturnDetailData];
        [self getUUMytreasureData];
    }
    if (self.pushType == 1) {
        if (self.index == 1) {
            [self initUIWithType:3];

        }
        if (self.index == 2) {
            [self initUIWithType:4];
        }
        
    }
    if (self.pushType == 2||self.pushType == -1) {
        [self getReturnDetailData];
    }
    //监听键盘出现和消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

//键盘出现
- (void)keyboardWillShow:(NSNotification *)notification{
    _keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect frame = self.tableView.frame;
    frame.origin.y = 0;
    self.tableView.frame = frame;
    
}
//键盘消失
- (void)keyboardWillHide:(NSNotification *)notification{
    _keyboardFrame.origin.y = 0;
    CGRect frame = self.tableView.frame;
    frame.origin.y = 112;
    self.tableView.frame = frame;
}

- (void)initUIWithType:(NSInteger )type{
    self.hearderIV = [[UIImageView alloc]init];
    [self.view addSubview:self.hearderIV];
    [self.hearderIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).mas_offset(2.5);
        make.width.mas_equalTo(self.view.frame.size.width);
        make.height.mas_equalTo(107.5);
    }];
    self.hearderIV.backgroundColor = [UIColor whiteColor];
    float labelWidth = 0;
    float circleSpace = 0;
    if (type == 3) {
        labelWidth = (self.view.frame.size.width - 15*4)/3.0;
        circleSpace = (self.view.frame.size.width - 50*2 - 40*3)/2.0;
    }
    if (type == 4) {
        labelWidth = (self.view.frame.size.width - 15*5)/4.0;
        circleSpace = (self.view.frame.size.width - 30*2 - 40*4)/3.0;
    }

    for (int i = 0; i < type; i++) {
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(15+(15+labelWidth)*i, 67.5, labelWidth, 18.5)];
        [self.hearderIV addSubview:titleLab];
        titleLab.font = [UIFont fontWithName:TITLEFONTNAME size:13];
        titleLab.textAlignment = NSTextAlignmentCenter;
        UIImageView *circleIV;
        if (type == 3) {
            circleIV = [[UIImageView alloc]initWithFrame:CGRectMake(50+(circleSpace+40)*i, 22, 40, 40)];
        }
        if (type == 4) {
            circleIV = [[UIImageView alloc]initWithFrame:CGRectMake(32+(circleSpace+40)*i, 22, 40, 40)];
        }
        if (i == 0) {
            circleIV.backgroundColor = UURED;
            _firstCircle = circleIV;
            titleLab.textColor = UURED;
            titleLab.text = @"申请退款";
            _firstLab = titleLab;
        }else if (i == 1) {
            circleIV.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
            _secondCircle = circleIV;
            titleLab.textColor = [UIColor colorWithRed:146/255.0 green:146/255.0 blue:146/255.0 alpha:1];
            titleLab.text = @"处理申请";
            _secondLab = titleLab;
        }else if (i == 2){
            if (type == 3) {
                circleIV.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
                _thirdCircle = circleIV;
                titleLab.textColor = [UIColor colorWithRed:146/255.0 green:146/255.0 blue:146/255.0 alpha:1];
                titleLab.text = @"退款完成";
                _thirdLab = titleLab;

            }
            if (type == 4) {
                circleIV.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
                _thirdCircle = circleIV;
                titleLab.textColor = [UIColor colorWithRed:146/255.0 green:146/255.0 blue:146/255.0 alpha:1];
                titleLab.text = @"退货给商家";
                _thirdLab = titleLab;

            }
        }else{
            circleIV.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
            _forthCircle = circleIV;
            titleLab.textColor = [UIColor colorWithRed:146/255.0 green:146/255.0 blue:146/255.0 alpha:1];
            titleLab.text = @"退款完成";
            _forthLab = titleLab;

        }
        circleIV.layer.cornerRadius = 20;
        circleIV.clipsToBounds = YES;
        [self.hearderIV addSubview:circleIV];
        UILabel *numberLab = [[UILabel alloc]initWithFrame:CGRectMake(14.5, 7.5, 11, 25)];
        [circleIV addSubview:numberLab];
        numberLab.text = [NSString stringWithFormat:@"%i",i+1];
        numberLab.textColor = [UIColor whiteColor];
        numberLab.font = [UIFont fontWithName:@"DINAlternate-Bold" size:21.5];
        if (i<type-1) {
            
            UILabel *lineLab;
            if (type == 3) {
                lineLab = [[UILabel alloc]initWithFrame:CGRectMake(94+(circleSpace+40)*i, 40, circleSpace- 8, 2.5)];
            }
            if (type == 4) {
                lineLab = [[UILabel alloc]initWithFrame:CGRectMake(76+(circleSpace+40)*i, 40, circleSpace- 8, 2.5)];
            }
            [self.hearderIV addSubview:lineLab];
            lineLab.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
            if (i == 0) {
                _firstLineLab = lineLab;
            }
            if (i == 1) {
                _secondLineLab = lineLab;
            }
            if (i == 2) {
                _thirdLineLab = lineLab;
            }
        }
    }
    [self makeUI];
    
}


- (void)prepareData{
    
}
- (void)makeUI{
    if (self.step - self.index == 2) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 112.5, self.view.frame.size.width, self.view.frame.size.height - 112.5-64)];
    }else{
         _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 112.5, self.view.frame.size.width, self.view.frame.size.height - 112.5-64)];
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.index == 1) {
        if (self.step == 3) {
            return 3;
        }else{
            return 2;
        }
    }else{
        if (self.step == 4) {
            return 3;
        }else{
            return 2;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.index == 1) {
        if (self.step == 2||self.step == -1) {
            if (section == 0) {
                return 1;
            }else{
                return 5;
            }
        }else if(self.step == 3){
            if (section == 0) {
                return 1;
            }else if (section == 1) {
                return 5;
            }else{
                return 2;
            }
            
        }else{
            return 5;
        }

    }else{
        if (self.step == 2||self.step == -1) {
            if (section == 0) {
                return 1;
            }else{
                return 5;
            }

        }else if (self.step == 3){
            return 5;
        }else if (self.step == 4){
            if (section == 0) {
                return 1;
            }else if (section == 1){
                return 5;
            }else{
                return 2;
            }
        }else{
            return 5;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat imgWidth = (self.view.width - 13*2 - 20*2)/3.0;
    if (self.index == 1) {
        if (self.step == 1) {
            CGFloat imgWidth = (self.view.width - 13*2 - 20*2)/3.0;
            if (indexPath.section == 0) {
                if (indexPath.row == 3) {
                    return 140;
                }else if (indexPath.row == 4){
                    return 180 +(10+imgWidth)*(_imageArray.count)/3;
                }else{
                    return 50;
                }
            }else{
                if (indexPath.row == 0) {
                    return 125;
                }else{
                    return 28;
                }
            }
            
        }else if (self.step == 2||self.step == -1){
            if (indexPath.section == 0) {
                return 60+60;
            }else{
                if (indexPath.row == 0) {
                    return 125;
                }else{
                    return 28;
                }
            }
        }else{
            if (indexPath.section == 0) {
                return 260;
            }else if (indexPath.section == 1){
                if (indexPath.row == 0) {
                    return 125;
                }else{
                    return 28;
                }
            }else{
                if (indexPath.row == 0) {
                    return 41.5;
                }else{
                    return 630+50*3;
                }
            }
        }

    }else{
        if (self.step == 1) {
            
            if (indexPath.section == 0) {
                if (indexPath.row == 3) {
                    return 140;
                }else if (indexPath.row == 4){
                    return 180 +(10+imgWidth)*(_imageArray.count)/3;
                }else{
                    return 50;
                }
            }else{
                if (indexPath.row == 0) {
                    return 125;
                }else{
                    return 28;
                }
            }
            
        }else if (self.step == 2){
            if (indexPath.section == 0) {
                return 60+60;
            }else{
                if (indexPath.row == 0) {
                    return 125;
                }else{
                    return 28;
                }
            }
        }else if (self.step == 3){
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    return 204;
                }else if (indexPath.row == 1||indexPath.row == 2){
                    return 50;
                }else if (indexPath.row == 3){
                    return 140;
                }else{
                    return 180 +(10+imgWidth)*(_imageArray.count)/3;
                }
            }else{
                return 242.5;
            }
        }else if (self.step == -1){
            if (indexPath.section == 0) {
                return 60;
            }else{
                if (indexPath.row == 0) {
                    return 125;
                }else{
                    return 28;
                }
            }

        }else {
            if (indexPath.section == 0) {
                return 260;
            }else if (indexPath.section == 1){
                if (indexPath.row == 0) {
                    return 125;
                }else{
                    return 28;
                }
            }else{
                if (indexPath.row == 0) {
                    return 41.5;
                }else{
                    return 630+50*3;
                }

            }
        }

    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    [self initHeaderStatus];
    if (self.index == 1) {//退款
        if (self.step == 1) {//第一步
            if (_isCancel == 0) {
                
            
                NSMutableArray *goodsSource = [NSMutableArray new];
                for (NSDictionary *dict in self.orderListModel.OrderGoods) {
                    UUGoodsModel *model =  [[UUGoodsModel alloc]initWithDictionary:dict];
                    [goodsSource addObject:model];
                }
                UUGoodsModel *goodsModel = goodsSource[self.modelRow-1];
                _SKUID = [goodsModel.SKUID integerValue];
                _OrderNO = self.orderListModel.OrderNO;
                if (indexPath.section == 0) {
                    if (indexPath.row == 0) {
                        UITableViewCell *cell = [[UITableViewCell alloc]init];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        UILabel *leftLab = [[UILabel alloc]init];
                        [cell addSubview:leftLab];
                        [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(cell.mas_left);
                            make.height.mas_equalTo(21);
                            make.top.mas_equalTo(cell.mas_top).mas_offset(14.5);
                            make.width.mas_equalTo(self.view.frame.size.width/2.0);
                        }];
                        leftLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
                        leftLab.textAlignment = NSTextAlignmentCenter;
                        leftLab.text = @"我要退货";
                        UILabel *leftLineLab = [[UILabel alloc]init];
                        [cell addSubview:leftLineLab];
                        [leftLineLab mas_makeConstraints:^(MASConstraintMaker *make) {
                            
                            make.left.mas_equalTo(cell.mas_left);
                            make.height.mas_equalTo(2.5);
                            make.top.mas_equalTo(leftLab.mas_top).mas_offset(15.5);
                            make.width.mas_equalTo(self.view.frame.size.width/2.0);
                        }];
                        leftLineLab.backgroundColor = UURED;
                        UILabel *rightLab = [[UILabel alloc]init];
                        [cell addSubview:rightLab];
                        [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.right.mas_equalTo(cell.mas_right);
                            make.height.mas_equalTo(21);
                            make.top.mas_equalTo(cell.mas_top).mas_offset(14.5);
                            make.width.mas_equalTo(self.view.frame.size.width/2.0);
                        }];
                        rightLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
                        rightLab.textAlignment = NSTextAlignmentCenter;
                        rightLab.text = @"我要退款（无需退货）";
                        UILabel *rightLineLab = [[UILabel alloc]init];
                        [cell addSubview:rightLineLab];
                        [rightLineLab mas_makeConstraints:^(MASConstraintMaker *make) {
                            
                            make.right.mas_equalTo(cell.mas_right);
                            make.height.mas_equalTo(2.5);
                            make.bottom.mas_equalTo(cell.mas_bottom);
                            make.width.mas_equalTo(self.view.frame.size.width/2.0);
                        }];
                        rightLineLab.backgroundColor = UURED;
                        if (self.index == 1) {
                            leftLineLab.hidden = YES;
                            leftLab.textColor = UUGREY;
                            rightLab.textColor = UURED;
                            _RefundType = @"0";
                        }
                        if (self.index == 2) {
                            rightLineLab.hidden = YES;
                            rightLab.textColor = UUGREY;
                            leftLab.textColor = UURED;
                            _RefundType = @"1";
                        }
                        
                        
                        return cell;
                    }else if (indexPath.row == 1){
                        UITableViewCell *cell = [[UITableViewCell alloc]init];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        UILabel *starLab = [[UILabel alloc]init];
                        [cell addSubview:starLab];
                        [starLab mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(cell.mas_left).mas_offset(9);
                            make.height.mas_equalTo(10);
                            make.top.mas_equalTo(cell.mas_top).mas_offset(22.5);
                            make.width.mas_equalTo(10);
                        }];
                        starLab.text = @"*";
                        starLab.textColor = UURED;
                        starLab.font = [UIFont systemFontOfSize:15];
                        UILabel *leftLab = [[UILabel alloc]init];
                        [cell addSubview:leftLab];
                        [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(cell.mas_left).mas_offset(22);
                            make.height.mas_equalTo(21);
                            make.top.mas_equalTo(cell.mas_top).mas_offset(14.5);
                            make.width.mas_equalTo(80);
                        }];
                        leftLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
                        leftLab.textAlignment = NSTextAlignmentLeft;
                        leftLab.textColor = UUBLACK;
                        leftLab.text = @"退款原因";
                        UILabel *rightLab = [[UILabel alloc]init];
                        [cell addSubview:rightLab];
                        [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.right.mas_equalTo(cell.mas_right).mas_offset(-22.5);
                            make.height.mas_equalTo(21);
                            make.top.mas_equalTo(cell.mas_top).mas_offset(14.5);
                            make.right.mas_equalTo(leftLab.mas_right).mas_offset(20);
                        }];
                        rightLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
                        rightLab.textAlignment = NSTextAlignmentRight;
                        rightLab.textColor = UUBLACK;
                        rightLab.userInteractionEnabled = YES;
                        //                    UURefundReasonModel *model = _reasonDataSource[0];
                        rightLab.text = _reasonString.length>0?_reasonString:@"请选择退款原因";
                        _reasonLab = rightLab;

                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectReturnReason)];
                        [rightLab addGestureRecognizer:tap];
                        return cell;
                    }else if (indexPath.row == 2){
                        UITableViewCell *cell = [[UITableViewCell alloc]init];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        UILabel *starLab = [[UILabel alloc]init];
                        [cell addSubview:starLab];
                        [starLab mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(cell.mas_left).mas_offset(9);
                            make.height.mas_equalTo(10);
                            make.top.mas_equalTo(cell.mas_top).mas_offset(22.5);
                            make.width.mas_equalTo(10);
                        }];
                        starLab.text = @"*";
                        starLab.textColor = UURED;
                        starLab.font = [UIFont systemFontOfSize:15];
                        UILabel *leftLab = [[UILabel alloc]init];
                        [cell addSubview:leftLab];
                        [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(cell.mas_left).mas_offset(22);
                            make.height.mas_equalTo(21);
                            make.top.mas_equalTo(cell.mas_top).mas_offset(14.5);
                            make.width.mas_equalTo(80);
                        }];
                        leftLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
                        leftLab.textAlignment = NSTextAlignmentLeft;
                        leftLab.textColor = UUBLACK;
                        leftLab.text = @"退款金额";
                        
                        UILabel *rightLab = [[UILabel alloc]init];
                        [cell addSubview:rightLab];
                        [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.right.mas_equalTo(cell.mas_right).mas_offset(-22.5);
                            make.height.mas_equalTo(21);
                            make.top.mas_equalTo(cell.mas_top).mas_offset(14.5);
                            make.right.mas_equalTo(leftLab.mas_right).mas_offset(20);
                        }];
                        rightLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
                        rightLab.textAlignment = NSTextAlignmentRight;
                        rightLab.textColor = UUBLACK;
                        rightLab.text = [NSString stringWithFormat:@"%.2f元",[goodsModel.StrickePrice floatValue]*[goodsModel.GoodsNum integerValue]+self.orderListModel.ShippingFee];
                        _GoodsAmount = [goodsModel.StrickePrice floatValue]*[goodsModel.GoodsNum integerValue];
                        return cell;
                    }else if (indexPath.row == 3){
                        UITableViewCell *cell = [[UITableViewCell alloc]init];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                        UILabel *starLab = [[UILabel alloc]init];
//                        [cell addSubview:starLab];
//                        [starLab mas_makeConstraints:^(MASConstraintMaker *make) {
//                            make.left.mas_equalTo(cell.mas_left).mas_offset(9);
//                            make.height.mas_equalTo(10);
//                            make.top.mas_equalTo(cell.mas_top).mas_offset(22.5);
//                            make.width.mas_equalTo(10);
//                        }];
//                        starLab.text = @"*";
//                        starLab.textColor = UURED;
//                        starLab.font = [UIFont systemFontOfSize:15];
                        UILabel *leftLab = [[UILabel alloc]init];
                        [cell addSubview:leftLab];
                        [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(cell.mas_left).mas_offset(22);
                            make.height.mas_equalTo(21);
                            make.top.mas_equalTo(cell.mas_top).mas_offset(14.5);
                            make.width.mas_equalTo(80);
                        }];
                        leftLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
                        leftLab.textAlignment = NSTextAlignmentLeft;
                        leftLab.textColor = UUBLACK;
                        leftLab.text = @"退款说明";
                        
                        UITextView *returnReason = [[UITextView alloc]init];
                        [cell addSubview:returnReason];
                        [returnReason mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(cell.mas_left).mas_offset(22);
                            make.top.mas_equalTo(leftLab.mas_bottom).mas_offset(11.5);
                            make.width.mas_equalTo(self.view.frame.size.width - 22*2);
                            make.bottom.mas_equalTo(cell.mas_bottom).mas_offset(-5);
                        }];
                        returnReason.text = _Explanation.length>0?_Explanation:@"请输入退款说明";
                        returnReason.delegate = self;
                        returnReason.textColor = UUGREY;
                        return cell;
                    }else{
                        UITableViewCell *cell = [[UITableViewCell alloc]init];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        UILabel *leftLab = [[UILabel alloc]init];
                        [cell addSubview:leftLab];
                        [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(cell.mas_left).mas_offset(22);
                            make.height.mas_equalTo(21);
                            make.top.mas_equalTo(cell.mas_top).mas_offset(14.5);
                            make.width.mas_equalTo(80);
                        }];
                        leftLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
                        leftLab.textAlignment = NSTextAlignmentLeft;
                        leftLab.textColor = UUBLACK;
                        leftLab.text = @"上传凭证";
                        
                        CGFloat imgWidth = (self.view.width - 13*2 - 20*2)/3.0;
                        for (int i = 0; i < _imageArray.count+1; i++) {
                            UIImageView *certificateIV1 = [[UIImageView alloc]initWithFrame:CGRectMake(13 +(20+imgWidth)*(i%3), 45.5 + (10+imgWidth)*(i/3), imgWidth, imgWidth)];
                            [cell addSubview:certificateIV1];
                            if (i <_imageArray.count) {
                                certificateIV1.image = _imageArray[i];
                            }else{
                                certificateIV1.image = [UIImage imageNamed:@"photoplus"];
                                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(upLoadCertification)];
                                certificateIV1.userInteractionEnabled = YES;
                                [certificateIV1 addGestureRecognizer:tap];
                            }
                            
                        }
                        return cell;
                    }
                    
                }else{
                    if (indexPath.row == 0) {
                        UUGoodsOrderTableViewCell *cell = [UUGoodsOrderTableViewCell cellWithTableView:self.tableView];
                        
                        UIImageView *goodImg = [[UIImageView alloc]init];
                        [cell addSubview:goodImg];
                        [goodImg mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(cell.mas_left).mas_offset(12.5);
                            make.top.mas_equalTo(cell.mas_top).mas_offset(3.5);
                            make.height.and.width.mas_equalTo(100);
                        }];
                        [goodImg sd_setImageWithURL:[NSURL URLWithString:goodsModel.ImgUrl]];
                        cell.goodsNameLab.text = goodsModel.GoodsName;
                        cell.attrNameLab.text = goodsModel.GoodsAttrName;
                        cell.rightBtn.hidden = YES;
                        cell.goodsNumLab.text = [NSString stringWithFormat:@"x%@",goodsModel.GoodsNum];
                        cell.priceLab1.text = [NSString stringWithFormat:@""];
                        if (_OrderType == 0) {
                            cell.priceLab2.text = [NSString stringWithFormat:@"会员价：￥%@",goodsModel.StrickePrice];
                            cell.priceLab4.text = [NSString stringWithFormat:@"￥%@",goodsModel.OriginalPrice];
                        }
                        if (_OrderType == 1) {
                            cell.priceLab2.text = [NSString stringWithFormat:@"采购价：￥%@",goodsModel.StrickePrice];
                            cell.priceLab4.text = [NSString stringWithFormat:@"￥%@",goodsModel.MarketPrice];
                        }
                        if (_OrderType == 2 ||_OrderType == 3) {
                            cell.priceLab2.text = [NSString stringWithFormat:@"活动价：￥%@",goodsModel.StrickePrice];
                            cell.priceLab4.text = [NSString stringWithFormat:@"￥%@",goodsModel.OriginalPrice];
                        }
                        if (_OrderType == 4) {
                            cell.priceLab2.text = [NSString stringWithFormat:@"团购价：￥%@",goodsModel.StrickePrice];
                            cell.priceLab4.text = [NSString stringWithFormat:@"￥%@",goodsModel.OriginalPrice];
                        }
                        
                        return cell;
                    }else{
                        UITableViewCell *cell = [[UITableViewCell alloc]init];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        UILabel *titleLab = [[UILabel alloc]init];
                        [cell addSubview:titleLab];
                        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.mas_equalTo(cell.mas_top).mas_offset(8.5);
                            make.left.mas_equalTo(cell.mas_left).mas_offset(12.5);
                            make.width.mas_equalTo(65);
                            make.height.mas_equalTo(13.5);
                        }];
                        titleLab.font = [UIFont fontWithName:TITLEFONTNAME size:13];
                        titleLab.textColor = [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1];
                        NSArray *titleArr = @[@"订单号",@"快递运费",@"总计",@"成交时间"];
                        titleLab.text = titleArr[indexPath.row-1];
                        UILabel *rightLab = [[UILabel alloc]init];
                        [cell addSubview:rightLab];
                        [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.mas_equalTo(cell.mas_top).mas_offset(7);
                            make.left.mas_equalTo(titleLab.mas_right).mas_offset(5);
                            make.right.mas_equalTo(cell.mas_right).mas_offset(-13.5);
                            make.height.mas_equalTo(13.5);
                        }];
                        rightLab.font = [UIFont fontWithName:TITLEFONTNAME size:13];
                        rightLab.textColor = UUBLACK;
                        rightLab.textAlignment = NSTextAlignmentRight;
                        if (indexPath.row == 1) {
                            rightLab.text = self.orderListModel.OrderNO;
                        }else if (indexPath.row == 2){
                            rightLab.text = [NSString stringWithFormat:@"%.0f元",self.orderListModel.ShippingFee];
                            _ShipFee = self.orderListModel.ShippingFee;
                        }else if (indexPath.row == 3){
                            rightLab.text = [NSString stringWithFormat:@"%.2f元",[goodsModel.StrickePrice floatValue]*[goodsModel.GoodsNum integerValue]+self.orderListModel.ShippingFee];
                        }else{
                            rightLab.text = [[self.orderListModel.PayTime substringWithRange:NSMakeRange(0, 16)] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                        }
                        
                        
                        return cell;
                    }
                }
            }else{
                
                _SKUID = _returnDetailModel.Skuid;
                _OrderNO = _returnDetailModel.OrderNO;
                if (indexPath.section == 0) {
                    if (indexPath.row == 0) {
                        UITableViewCell *cell = [[UITableViewCell alloc]init];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        UILabel *leftLab = [[UILabel alloc]init];
                        [cell addSubview:leftLab];
                        [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(cell.mas_left);
                            make.height.mas_equalTo(21);
                            make.top.mas_equalTo(cell.mas_top).mas_offset(14.5);
                            make.width.mas_equalTo(self.view.frame.size.width/2.0);
                        }];
                        leftLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
                        leftLab.textAlignment = NSTextAlignmentCenter;
                        leftLab.text = @"我要退货";
                        UILabel *leftLineLab = [[UILabel alloc]init];
                        [cell addSubview:leftLineLab];
                        [leftLineLab mas_makeConstraints:^(MASConstraintMaker *make) {
                            
                            make.left.mas_equalTo(cell.mas_left);
                            make.height.mas_equalTo(2.5);
                            make.top.mas_equalTo(leftLab.mas_top).mas_offset(15.5);
                            make.width.mas_equalTo(self.view.frame.size.width/2.0);
                        }];
                        leftLineLab.backgroundColor = UURED;
                        UILabel *rightLab = [[UILabel alloc]init];
                        [cell addSubview:rightLab];
                        [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.right.mas_equalTo(cell.mas_right);
                            make.height.mas_equalTo(21);
                            make.top.mas_equalTo(cell.mas_top).mas_offset(14.5);
                            make.width.mas_equalTo(self.view.frame.size.width/2.0);
                        }];
                        rightLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
                        rightLab.textAlignment = NSTextAlignmentCenter;
                        rightLab.text = @"我要退款（无需退货）";
                        UILabel *rightLineLab = [[UILabel alloc]init];
                        [cell addSubview:rightLineLab];
                        [rightLineLab mas_makeConstraints:^(MASConstraintMaker *make) {
                            
                            make.right.mas_equalTo(cell.mas_right);
                            make.height.mas_equalTo(2.5);
                            make.bottom.mas_equalTo(cell.mas_bottom);
                            make.width.mas_equalTo(self.view.frame.size.width/2.0);
                        }];
                        rightLineLab.backgroundColor = UURED;
                        if (self.index == 1) {
                            leftLineLab.hidden = YES;
                            leftLab.textColor = UUGREY;
                            rightLab.textColor = UURED;
                            _RefundType = @"0";
                        }
                        if (self.index == 2) {
                            rightLineLab.hidden = YES;
                            rightLab.textColor = UUGREY;
                            leftLab.textColor = UURED;
                            _RefundType = @"1";
                        }
                        
                        
                        return cell;
                    }else if (indexPath.row == 1){
                        UITableViewCell *cell = [[UITableViewCell alloc]init];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        UILabel *starLab = [[UILabel alloc]init];
                        [cell addSubview:starLab];
                        [starLab mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(cell.mas_left).mas_offset(9);
                            make.height.mas_equalTo(10);
                            make.top.mas_equalTo(cell.mas_top).mas_offset(22.5);
                            make.width.mas_equalTo(10);
                        }];
                        starLab.text = @"*";
                        starLab.textColor = UURED;
                        starLab.font = [UIFont systemFontOfSize:15];
                        UILabel *leftLab = [[UILabel alloc]init];
                        [cell addSubview:leftLab];
                        [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(cell.mas_left).mas_offset(22);
                            make.height.mas_equalTo(21);
                            make.top.mas_equalTo(cell.mas_top).mas_offset(14.5);
                            make.width.mas_equalTo(80);
                        }];
                        leftLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
                        leftLab.textAlignment = NSTextAlignmentLeft;
                        leftLab.textColor = UUBLACK;
                        leftLab.text = @"退款原因";
                        UILabel *rightLab = [[UILabel alloc]init];
                        [cell addSubview:rightLab];
                        [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.right.mas_equalTo(cell.mas_right).mas_offset(-22.5);
                            make.height.mas_equalTo(21);
                            make.top.mas_equalTo(cell.mas_top).mas_offset(14.5);
                            make.right.mas_equalTo(leftLab.mas_right).mas_offset(20);
                        }];
                        rightLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
                        rightLab.textAlignment = NSTextAlignmentRight;
                        rightLab.textColor = UUBLACK;
                        rightLab.userInteractionEnabled = YES;
                        //                    UURefundReasonModel *model = _reasonDataSource[0];
                        rightLab.text = _reasonString.length>0?_reasonString:@"请选择退款原因";
                        _reasonLab = rightLab;
                        
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectReturnReason)];
                        [rightLab addGestureRecognizer:tap];
                        return cell;
                    }else if (indexPath.row == 2){
                        UITableViewCell *cell = [[UITableViewCell alloc]init];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        UILabel *starLab = [[UILabel alloc]init];
                        [cell addSubview:starLab];
                        [starLab mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(cell.mas_left).mas_offset(9);
                            make.height.mas_equalTo(10);
                            make.top.mas_equalTo(cell.mas_top).mas_offset(22.5);
                            make.width.mas_equalTo(10);
                        }];
                        starLab.text = @"*";
                        starLab.textColor = UURED;
                        starLab.font = [UIFont systemFontOfSize:15];
                        UILabel *leftLab = [[UILabel alloc]init];
                        [cell addSubview:leftLab];
                        [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(cell.mas_left).mas_offset(22);
                            make.height.mas_equalTo(21);
                            make.top.mas_equalTo(cell.mas_top).mas_offset(14.5);
                            make.width.mas_equalTo(80);
                        }];
                        leftLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
                        leftLab.textAlignment = NSTextAlignmentLeft;
                        leftLab.textColor = UUBLACK;
                        leftLab.text = @"退款金额";
                        
                        UILabel *rightLab = [[UILabel alloc]init];
                        [cell addSubview:rightLab];
                        [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.right.mas_equalTo(cell.mas_right).mas_offset(-22.5);
                            make.height.mas_equalTo(21);
                            make.top.mas_equalTo(cell.mas_top).mas_offset(14.5);
                            make.right.mas_equalTo(leftLab.mas_right).mas_offset(20);
                        }];
                        rightLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
                        rightLab.textAlignment = NSTextAlignmentRight;
                        rightLab.textColor = UUBLACK;
                        rightLab.text = [NSString stringWithFormat:@"%.2f元",_returnDetailModel.OrderTotalMoney];
                        return cell;
                    }else if (indexPath.row == 3){
                        UITableViewCell *cell = [[UITableViewCell alloc]init];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        UILabel *starLab = [[UILabel alloc]init];
                        [cell addSubview:starLab];
                        [starLab mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(cell.mas_left).mas_offset(9);
                            make.height.mas_equalTo(10);
                            make.top.mas_equalTo(cell.mas_top).mas_offset(22.5);
                            make.width.mas_equalTo(10);
                        }];
                        starLab.text = @"*";
                        starLab.textColor = UURED;
                        starLab.font = [UIFont systemFontOfSize:15];
                        UILabel *leftLab = [[UILabel alloc]init];
                        [cell addSubview:leftLab];
                        [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(cell.mas_left).mas_offset(22);
                            make.height.mas_equalTo(21);
                            make.top.mas_equalTo(cell.mas_top).mas_offset(14.5);
                            make.width.mas_equalTo(80);
                        }];
                        leftLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
                        leftLab.textAlignment = NSTextAlignmentLeft;
                        leftLab.textColor = UUBLACK;
                        leftLab.text = @"退款说明";
                        
                        UITextView *returnReason = [[UITextView alloc]init];
                        [cell addSubview:returnReason];
                        [returnReason mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(cell.mas_left).mas_offset(22);
                            make.top.mas_equalTo(leftLab.mas_bottom).mas_offset(11.5);
                            make.width.mas_equalTo(self.view.frame.size.width - 22*2);
                            make.bottom.mas_equalTo(cell.mas_bottom).mas_offset(-5);
                        }];
                        returnReason.text = _Explanation.length>0?_Explanation:@"请输入退款说明";
                        returnReason.delegate = self;
                        returnReason.textColor = UUGREY;
                        return cell;
                    }else {
                        UITableViewCell *cell = [[UITableViewCell alloc]init];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        UILabel *leftLab = [[UILabel alloc]init];
                        [cell addSubview:leftLab];
                        [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(cell.mas_left).mas_offset(22);
                            make.height.mas_equalTo(21);
                            make.top.mas_equalTo(cell.mas_top).mas_offset(14.5);
                            make.width.mas_equalTo(80);
                        }];
                        leftLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
                        leftLab.textAlignment = NSTextAlignmentLeft;
                        leftLab.textColor = UUBLACK;
                        leftLab.text = @"上传凭证";
                        
                        CGFloat imgWidth = (self.view.width - 13*2 - 20*2)/3.0;
                        for (int i = 0; i < _imageArray.count+1; i++) {
                            UIImageView *certificateIV1 = [[UIImageView alloc]initWithFrame:CGRectMake(13 +(20+imgWidth)*(i%3), 45.5 + (10+imgWidth)*(i/3), imgWidth, imgWidth)];
                            [cell addSubview:certificateIV1];
                            if (i <_imageArray.count) {
                                certificateIV1.image = _imageArray[i];
                            }else{
                                certificateIV1.image = [UIImage imageNamed:@"photoplus"];
                                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(upLoadCertification)];
                                certificateIV1.userInteractionEnabled = YES;
                                [certificateIV1 addGestureRecognizer:tap];
                            }
                            
                        }
                        return cell;
                    }
                    
                }else{
                    if (indexPath.row == 0) {
                        UUGoodsOrderTableViewCell *cell = [UUGoodsOrderTableViewCell cellWithTableView:self.tableView];
                        UIImageView *goodImg = [[UIImageView alloc]init];
                        [cell addSubview:goodImg];
                        [goodImg mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(cell.mas_left).mas_offset(12.5);
                            make.top.mas_equalTo(cell.mas_top).mas_offset(3.5);
                            make.height.and.width.mas_equalTo(100);
                        }];
                        [goodImg sd_setImageWithURL:[NSURL URLWithString:_returnDetailModel.ImageUrl]];
                        cell.goodsNameLab.text = _returnDetailModel.GoodsName;
                        cell.attrNameLab.text = _returnDetailModel.GoodsAttrName;
                        cell.rightBtn.hidden = YES;
                        cell.goodsNumLab.text = [NSString stringWithFormat:@"x%ld",_returnDetailModel.GoodsNum];
                        cell.priceLab1.text = [NSString stringWithFormat:@""];
                        cell.priceLab4.hidden = YES;
                        cell.lineLab.hidden = YES;
                        cell.priceLab2.text = [NSString stringWithFormat:@"￥%.2f",_returnDetailModel.StrikePrice];
                        
                        
                        return cell;
                    }else{
                        UITableViewCell *cell = [[UITableViewCell alloc]init];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        UILabel *titleLab = [[UILabel alloc]init];
                        [cell addSubview:titleLab];
                        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.mas_equalTo(cell.mas_top).mas_offset(8.5);
                            make.left.mas_equalTo(cell.mas_left).mas_offset(12.5);
                            make.width.mas_equalTo(65);
                            make.height.mas_equalTo(13.5);
                        }];
                        titleLab.font = [UIFont fontWithName:TITLEFONTNAME size:13];
                        titleLab.textColor = [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1];
                        NSArray *titleArr = @[@"订单号",@"快递运费",@"总计",@"成交时间"];
                        titleLab.text = titleArr[indexPath.row-1];
                        UILabel *rightLab = [[UILabel alloc]init];
                        [cell addSubview:rightLab];
                        [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.mas_equalTo(cell.mas_top).mas_offset(7);
                            make.left.mas_equalTo(titleLab.mas_right).mas_offset(5);
                            make.right.mas_equalTo(cell.mas_right).mas_offset(-13.5);
                            make.height.mas_equalTo(13.5);
                        }];
                        rightLab.font = [UIFont fontWithName:TITLEFONTNAME size:13];
                        rightLab.textColor = UUBLACK;
                        rightLab.textAlignment = NSTextAlignmentRight;
                        if (indexPath.row == 1) {
                            rightLab.text = _returnDetailModel.OrderNO;
                        }else if (indexPath.row == 2){
                            rightLab.text = [NSString stringWithFormat:@"%.0ld元",(long)_returnDetailModel.ShippingFee];
                            _ShipFee = _returnDetailModel.ShippingFee;
                        }else if (indexPath.row == 3){
                            rightLab.text = [NSString stringWithFormat:@"%.2f元",_returnDetailModel.OrderTotalMoney];
                        }else{
                            rightLab.text = [[_returnDetailModel.PayTime substringWithRange:NSMakeRange(0, 16)] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                        }
                        
                        
                        return cell;
                    }
                }
            }
        }else if (self.step == 2){//第二步
            self.secondCircle.backgroundColor = UURED;
            self.secondLab.textColor = UURED;
            self.firstLineLab.backgroundColor = UURED;
            if (indexPath.section == 0) {
                UITableViewCell *cell = [[UITableViewCell alloc]init];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIImageView *leftIV = [[UIImageView alloc]init];
                [cell addSubview:leftIV];
                [leftIV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(cell.mas_left).mas_offset(20);
                    make.top.mas_equalTo(cell.mas_top).mas_offset(11);
                    make.height.and.width.mas_equalTo(38);
                }];
                leftIV.image = [UIImage imageNamed:@"iconfontZhuyi"];
                UILabel *titleLab = [[UILabel alloc]init];
                [cell addSubview:titleLab];
                [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(leftIV.mas_right).mas_offset(8.6);
                    make.top.mas_equalTo(cell.mas_top).mas_offset(18);
                    make.height.mas_equalTo(24);
                    make.width.mas_equalTo(200);
                }];
                titleLab.font = [UIFont fontWithName:TITLEFONTNAME size:16.8];
                titleLab.textColor = UUBLACK;
                titleLab.text = @"等待商家处理退款申请";
                _RefoundId = _returnDetailModel.RefoundId;
                
                UILabel *detailLab = [[UILabel alloc]init];
                [cell addSubview:detailLab];
                [detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.mas_equalTo(titleLab.mas_leading);
                    make.top.mas_equalTo(titleLab.mas_bottom).offset(5);
                    make.right.mas_equalTo(cell.mas_right).offset(-10);
                }];
                
                detailLab.font = [UIFont systemFontOfSize:11.5*SCALE_WIDTH];
                detailLab.textColor = UUGREY;
                detailLab.numberOfLines = 0;
                detailLab.text = @"如果商家同意，退货申请将达成并需要您退货给商家\n如果商家拒绝，将需要您修改退货申请\n如果7天内商家未处理，退货申请将达成并需要您退货给商家";
                return cell;

            }else{
                if (indexPath.row == 0) {
                    UUGoodsOrderTableViewCell *cell = [UUGoodsOrderTableViewCell cellWithTableView:self.tableView];
                    UIImageView *goodImg = [[UIImageView alloc]init];
                    [cell addSubview:goodImg];
                    [goodImg mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(cell.mas_left).mas_offset(12.5);
                        make.top.mas_equalTo(cell.mas_top).mas_offset(3.5);
                        make.height.and.width.mas_equalTo(100);
                    }];
                    [goodImg sd_setImageWithURL:[NSURL URLWithString:_returnDetailModel.ImageUrl]];
                    cell.goodsNameLab.text = _returnDetailModel.GoodsName;
                    cell.attrNameLab.text = _returnDetailModel.GoodsAttrName;
                    cell.rightBtn.hidden = YES;
                    cell.goodsNumLab.text = [NSString stringWithFormat:@"x%ld",_returnDetailModel.GoodsNum];
                    cell.priceLab1.text = [NSString stringWithFormat:@""];
                    cell.priceLab4.hidden = YES;
                    cell.lineLab.hidden = YES;
                    cell.priceLab2.text = [NSString stringWithFormat:@"￥%.2f",_returnDetailModel.StrikePrice];
                    return cell;
                }else{
                    UITableViewCell *cell = [[UITableViewCell alloc]init];
                    UILabel *titleLab = [[UILabel alloc]init];
                    [cell addSubview:titleLab];
                    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(cell.mas_top).mas_offset(8.5);
                        make.left.mas_equalTo(cell.mas_left).mas_offset(12.5);
                        make.width.mas_equalTo(65);
                        make.height.mas_equalTo(13.5);
                    }];
                    titleLab.font = [UIFont fontWithName:TITLEFONTNAME size:13];
                    titleLab.textColor = [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1];
                    NSArray *titleArr = @[@"订单号",@"快递运费",@"总计",@"成交时间"];
                    titleLab.text = titleArr[indexPath.row-1];
                    UILabel *rightLab = [[UILabel alloc]init];
                    [cell addSubview:rightLab];
                    [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(cell.mas_top).mas_offset(7);
                        make.left.mas_equalTo(titleLab.mas_right).mas_offset(5);
                        make.right.mas_equalTo(cell.mas_right).mas_offset(-13.5);
                        make.height.mas_equalTo(13.5);
                    }];
                    rightLab.font = [UIFont fontWithName:TITLEFONTNAME size:13];
                    rightLab.textColor = UUBLACK;
                    rightLab.textAlignment = NSTextAlignmentRight;
                    if (indexPath.row == 1) {
                        rightLab.text = self.returnDetailModel.OrderNO;
                    }else if (indexPath.row == 2){
                        rightLab.text = [NSString stringWithFormat:@"%ld元",self.returnDetailModel.ShippingFee];
                    }else if (indexPath.row == 3){
                        rightLab.text = [NSString stringWithFormat:@"%.1f元",self.returnDetailModel.OrderTotalMoney];
                    }else{
                        rightLab.text = [[self.returnDetailModel.PayTime substringWithRange:NSMakeRange(0, 16)] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                    }
                    
                    
                    return cell;
                }

            }
            
        }else if (self.step == -1){
            if (indexPath.section == 0) {
                UITableViewCell *cell = [[UITableViewCell alloc]init];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIImageView *leftIV = [[UIImageView alloc]init];
                [cell addSubview:leftIV];
                [leftIV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(cell.mas_left).mas_offset(20);
                    make.top.mas_equalTo(cell.mas_top).mas_offset(11);
                    make.height.and.width.mas_equalTo(38);
                }];
                leftIV.image = [UIImage imageNamed:@"iconfontZhuyi"];
                UILabel *titleLab = [[UILabel alloc]init];
                [cell addSubview:titleLab];
                [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(leftIV.mas_right).mas_offset(8.6);
                    make.top.mas_equalTo(cell.mas_top).mas_offset(18);
                    make.height.mas_equalTo(24);
                    make.width.mas_equalTo(200);
                }];
                titleLab.font = [UIFont fontWithName:TITLEFONTNAME size:16.8];
                titleLab.textColor = UUBLACK;
                titleLab.text = @"等待商家收货";
                return cell;
                
            }else{
                if (indexPath.row == 0) {
                    UUGoodsOrderTableViewCell *cell = [UUGoodsOrderTableViewCell cellWithTableView:self.tableView];
                    UIImageView *goodImg = [[UIImageView alloc]init];
                    [cell addSubview:goodImg];
                    [goodImg mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(cell.mas_left).mas_offset(12.5);
                        make.top.mas_equalTo(cell.mas_top).mas_offset(3.5);
                        make.height.and.width.mas_equalTo(100);
                    }];
                    [goodImg sd_setImageWithURL:[NSURL URLWithString:_returnDetailModel.ImageUrl]];
                    cell.goodsNameLab.text = _returnDetailModel.GoodsName;
                    cell.attrNameLab.text = _returnDetailModel.GoodsAttrName;
                    cell.rightBtn.hidden = YES;
                    cell.goodsNumLab.text = [NSString stringWithFormat:@"x%ld",_returnDetailModel.GoodsNum];
                    cell.priceLab1.text = [NSString stringWithFormat:@""];
                    cell.priceLab4.hidden = YES;
                    cell.lineLab.hidden = YES;
                    cell.priceLab2.text = [NSString stringWithFormat:@"￥%.2f",_returnDetailModel.StrikePrice];
                    
                    return cell;
                }else{
                    UITableViewCell *cell = [[UITableViewCell alloc]init];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    UILabel *titleLab = [[UILabel alloc]init];
                    [cell addSubview:titleLab];
                    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(cell.mas_top).mas_offset(8.5);
                        make.left.mas_equalTo(cell.mas_left).mas_offset(12.5);
                        make.width.mas_equalTo(65);
                        make.height.mas_equalTo(13.5);
                    }];
                    titleLab.font = [UIFont fontWithName:TITLEFONTNAME size:13];
                    titleLab.textColor = [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1];
                    NSArray *titleArr = @[@"退款类型",@"退款金额",@"退款原因",@"退款编号"];
                    titleLab.text = titleArr[indexPath.row-1];
                    UILabel *rightLab = [[UILabel alloc]init];
                    [cell addSubview:rightLab];
                    [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(cell.mas_top).mas_offset(7);
                        make.left.mas_equalTo(titleLab.mas_right).mas_offset(5);
                        make.right.mas_equalTo(cell.mas_right).mas_offset(-13.5);
                        make.height.mas_equalTo(13.5);
                    }];
                    rightLab.font = [UIFont fontWithName:TITLEFONTNAME size:13];
                    rightLab.textColor = UUBLACK;
                    rightLab.textAlignment = NSTextAlignmentRight;
                    if (indexPath.row == 1) {
                        rightLab.textColor = UURED;
                        if (_returnDetailModel.RefoundType == 0) {
                            rightLab.text = @"退款";
                        }else{
                            rightLab.text = @"退货退款";
                        }
                        
                    }else if (indexPath.row == 2){
                        rightLab.textColor = UURED;
                        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.2f元",_returnDetailModel.RefundMoney]];
                        [str addAttribute:NSForegroundColorAttributeName value:UUBLACK range:NSMakeRange(str.length -1, 1)];
                        rightLab.attributedText = str;
                    }else if (indexPath.row == 3){
                        rightLab.text = _returnDetailModel.RefundReason;
                    }else{
                        rightLab.text = [NSString stringWithFormat:@"%ld",_returnDetailModel.Skuid];

                    }
                    
                    return cell;
                }
            }
            
        }else{//第三步
            
            if (indexPath.section == 0) {
                UITableViewCell *cell = [[UITableViewCell alloc]init];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIImageView *imgV = [[UIImageView alloc]init];
                [cell addSubview:imgV];
                [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(cell.mas_top).mas_offset(22);
                    make.centerX.mas_equalTo(cell.mas_centerX);
                    make.height.and.width.mas_equalTo(59.5);
                }];
                imgV.image = [UIImage imageNamed:@"完成"];
                UILabel *successLabel = [[UILabel alloc]init];
                [cell addSubview:successLabel];
                [successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(imgV.mas_bottom).mas_offset(16);
                    make.centerX.mas_equalTo(cell.mas_centerX);
                    make.width.mas_equalTo(80);
                    make.height.mas_equalTo(22.5);
                }];
                successLabel.textColor = [UIColor colorWithRed:121/255.0 green:203/255.0 blue:79/255.0 alpha:1];
                successLabel.font = [UIFont fontWithName:TITLEFONTNAME size:16];
                successLabel.text = @"退款成功！";
                successLabel.textAlignment = NSTextAlignmentCenter;
                
                UILabel *returnAmountLab = [[UILabel alloc]init];
                [cell addSubview:returnAmountLab];
                [returnAmountLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(successLabel.mas_bottom);
                    make.centerX.mas_equalTo(cell.mas_centerX);
                    make.width.mas_equalTo(130);
                    make.height.mas_equalTo(21);
                }];
                returnAmountLab.textColor = UURED;
                returnAmountLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"退款金额：%.2f元",_returnDetailModel.RefundMoney]];
                [str addAttribute:NSForegroundColorAttributeName value:UUBLACK range:NSMakeRange(0, 5)];
                [str addAttribute:NSForegroundColorAttributeName value:UUBLACK range:NSMakeRange(str.length -1, 1)];
                returnAmountLab.textAlignment = NSTextAlignmentCenter;
                returnAmountLab.attributedText = str;
                UIView *backView = [[UIView alloc]init];
                [cell addSubview:backView];
                [backView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(returnAmountLab.mas_bottom).mas_offset(24);
                    make.left.mas_equalTo(cell.mas_left);
                    make.width.mas_equalTo(self.view.width);
                    make.height.mas_equalTo(35);
                }];
                backView.backgroundColor = UURED;
                UILabel *lineLab1 = [[UILabel alloc]init];
                [backView addSubview:lineLab1];
                [lineLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(backView.mas_top);
                    make.left.mas_equalTo(cell.mas_left).mas_offset(50.5);
                    make.width.mas_equalTo(0.5);
                    make.height.mas_equalTo(35);
                }];
                lineLab1.backgroundColor = [UIColor whiteColor];
                UILabel *lineLab2 = [[UILabel alloc]init];
                [backView addSubview:lineLab2];
                [lineLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(backView.mas_top);
                    make.left.mas_equalTo(lineLab1.mas_left).mas_offset(75.5);
                    make.width.mas_equalTo(0.5);
                    make.height.mas_equalTo(35);
                }];
                lineLab2.backgroundColor = [UIColor whiteColor];

                UILabel *lineLab3 = [[UILabel alloc]init];
                [backView addSubview:lineLab3];
                [lineLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(backView.mas_top);
                    make.left.mas_equalTo(lineLab2.mas_left).mas_offset(75.5);
                    make.width.mas_equalTo(0.5);
                    make.height.mas_equalTo(35);
                }];
                lineLab3.backgroundColor = [UIColor whiteColor];

                UILabel *NoLab = [[UILabel alloc]init];
                [backView addSubview:NoLab];
                [NoLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(backView.mas_top).mas_offset(12);
                    make.left.mas_equalTo(cell.mas_left);
                    make.width.mas_equalTo(50.5);
                    make.height.mas_equalTo(13);
                }];
                NoLab.textColor = [UIColor whiteColor];
                NoLab.textAlignment = NSTextAlignmentCenter;
                NoLab.font = [UIFont fontWithName:TITLEFONTNAME size:13];
                NoLab.text = @"序号";
                UILabel *detailLab = [[UILabel alloc]init];
                [backView addSubview:detailLab];
                [detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(backView.mas_top).mas_offset(12);
                    make.left.mas_equalTo(lineLab1.mas_right);
                    make.width.mas_equalTo(74.5);
                    make.height.mas_equalTo(13);
                }];
                detailLab.textColor = [UIColor whiteColor];
                detailLab.textAlignment = NSTextAlignmentCenter;
                detailLab.font = [UIFont fontWithName:TITLEFONTNAME size:13];
                detailLab.text = @"退款明细";

                UILabel *amountLab = [[UILabel alloc]init];
                [backView addSubview:amountLab];
                [amountLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(backView.mas_top).mas_offset(12);
                    make.left.mas_equalTo(lineLab2.mas_right);
                    make.width.mas_equalTo(74.5);
                    make.height.mas_equalTo(13);
                }];
                amountLab.textColor = [UIColor whiteColor];
                amountLab.textAlignment = NSTextAlignmentCenter;
                amountLab.font = [UIFont fontWithName:TITLEFONTNAME size:13];
                amountLab.text = @"金额";

                UILabel *statusLab = [[UILabel alloc]init];
                [backView addSubview:statusLab];
                [statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(backView.mas_top).mas_offset(12);
                    make.left.mas_equalTo(lineLab3.mas_right);
                    make.right.mas_equalTo(backView.mas_right);
                    make.height.mas_equalTo(13);
                }];
                statusLab.textColor = [UIColor whiteColor];
                statusLab.textAlignment = NSTextAlignmentCenter;
                statusLab.font = [UIFont fontWithName:TITLEFONTNAME size:13];
                statusLab.text = @"状态";
                
                UILabel *No1Lab = [[UILabel alloc]init];
                [cell addSubview:No1Lab];
                [No1Lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(backView.mas_bottom).mas_offset(11.5);
                    make.left.mas_equalTo(cell.mas_left);
                    make.width.mas_equalTo(50.5);
                    make.height.mas_equalTo(12);
                }];
                No1Lab.textColor = UUGREY;
                No1Lab.textAlignment = NSTextAlignmentCenter;
                No1Lab.font = [UIFont fontWithName:TITLEFONTNAME size:12];
                No1Lab.text = @"1";
                UILabel *detail1Lab = [[UILabel alloc]init];
                [cell addSubview:detail1Lab];
                [detail1Lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(backView.mas_bottom).mas_offset(11.5);
                    make.left.mas_equalTo(No1Lab.mas_right);
                    make.width.mas_equalTo(74.5);
                    make.height.mas_equalTo(12);
                }];
                detail1Lab.textColor = UUGREY;
                detail1Lab.textAlignment = NSTextAlignmentCenter;
                detail1Lab.font = [UIFont fontWithName:TITLEFONTNAME size:12];
                detail1Lab.text = @"退回我的金额";
                
                UILabel *amount1Lab = [[UILabel alloc]init];
                [cell addSubview:amount1Lab];
                [amount1Lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(backView.mas_bottom).mas_offset(11.5);
                    make.left.mas_equalTo(detail1Lab.mas_right);
                    make.width.mas_equalTo(74.5);
                    make.height.mas_equalTo(12);
                }];
                amount1Lab.textColor = UUGREY;
                amount1Lab.textAlignment = NSTextAlignmentCenter;
                amount1Lab.font = [UIFont fontWithName:TITLEFONTNAME size:12];
                amount1Lab.text = [NSString stringWithFormat:@"%.2f元",_returnDetailModel.ReturnBalance];
                
                UILabel *status1Lab = [[UILabel alloc]init];
                [cell addSubview:status1Lab];
                [status1Lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(backView.mas_bottom).mas_offset(11.5);
                    make.left.mas_equalTo(amount1Lab.mas_right);
                    make.right.mas_equalTo(backView.mas_right);
                    make.height.mas_equalTo(12);
                }];
                status1Lab.textColor = UUGREY;
                status1Lab.textAlignment = NSTextAlignmentCenter;
                status1Lab.font = [UIFont fontWithName:TITLEFONTNAME size:12];
                status1Lab.text = @"已退回我的金额";
                
                UILabel *No2Lab = [[UILabel alloc]init];
                [cell addSubview:No2Lab];
                [No2Lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(backView.mas_bottom).mas_offset(39);
                    make.left.mas_equalTo(cell.mas_left);
                    make.width.mas_equalTo(50.5);
                    make.height.mas_equalTo(12);
                }];
                No2Lab.textColor = UUGREY;
                No2Lab.textAlignment = NSTextAlignmentCenter;
                No2Lab.font = [UIFont fontWithName:TITLEFONTNAME size:12];
                No2Lab.text = @"2";
                UILabel *detail2Lab = [[UILabel alloc]init];
                [cell addSubview:detail2Lab];
                [detail2Lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(backView.mas_bottom).mas_offset(39);
                    make.left.mas_equalTo(No1Lab.mas_right);
                    make.width.mas_equalTo(74.5);
                    make.height.mas_equalTo(12);
                }];
                detail2Lab.textColor = UUGREY;
                detail2Lab.textAlignment = NSTextAlignmentCenter;
                detail2Lab.font = [UIFont fontWithName:TITLEFONTNAME size:12];
                detail2Lab.text = @"退回我的库币";
                
                UILabel *amount2Lab = [[UILabel alloc]init];
                [cell addSubview:amount2Lab];
                [amount2Lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(backView.mas_bottom).mas_offset(39);
                    make.left.mas_equalTo(detail1Lab.mas_right);
                    make.width.mas_equalTo(74.5);
                    make.height.mas_equalTo(12);
                }];
                amount2Lab.textColor = UUGREY;
                amount2Lab.textAlignment = NSTextAlignmentCenter;
                amount2Lab.font = [UIFont fontWithName:TITLEFONTNAME size:12];
                amount2Lab.text = [NSString stringWithFormat:@"%.0f库币",_returnDetailModel.ReturnIntegral];;
                
                UILabel *status2Lab = [[UILabel alloc]init];
                [cell addSubview:status2Lab];
                [status2Lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(backView.mas_bottom).mas_offset(39);
                    make.left.mas_equalTo(amount1Lab.mas_right);
                    make.right.mas_equalTo(backView.mas_right);
                    make.height.mas_equalTo(12);
                }];
                status2Lab.textColor = UUGREY;
                status2Lab.textAlignment = NSTextAlignmentCenter;
                status2Lab.font = [UIFont fontWithName:TITLEFONTNAME size:12];
                status2Lab.text = @"已退回我的库币";
                return cell;
            }else if (indexPath.section == 1){
                if (indexPath.row == 0) {
                    UUGoodsOrderTableViewCell *cell = [UUGoodsOrderTableViewCell cellWithTableView:self.tableView];
                    UIImageView *goodImg = [[UIImageView alloc]init];
                    [cell addSubview:goodImg];
                    [goodImg mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(cell.mas_left).mas_offset(12.5);
                        make.top.mas_equalTo(cell.mas_top).mas_offset(3.5);
                        make.height.and.width.mas_equalTo(100);
                    }];
                    [goodImg sd_setImageWithURL:[NSURL URLWithString:_returnDetailModel.ImageUrl]];
                    cell.goodsNameLab.text = _returnDetailModel.GoodsName;
                    cell.attrNameLab.text = _returnDetailModel.GoodsAttrName;
                    cell.rightBtn.hidden = YES;
                    cell.goodsNumLab.text = [NSString stringWithFormat:@"x%ld",_returnDetailModel.GoodsNum];
                    cell.priceLab1.text = [NSString stringWithFormat:@""];
                    cell.priceLab4.hidden = YES;
                    cell.lineLab.hidden = YES;
                    cell.priceLab2.text = [NSString stringWithFormat:@"￥%.2f",_returnDetailModel.StrikePrice];
                    
                    return cell;
                }else{
                    UITableViewCell *cell = [[UITableViewCell alloc]init];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    UILabel *titleLab = [[UILabel alloc]init];
                    [cell addSubview:titleLab];
                    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(cell.mas_top).mas_offset(8.5);
                        make.left.mas_equalTo(cell.mas_left).mas_offset(12.5);
                        make.width.mas_equalTo(65);
                        make.height.mas_equalTo(13.5);
                    }];
                    titleLab.font = [UIFont fontWithName:TITLEFONTNAME size:13];
                    titleLab.textColor = [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1];
                    NSArray *titleArr = @[@"退款类型",@"退款金额",@"退款原因",@"退款编号"];
                    titleLab.text = titleArr[indexPath.row-1];
                    UILabel *rightLab = [[UILabel alloc]init];
                    [cell addSubview:rightLab];
                    [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(cell.mas_top).mas_offset(7);
                        make.left.mas_equalTo(titleLab.mas_right).mas_offset(5);
                        make.right.mas_equalTo(cell.mas_right).mas_offset(-13.5);
                        make.height.mas_equalTo(13.5);
                    }];
                    rightLab.font = [UIFont fontWithName:TITLEFONTNAME size:13];
                    rightLab.textColor = UUBLACK;
                    rightLab.textAlignment = NSTextAlignmentRight;
                    if (indexPath.row == 1) {
                        rightLab.textColor = UURED;
                        if (_returnDetailModel.RefoundType == 0) {
                            rightLab.text = @"退款";
                        }else{
                            rightLab.text = @"退货退款";
                        }
                        
                    }else if (indexPath.row == 2){
                        rightLab.textColor = UURED;
                        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.2f元",_returnDetailModel.RefundMoney]];
                        [str addAttribute:NSForegroundColorAttributeName value:UUBLACK range:NSMakeRange(str.length -1, 1)];
                        rightLab.attributedText = str;
                    }else if (indexPath.row == 3){
                        rightLab.text = _returnDetailModel.RefundReason;
                    }else{
                        rightLab.text = [NSString stringWithFormat:@"%ld",_returnDetailModel.Skuid];

                    }
                    
                    return cell;
                }

            }else{
                if (indexPath.row==0) {
                    //login
                    UITableViewCell *cell = [[UITableViewCell alloc] init];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    UIImageView *LogoimageView = [[UIImageView alloc] initWithFrame:CGRectMake(17.5, 12.5, 12.8, 15)];
                    [LogoimageView setImage:[UIImage imageNamed:@"iconfont-zanxi"]];
                    [cell addSubview:LogoimageView];
                    //名称
                    UILabel *namelabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 9.5, 60, 21)];
                    namelabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
                    namelabel.text = @"热门推荐";
                    [cell addSubview:namelabel];
                    return cell;
                    
                }else{
                    
                    UITableViewCell *cell = [[UITableViewCell alloc] init];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    cell.backgroundColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1];
                    
                    if (self.guessShopArray != nil && ![self.guessShopArray isKindOfClass:[NSNull class]] && self.guessShopArray.count != 0) {
                        for (int i=0; i<self.guessShopArray.count; i++) {
                            UIView *backView = [[UIView alloc] init];
                            backView.backgroundColor = [UIColor whiteColor];
                            
                            if (i%2==0) {
                                backView.frame = CGRectMake(0, i/2*260+1*i/2, self.view.width/2, 260);
                            }else{
                                
                                backView.frame = CGRectMake(self.view.width/2+1, i/2*260+1*i/2, self.view.width/2, 260);
                            }
                            
                            //图片所在的View
                            UIView *imageView = [[UIView alloc] initWithFrame:CGRectMake(18.5, 12, backView.width-18.5*2, backView.width-18.5*2)];
                            //                    imageView.backgroundColor = [UIColor redColor];
                            //图片
                            UIImageView *image = [[UIImageView alloc] initWithFrame:imageView.bounds];
                            [image sd_setImageWithURL:[NSURL URLWithString:[self.guessShopArray[i] valueForKey:@"Images"][0]]];
                            
                            
                            
                            // 价格表单
                            UIView *listView = [[UIView alloc] initWithFrame:CGRectMake(0, 104.5+25, imageView.width, 20.5)];
                            
                            listView.backgroundColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1];
                            
                            //原价
                            UILabel *originalLabel = [[UILabel alloc] initWithFrame:CGRectMake(3.5, 2, 80, 15)];
                            originalLabel.textColor = [UIColor whiteColor];
                            originalLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
                            originalLabel.text = @"原价：¥98";
                            originalLabel.text = [NSString stringWithFormat:@"原价:¥%@",[self.guessShopArray[i] valueForKey:@"BuyPrice"]];
                            [originalLabel sizeToFit];
                            [listView addSubview:originalLabel];
                            UILabel *lineLab = [[UILabel alloc]init];
                            [originalLabel addSubview:lineLab];
                            [lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.mas_equalTo(originalLabel.mas_left);
                                make.centerY.mas_equalTo(originalLabel.mas_centerY);
                                make.height.mas_equalTo(1);
                                make.width.mas_equalTo(originalLabel.mas_width);
                            }];
                            lineLab.backgroundColor = [UIColor whiteColor];
                            //购买数
                            UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(listView.width-75, 2, 75, 15)];
                            numberLabel.textColor = [UIColor whiteColor];
                            numberLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
                            numberLabel.text = @"已有234人购买";
                            numberLabel.text = [NSString stringWithFormat:@"已有%@人购买",[self.guessShopArray[i] valueForKey:@"GoodsSaleNum"]];
                            [listView addSubview:numberLabel];
                            
                            
                            
                            [imageView addSubview:image];
                            [imageView addSubview:listView];
                            
                            [backView addSubview:imageView];
                            
                            //商品介绍
                            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(18.5, 143+25, 150, 18)];
                            label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.5];
                            label.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
                            label.text = @"商品介绍";
                            label.text =[NSString stringWithFormat:@"%@",[self.guessShopArray[i] valueForKey:@"GoodsName"]];
                            [backView addSubview:label];
                            
                            //采购价
                            UILabel *purchaselabel = [[UILabel alloc] initWithFrame:CGRectMake(18.5, 172+25, 150, 18)];
                            
                            
                            [purchaselabel setTextColor:[UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1]];
                            
                            purchaselabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
                            
                            purchaselabel.text = @"采购价：¥25";
                            purchaselabel.text = [NSString stringWithFormat:@"采购价：¥%@",[self.guessShopArray[i] valueForKey:@"MarketPrice"]];
                            
                            [backView addSubview:purchaselabel];
                            
                            
                            //会员价
                            
                            UILabel *memberlabel = [[UILabel alloc] initWithFrame:CGRectMake(18.5, 187+25, 150, 18)];
                            [memberlabel setTextColor:[UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1]];
                            
                            memberlabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
                            memberlabel.text = @"会员价:¥55";
                            memberlabel.text =[NSString stringWithFormat:@"会员价：¥%@",[self.guessShopArray[i] valueForKey:@"MemberPrice"]];
                            
                            [backView addSubview:memberlabel];
                            
                            //赚库币  按钮
                            
                            UIButton *earnBtn = [[UIButton alloc] initWithFrame:CGRectMake(backView.width-18.5-50, 185+25, 50, 20)];
                            earnBtn.imageEdgeInsets = UIEdgeInsetsMake(4.5, 5, 5, 37.7);
                            earnBtn.titleEdgeInsets =UIEdgeInsetsMake(3, -15, 3, 4.5);
                            
                            [earnBtn setImage:[UIImage imageNamed:@"商城分享按钮"] forState:UIControlStateNormal];
                            [earnBtn setTitle:@"赚库币" forState:UIControlStateNormal];
                            [earnBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                            earnBtn.titleLabel.font= [UIFont fontWithName:@"PingFangSC-Regular" size:10];
                            [earnBtn addTarget:self action:@selector(earnAction:) forControlEvents:UIControlEventTouchUpInside];
                            
                            earnBtn.layer.masksToBounds = YES;
                            earnBtn.layer.cornerRadius = 2.5;
                            earnBtn.backgroundColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
                            
                            [backView addSubview:earnBtn];
                            
                            [cell addSubview:backView];
                            
                        }
                        
                        
                    }
                    
                    return cell;
                }

            }
            
        }

    }else{//退货
        if (self.step == 1) {
            if (_isCancel == 0) {
                
            NSMutableArray *goodsSource = [NSMutableArray new];
            for (NSDictionary *dict in self.orderListModel.OrderGoods) {
                UUGoodsModel *model =  [[UUGoodsModel alloc]initWithDictionary:dict];
                [goodsSource addObject:model];
            }
            UUGoodsModel *goodsModel = goodsSource[self.modelRow-1];
            _SKUID = [goodsModel.SKUID integerValue];
            _OrderNO = self.orderListModel.OrderNO;
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    UITableViewCell *cell = [[UITableViewCell alloc]init];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    UILabel *leftLab = [[UILabel alloc]init];
                    [cell addSubview:leftLab];
                    [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(cell.mas_left);
                        make.height.mas_equalTo(21);
                        make.top.mas_equalTo(cell.mas_top).mas_offset(14.5);
                        make.width.mas_equalTo(self.view.frame.size.width/2.0);
                    }];
                    leftLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
                    leftLab.textAlignment = NSTextAlignmentCenter;
                    leftLab.text = @"我要退货";
                    UILabel *leftLineLab = [[UILabel alloc]init];
                    [cell addSubview:leftLineLab];
                    [leftLineLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        
                        make.left.mas_equalTo(cell.mas_left);
                        make.height.mas_equalTo(2.5);
                        make.bottom.mas_equalTo(cell.mas_bottom);
                        make.width.mas_equalTo(self.view.frame.size.width/2.0);
                    }];
                    leftLineLab.backgroundColor = UURED;
                    UILabel *rightLab = [[UILabel alloc]init];
                    [cell addSubview:rightLab];
                    [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.mas_equalTo(cell.mas_right);
                        make.height.mas_equalTo(21);
                        make.top.mas_equalTo(cell.mas_top).mas_offset(14.5);
                        make.width.mas_equalTo(self.view.frame.size.width/2.0);
                    }];
                    rightLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
                    rightLab.textAlignment = NSTextAlignmentCenter;
                    rightLab.text = @"我要退款（无需退货）";
                    UILabel *rightLineLab = [[UILabel alloc]init];
                    [cell addSubview:rightLineLab];
                    [rightLineLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        
                        make.right.mas_equalTo(cell.mas_right);
                        make.height.mas_equalTo(2.5);
                        make.bottom.mas_equalTo(cell.mas_bottom);
                        make.width.mas_equalTo(self.view.frame.size.width/2.0);
                    }];
                    rightLineLab.backgroundColor = UURED;
                    if (self.index == 1) {
                        leftLineLab.hidden = YES;
                        leftLab.textColor = UUGREY;
                        rightLab.textColor = UURED;
                        _RefundType = @"0";
                    }
                    if (self.index == 2) {
                        rightLineLab.hidden = YES;
                        rightLab.textColor = UUGREY;
                        leftLab.textColor = UURED;
                        _RefundType = @"1";
                    }
                    
                    
                    return cell;
                }else if (indexPath.row == 1){
                    UITableViewCell *cell = [[UITableViewCell alloc]init];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    UILabel *starLab = [[UILabel alloc]init];
                    [cell addSubview:starLab];
                    [starLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(cell.mas_left).mas_offset(9);
                        make.height.mas_equalTo(10);
                        make.top.mas_equalTo(cell.mas_top).mas_offset(22.5);
                        make.width.mas_equalTo(10);
                    }];
                    starLab.text = @"*";
                    starLab.textColor = UURED;
                    starLab.font = [UIFont systemFontOfSize:15];
                    UILabel *leftLab = [[UILabel alloc]init];
                    [cell addSubview:leftLab];
                    [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(cell.mas_left).mas_offset(22);
                        make.height.mas_equalTo(21);
                        make.top.mas_equalTo(cell.mas_top).mas_offset(14.5);
                        make.width.mas_equalTo(80);
                    }];
                    leftLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
                    leftLab.textAlignment = NSTextAlignmentLeft;
                    leftLab.textColor = UUBLACK;
                    leftLab.text = @"退款原因";
                    UILabel *rightLab = [[UILabel alloc]init];
                    [cell addSubview:rightLab];
                    [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.mas_equalTo(cell.mas_right).mas_offset(-22.5);
                        make.height.mas_equalTo(21);
                        make.top.mas_equalTo(cell.mas_top).mas_offset(14.5);
                        make.right.mas_equalTo(leftLab.mas_right).mas_offset(20);
                    }];
                    rightLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
                    rightLab.textAlignment = NSTextAlignmentRight;
                    rightLab.textColor = UUBLACK;
                    rightLab.text = _reasonString.length>0?_reasonString:@"请选择退款原因";
                    rightLab.userInteractionEnabled = YES;
                    _reasonLab = rightLab;
                    
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectReturnReason)];
                    [rightLab addGestureRecognizer:tap];

                    return cell;
                }else if (indexPath.row == 2){
                    UITableViewCell *cell = [[UITableViewCell alloc]init];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    UILabel *starLab = [[UILabel alloc]init];
                    [cell addSubview:starLab];
                    [starLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(cell.mas_left).mas_offset(9);
                        make.height.mas_equalTo(10);
                        make.top.mas_equalTo(cell.mas_top).mas_offset(22.5);
                        make.width.mas_equalTo(10);
                    }];
                    starLab.text = @"*";
                    starLab.textColor = UURED;
                    starLab.font = [UIFont systemFontOfSize:15];
                    UILabel *leftLab = [[UILabel alloc]init];
                    [cell addSubview:leftLab];
                    [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(cell.mas_left).mas_offset(22);
                        make.height.mas_equalTo(21);
                        make.top.mas_equalTo(cell.mas_top).mas_offset(14.5);
                        make.width.mas_equalTo(80);
                    }];
                    leftLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
                    leftLab.textAlignment = NSTextAlignmentLeft;
                    leftLab.textColor = UUBLACK;
                    leftLab.text = @"退款金额";
                    UILabel *rightLab = [[UILabel alloc]init];
                    [cell addSubview:rightLab];
                    [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.mas_equalTo(cell.mas_right).mas_offset(-22.5);
                        make.height.mas_equalTo(21);
                        make.top.mas_equalTo(cell.mas_top).mas_offset(14.5);
                        make.right.mas_equalTo(leftLab.mas_right).mas_offset(20);
                    }];
                    rightLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
                    rightLab.textAlignment = NSTextAlignmentRight;
                    rightLab.textColor = UUBLACK;
                    rightLab.text = [NSString stringWithFormat:@"%.2f元",[goodsModel.StrickePrice floatValue]*[goodsModel.GoodsNum integerValue]+self.orderListModel.ShippingFee];
                    _GoodsAmount = [goodsModel.StrickePrice floatValue]*[goodsModel.GoodsNum integerValue];
                    return cell;
                }else if (indexPath.row == 3){
                    UITableViewCell *cell = [[UITableViewCell alloc]init];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    UILabel *starLab = [[UILabel alloc]init];
                    [cell addSubview:starLab];
                    [starLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(cell.mas_left).mas_offset(9);
                        make.height.mas_equalTo(10);
                        make.top.mas_equalTo(cell.mas_top).mas_offset(22.5);
                        make.width.mas_equalTo(10);
                    }];
                    starLab.text = @"*";
                    starLab.textColor = UURED;
                    starLab.font = [UIFont systemFontOfSize:15];
                    UILabel *leftLab = [[UILabel alloc]init];
                    [cell addSubview:leftLab];
                    [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(cell.mas_left).mas_offset(22);
                        make.height.mas_equalTo(21);
                        make.top.mas_equalTo(cell.mas_top).mas_offset(14.5);
                        make.width.mas_equalTo(80);
                    }];
                    leftLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
                    leftLab.textAlignment = NSTextAlignmentLeft;
                    leftLab.textColor = UUBLACK;
                    leftLab.text = @"退款说明";
                    
                    UITextView *returnReason = [[UITextView alloc]init];
                    [cell addSubview:returnReason];
                    [returnReason mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(cell.mas_left).mas_offset(22);
                        make.top.mas_equalTo(leftLab.mas_bottom).mas_offset(11.5);
                        make.width.mas_equalTo(self.view.frame.size.width - 22*2);
                        make.bottom.mas_equalTo(cell.mas_bottom).mas_offset(-5);
                    }];
                    returnReason.text = _Explanation.length>0?_Explanation:@"请输入退款说明";
                    returnReason.textColor = UUGREY;
                    returnReason.delegate = self;
                    return cell;
                }else{
                    UITableViewCell *cell = [[UITableViewCell alloc]init];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    UILabel *starLab = [[UILabel alloc]init];
                    [cell addSubview:starLab];
                    [starLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(cell.mas_left).mas_offset(9);
                        make.height.mas_equalTo(10);
                        make.top.mas_equalTo(cell.mas_top).mas_offset(22.5);
                        make.width.mas_equalTo(10);
                    }];
                    starLab.text = @"*";
                    starLab.textColor = UURED;
                    starLab.font = [UIFont systemFontOfSize:15];
                    UILabel *leftLab = [[UILabel alloc]init];
                    [cell addSubview:leftLab];
                    [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(cell.mas_left).mas_offset(22);
                        make.height.mas_equalTo(21);
                        make.top.mas_equalTo(cell.mas_top).mas_offset(14.5);
                        make.width.mas_equalTo(80);
                    }];
                    leftLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
                    leftLab.textAlignment = NSTextAlignmentLeft;
                    leftLab.textColor = UUBLACK;
                    leftLab.text = @"上传凭证";
                    
                    CGFloat imgWidth = (self.view.width - 13*2 - 20*2)/3.0;
                    for (int i = 0; i < _imageArray.count+1; i++) {
                        UIImageView *certificateIV1 = [[UIImageView alloc]initWithFrame:CGRectMake(13 +(20+imgWidth)*(i%3), 45.5 + (10+imgWidth)*(i/3), imgWidth, imgWidth)];
                        [cell addSubview:certificateIV1];
                        if (i <_imageArray.count) {
                            certificateIV1.image = _imageArray[i];
                        }else{
                            certificateIV1.image = [UIImage imageNamed:@"photoplus"];
                            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(upLoadCertification)];
                            certificateIV1.userInteractionEnabled = YES;
                            [certificateIV1 addGestureRecognizer:tap];
                        }
                        
                    }
                    return cell;
                }
                
            }else{
                if (indexPath.row == 0) {
                    UUGoodsOrderTableViewCell *cell = [UUGoodsOrderTableViewCell cellWithTableView:self.tableView];
                    
                    UIImageView *goodImg = [[UIImageView alloc]init];
                    [cell addSubview:goodImg];
                    [goodImg mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(cell.mas_left).mas_offset(12.5);
                        make.top.mas_equalTo(cell.mas_top).mas_offset(3.5);
                        make.height.and.width.mas_equalTo(100);
                    }];
                    [goodImg sd_setImageWithURL:[NSURL URLWithString:goodsModel.ImgUrl]];
                    cell.goodsNameLab.text = goodsModel.GoodsName;
                    cell.attrNameLab.text = goodsModel.GoodsAttrName;
                    cell.rightBtn.hidden = YES;
                    cell.goodsNumLab.text = [NSString stringWithFormat:@"x%@",goodsModel.GoodsNum];
                    cell.priceLab1.text = [NSString stringWithFormat:@""];
                    if (_OrderType == 0) {
                        cell.priceLab2.text = [NSString stringWithFormat:@"会员价：￥%@",goodsModel.StrickePrice];
                        cell.priceLab4.text = [NSString stringWithFormat:@"￥%@",goodsModel.OriginalPrice];
                    }
                    if (_OrderType == 1) {
                        cell.priceLab2.text = [NSString stringWithFormat:@"采购价：￥%@",goodsModel.StrickePrice];
                        cell.priceLab4.text = [NSString stringWithFormat:@"￥%@",goodsModel.MarketPrice];
                    }
                    if (_OrderType == 2 ||_OrderType == 3) {
                        cell.priceLab2.text = [NSString stringWithFormat:@"活动价：￥%@",goodsModel.StrickePrice];
                        cell.priceLab4.text = [NSString stringWithFormat:@"￥%@",goodsModel.OriginalPrice];
                    }
                    if (_OrderType == 4) {
                        cell.priceLab2.text = [NSString stringWithFormat:@"团购价：￥%@",goodsModel.StrickePrice];
                        cell.priceLab4.text = [NSString stringWithFormat:@"￥%@",goodsModel.OriginalPrice];
                    }
                    
                    return cell;
                }else{
                    UITableViewCell *cell = [[UITableViewCell alloc]init];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    UILabel *titleLab = [[UILabel alloc]init];
                    [cell addSubview:titleLab];
                    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(cell.mas_top).mas_offset(8.5);
                        make.left.mas_equalTo(cell.mas_left).mas_offset(12.5);
                        make.width.mas_equalTo(65);
                        make.height.mas_equalTo(13.5);
                    }];
                    titleLab.font = [UIFont fontWithName:TITLEFONTNAME size:13];
                    titleLab.textColor = [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1];
                    NSArray *titleArr = @[@"订单号",@"快递运费",@"总计",@"成交时间"];
                    titleLab.text = titleArr[indexPath.row-1];
                    UILabel *rightLab = [[UILabel alloc]init];
                    [cell addSubview:rightLab];
                    [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(cell.mas_top).mas_offset(7);
                        make.left.mas_equalTo(titleLab.mas_right).mas_offset(5);
                        make.right.mas_equalTo(cell.mas_right).mas_offset(-13.5);
                        make.height.mas_equalTo(13.5);
                    }];
                    rightLab.font = [UIFont fontWithName:TITLEFONTNAME size:13];
                    rightLab.textColor = UUBLACK;
                    rightLab.textAlignment = NSTextAlignmentRight;
                    if (indexPath.row == 1) {
                        rightLab.text = self.orderListModel.OrderNO;
                    }else if (indexPath.row == 2){
                        rightLab.text = [NSString stringWithFormat:@"%.0f元",self.orderListModel.ShippingFee];
                    }else if (indexPath.row == 3){
                        rightLab.text = [NSString stringWithFormat:@"%.1f元",self.orderListModel.OrderAmount];
                    }else{
                        rightLab.text = [[self.orderListModel.PayTime substringWithRange:NSMakeRange(0, 16)] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                    }
                    
                    
                    return cell;
                }
            }
            }else{
                _SKUID = _returnDetailModel.Skuid;
                _OrderNO = _returnDetailModel.OrderNO;
                if (indexPath.section == 0) {
                    if (indexPath.row == 0) {
                        UITableViewCell *cell = [[UITableViewCell alloc]init];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        UILabel *leftLab = [[UILabel alloc]init];
                        [cell addSubview:leftLab];
                        [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(cell.mas_left);
                            make.height.mas_equalTo(21);
                            make.top.mas_equalTo(cell.mas_top).mas_offset(14.5);
                            make.width.mas_equalTo(self.view.frame.size.width/2.0);
                        }];
                        leftLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
                        leftLab.textAlignment = NSTextAlignmentCenter;
                        leftLab.text = @"我要退货";
                        UILabel *leftLineLab = [[UILabel alloc]init];
                        [cell addSubview:leftLineLab];
                        [leftLineLab mas_makeConstraints:^(MASConstraintMaker *make) {
                            
                            make.left.mas_equalTo(cell.mas_left);
                            make.height.mas_equalTo(2.5);
                            make.bottom.mas_equalTo(cell.mas_bottom);
                            make.width.mas_equalTo(self.view.frame.size.width/2.0);
                        }];
                        leftLineLab.backgroundColor = UURED;
                        UILabel *rightLab = [[UILabel alloc]init];
                        [cell addSubview:rightLab];
                        [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.right.mas_equalTo(cell.mas_right);
                            make.height.mas_equalTo(21);
                            make.top.mas_equalTo(cell.mas_top).mas_offset(14.5);
                            make.width.mas_equalTo(self.view.frame.size.width/2.0);
                        }];
                        rightLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
                        rightLab.textAlignment = NSTextAlignmentCenter;
                        rightLab.text = @"我要退款（无需退货）";
                        UILabel *rightLineLab = [[UILabel alloc]init];
                        [cell addSubview:rightLineLab];
                        [rightLineLab mas_makeConstraints:^(MASConstraintMaker *make) {
                            
                            make.right.mas_equalTo(cell.mas_right);
                            make.height.mas_equalTo(2.5);
                            make.bottom.mas_equalTo(cell.mas_bottom);
                            make.width.mas_equalTo(self.view.frame.size.width/2.0);
                        }];
                        rightLineLab.backgroundColor = UURED;
                        if (self.index == 1) {
                            leftLineLab.hidden = YES;
                            leftLab.textColor = UUGREY;
                            rightLab.textColor = UURED;
                            _RefundType = @"0";
                        }
                        if (self.index == 2) {
                            rightLineLab.hidden = YES;
                            rightLab.textColor = UUGREY;
                            leftLab.textColor = UURED;
                            _RefundType = @"1";
                        }
                        
                        
                        return cell;
                    }else if (indexPath.row == 1){
                        UITableViewCell *cell = [[UITableViewCell alloc]init];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        UILabel *starLab = [[UILabel alloc]init];
                        [cell addSubview:starLab];
                        [starLab mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(cell.mas_left).mas_offset(9);
                            make.height.mas_equalTo(10);
                            make.top.mas_equalTo(cell.mas_top).mas_offset(22.5);
                            make.width.mas_equalTo(10);
                        }];
                        starLab.text = @"*";
                        starLab.textColor = UURED;
                        starLab.font = [UIFont systemFontOfSize:15];
                        UILabel *leftLab = [[UILabel alloc]init];
                        [cell addSubview:leftLab];
                        [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(cell.mas_left).mas_offset(22);
                            make.height.mas_equalTo(21);
                            make.top.mas_equalTo(cell.mas_top).mas_offset(14.5);
                            make.width.mas_equalTo(80);
                        }];
                        leftLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
                        leftLab.textAlignment = NSTextAlignmentLeft;
                        leftLab.textColor = UUBLACK;
                        leftLab.text = @"退款原因";
                        UILabel *rightLab = [[UILabel alloc]init];
                        [cell addSubview:rightLab];
                        [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.right.mas_equalTo(cell.mas_right).mas_offset(-22.5);
                            make.height.mas_equalTo(21);
                            make.top.mas_equalTo(cell.mas_top).mas_offset(14.5);
                            make.right.mas_equalTo(leftLab.mas_right).mas_offset(20);
                        }];
                        rightLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
                        rightLab.textAlignment = NSTextAlignmentRight;
                        rightLab.textColor = UUBLACK;
                        rightLab.userInteractionEnabled = YES;
                        //                    UURefundReasonModel *model = _reasonDataSource[0];
                        rightLab.text = _reasonString.length>0?_reasonString:@"请选择退款原因";
                        _reasonLab = rightLab;
                        
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectReturnReason)];
                        [rightLab addGestureRecognizer:tap];
                        return cell;
                    }else if (indexPath.row == 2){
                        UITableViewCell *cell = [[UITableViewCell alloc]init];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        UILabel *starLab = [[UILabel alloc]init];
                        [cell addSubview:starLab];
                        [starLab mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(cell.mas_left).mas_offset(9);
                            make.height.mas_equalTo(10);
                            make.top.mas_equalTo(cell.mas_top).mas_offset(22.5);
                            make.width.mas_equalTo(10);
                        }];
                        starLab.text = @"*";
                        starLab.textColor = UURED;
                        starLab.font = [UIFont systemFontOfSize:15];
                        UILabel *leftLab = [[UILabel alloc]init];
                        [cell addSubview:leftLab];
                        [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(cell.mas_left).mas_offset(22);
                            make.height.mas_equalTo(21);
                            make.top.mas_equalTo(cell.mas_top).mas_offset(14.5);
                            make.width.mas_equalTo(80);
                        }];
                        leftLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
                        leftLab.textAlignment = NSTextAlignmentLeft;
                        leftLab.textColor = UUBLACK;
                        leftLab.text = @"退款金额";
                        
                        UILabel *rightLab = [[UILabel alloc]init];
                        [cell addSubview:rightLab];
                        [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.right.mas_equalTo(cell.mas_right).mas_offset(-22.5);
                            make.height.mas_equalTo(21);
                            make.top.mas_equalTo(cell.mas_top).mas_offset(14.5);
                            make.right.mas_equalTo(leftLab.mas_right).mas_offset(20);
                        }];
                        rightLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
                        rightLab.textAlignment = NSTextAlignmentRight;
                        rightLab.textColor = UUBLACK;
                       rightLab.text = [NSString stringWithFormat:@"%.2f元",_returnDetailModel.OrderTotalMoney];
                        return cell;
                    }else if (indexPath.row == 3){
                        UITableViewCell *cell = [[UITableViewCell alloc]init];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        UILabel *starLab = [[UILabel alloc]init];
                        [cell addSubview:starLab];
                        [starLab mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(cell.mas_left).mas_offset(9);
                            make.height.mas_equalTo(10);
                            make.top.mas_equalTo(cell.mas_top).mas_offset(22.5);
                            make.width.mas_equalTo(10);
                        }];
                        starLab.text = @"*";
                        starLab.textColor = UURED;
                        starLab.font = [UIFont systemFontOfSize:15];
                        UILabel *leftLab = [[UILabel alloc]init];
                        [cell addSubview:leftLab];
                        [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(cell.mas_left).mas_offset(22);
                            make.height.mas_equalTo(21);
                            make.top.mas_equalTo(cell.mas_top).mas_offset(14.5);
                            make.width.mas_equalTo(80);
                        }];
                        leftLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
                        leftLab.textAlignment = NSTextAlignmentLeft;
                        leftLab.textColor = UUBLACK;
                        leftLab.text = @"退款说明";
                        
                        UITextView *returnReason = [[UITextView alloc]init];
                        [cell addSubview:returnReason];
                        [returnReason mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(cell.mas_left).mas_offset(22);
                            make.top.mas_equalTo(leftLab.mas_bottom).mas_offset(11.5);
                            make.width.mas_equalTo(self.view.frame.size.width - 22*2);
                            make.bottom.mas_equalTo(cell.mas_bottom).mas_offset(-5);
                        }];
                        returnReason.text = _Explanation.length>0?_Explanation:@"请输入退款说明";
                        returnReason.delegate = self;
                        returnReason.textColor = UUGREY;
                        return cell;
                    }else if (indexPath.row == 4){
                        UITableViewCell *cell = [[UITableViewCell alloc]init];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        UILabel *starLab = [[UILabel alloc]init];
                        [cell addSubview:starLab];
                        [starLab mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(cell.mas_left).mas_offset(9);
                            make.height.mas_equalTo(10);
                            make.top.mas_equalTo(cell.mas_top).mas_offset(22.5);
                            make.width.mas_equalTo(10);
                        }];
                        starLab.text = @"*";
                        starLab.textColor = UURED;
                        starLab.font = [UIFont systemFontOfSize:15];
                        UILabel *leftLab = [[UILabel alloc]init];
                        [cell addSubview:leftLab];
                        [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(cell.mas_left).mas_offset(22);
                            make.height.mas_equalTo(21);
                            make.top.mas_equalTo(cell.mas_top).mas_offset(14.5);
                            make.width.mas_equalTo(80);
                        }];
                        leftLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
                        leftLab.textAlignment = NSTextAlignmentLeft;
                        leftLab.textColor = UUBLACK;
                        leftLab.text = @"上传凭证";
                        
                        CGFloat imgWidth = (self.view.width - 13*2 - 20*2)/3.0;
                        for (int i = 0; i < _imageArray.count+1; i++) {
                            UIImageView *certificateIV1 = [[UIImageView alloc]initWithFrame:CGRectMake(13 +(20+imgWidth)*(i%3), 45.5 + (10+imgWidth)*(i/3), imgWidth, imgWidth)];
                            [cell addSubview:certificateIV1];
                            if (i <_imageArray.count) {
                                certificateIV1.image = _imageArray[i];
                            }else{
                                certificateIV1.image = [UIImage imageNamed:@"photoplus"];
                                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(upLoadCertification)];
                                certificateIV1.userInteractionEnabled = YES;
                                [certificateIV1 addGestureRecognizer:tap];
                            }
                            
                        }
                        return cell;
                    }else{
                        UITableViewCell *cell = [[UITableViewCell alloc]init];
                        return cell;
                    }
                    
                }else{
                    if (indexPath.row == 0) {
                        UUGoodsOrderTableViewCell *cell = [UUGoodsOrderTableViewCell cellWithTableView:self.tableView];
                        UIImageView *goodImg = [[UIImageView alloc]init];
                        [cell addSubview:goodImg];
                        [goodImg mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(cell.mas_left).mas_offset(12.5);
                            make.top.mas_equalTo(cell.mas_top).mas_offset(3.5);
                            make.height.and.width.mas_equalTo(100);
                        }];
                        [goodImg sd_setImageWithURL:[NSURL URLWithString:_returnDetailModel.ImageUrl]];
                        cell.goodsNameLab.text = _returnDetailModel.GoodsName;
                        cell.attrNameLab.text = _returnDetailModel.GoodsAttrName;
                        cell.rightBtn.hidden = YES;
                        cell.goodsNumLab.text = [NSString stringWithFormat:@"x%ld",_returnDetailModel.GoodsNum];
                        cell.priceLab1.text = [NSString stringWithFormat:@""];
                        cell.priceLab4.hidden = YES;
                        cell.lineLab.hidden = YES;
                        cell.priceLab2.text = [NSString stringWithFormat:@"￥%.2f",_returnDetailModel.StrikePrice];
                        
                        
                        return cell;
                    }else{
                        UITableViewCell *cell = [[UITableViewCell alloc]init];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        UILabel *titleLab = [[UILabel alloc]init];
                        [cell addSubview:titleLab];
                        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.mas_equalTo(cell.mas_top).mas_offset(8.5);
                            make.left.mas_equalTo(cell.mas_left).mas_offset(12.5);
                            make.width.mas_equalTo(65);
                            make.height.mas_equalTo(13.5);
                        }];
                        titleLab.font = [UIFont fontWithName:TITLEFONTNAME size:13];
                        titleLab.textColor = [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1];
                        NSArray *titleArr = @[@"订单号",@"快递运费",@"总计",@"成交时间"];
                        titleLab.text = titleArr[indexPath.row-1];
                        UILabel *rightLab = [[UILabel alloc]init];
                        [cell addSubview:rightLab];
                        [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.mas_equalTo(cell.mas_top).mas_offset(7);
                            make.left.mas_equalTo(titleLab.mas_right).mas_offset(5);
                            make.right.mas_equalTo(cell.mas_right).mas_offset(-13.5);
                            make.height.mas_equalTo(13.5);
                        }];
                        rightLab.font = [UIFont fontWithName:TITLEFONTNAME size:13];
                        rightLab.textColor = UUBLACK;
                        rightLab.textAlignment = NSTextAlignmentRight;
                        if (indexPath.row == 1) {
                            rightLab.text = self.orderListModel.OrderNO;
                        }else if (indexPath.row == 2){
                            rightLab.text = [NSString stringWithFormat:@"%.0ld元",(long)_returnDetailModel.ShippingFee];
                            _ShipFee = _returnDetailModel.ShippingFee;
                        }else if (indexPath.row == 3){
                            rightLab.text = [NSString stringWithFormat:@"%.2f元",_returnDetailModel.OrderTotalMoney];
                        }else{
                            rightLab.text = [[_returnDetailModel.PayTime substringWithRange:NSMakeRange(0, 16)] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                        }
                        
                        
                        return cell;
                    }
                }

            }
        }else if (self.step == 2){
            self.secondCircle.backgroundColor = UURED;
            self.secondLab.textColor = UURED;
            self.firstLineLab.backgroundColor = UURED;
            if (indexPath.section == 0) {
                UITableViewCell *cell = [[UITableViewCell alloc]init];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIImageView *leftIV = [[UIImageView alloc]init];
                [cell addSubview:leftIV];
                [leftIV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(cell.mas_left).mas_offset(20);
                    make.top.mas_equalTo(cell.mas_top).mas_offset(11);
                    make.height.and.width.mas_equalTo(38);
                }];
                leftIV.image = [UIImage imageNamed:@"iconfontZhuyi"];
                UILabel *titleLab = [[UILabel alloc]init];
                [cell addSubview:titleLab];
                [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(leftIV.mas_right).mas_offset(8.6);
                    make.top.mas_equalTo(cell.mas_top).mas_offset(18);
                    make.height.mas_equalTo(24);
                    make.width.mas_equalTo(200);
                }];
                titleLab.font = [UIFont fontWithName:TITLEFONTNAME size:16.8];
                titleLab.textColor = UUBLACK;
                titleLab.text = @"等待商家处理退款申请";
                
                UILabel *detailLab = [[UILabel alloc]init];
                [cell addSubview:detailLab];
                [detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.mas_equalTo(titleLab.mas_leading);
                    make.top.mas_equalTo(titleLab.mas_bottom).offset(5);
                    make.right.mas_equalTo(cell.mas_right).offset(-10);
                }];
                
                detailLab.font = [UIFont systemFontOfSize:11.5*SCALE_WIDTH];
                detailLab.textColor = UUGREY;
                detailLab.numberOfLines = 0;
                detailLab.text = @"如果商家同意，退货申请将达成并需要您退货给商家\n如果商家拒绝，将需要您修改退货申请\n如果7天内商家未处理，退货申请将达成并需要您退货给商家";
                return cell;
                
            }else{
                if (indexPath.row == 0) {
                    UUGoodsOrderTableViewCell *cell = [UUGoodsOrderTableViewCell cellWithTableView:self.tableView];
                    UIImageView *goodImg = [[UIImageView alloc]init];
                    [cell addSubview:goodImg];
                    [goodImg mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(cell.mas_left).mas_offset(12.5);
                        make.top.mas_equalTo(cell.mas_top).mas_offset(3.5);
                        make.height.and.width.mas_equalTo(100);
                    }];
                    [goodImg sd_setImageWithURL:[NSURL URLWithString:_returnDetailModel.ImageUrl]];
                    cell.goodsNameLab.text = _returnDetailModel.GoodsName;
                    cell.attrNameLab.text = _returnDetailModel.GoodsAttrName;
                    cell.rightBtn.hidden = YES;
                    cell.goodsNumLab.text = [NSString stringWithFormat:@"x%ld",_returnDetailModel.GoodsNum];
                    cell.priceLab1.text = [NSString stringWithFormat:@""];
                    cell.priceLab4.hidden = YES;
                    cell.lineLab.hidden = YES;
                    cell.priceLab2.text = [NSString stringWithFormat:@"￥%.2f",_returnDetailModel.StrikePrice];
                    return cell;
                }else{
                    UITableViewCell *cell = [[UITableViewCell alloc]init];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    UILabel *titleLab = [[UILabel alloc]init];
                    [cell addSubview:titleLab];
                    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(cell.mas_top).mas_offset(8.5);
                        make.left.mas_equalTo(cell.mas_left).mas_offset(12.5);
                        make.width.mas_equalTo(65);
                        make.height.mas_equalTo(13.5);
                    }];
                    titleLab.font = [UIFont fontWithName:TITLEFONTNAME size:13];
                    titleLab.textColor = [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1];
                    NSArray *titleArr = @[@"订单号",@"快递运费",@"总计",@"成交时间"];
                    titleLab.text = titleArr[indexPath.row-1];
                    UILabel *rightLab = [[UILabel alloc]init];
                    [cell addSubview:rightLab];
                    [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(cell.mas_top).mas_offset(7);
                        make.left.mas_equalTo(titleLab.mas_right).mas_offset(5);
                        make.right.mas_equalTo(cell.mas_right).mas_offset(-13.5);
                        make.height.mas_equalTo(13.5);
                    }];
                    rightLab.font = [UIFont fontWithName:TITLEFONTNAME size:13];
                    rightLab.textColor = UUBLACK;
                    rightLab.textAlignment = NSTextAlignmentRight;
                    if (indexPath.row == 1) {
                        rightLab.text = self.returnDetailModel.OrderNO;
                    }else if (indexPath.row == 2){
                        rightLab.text = [NSString stringWithFormat:@"%ld元",self.returnDetailModel.ShippingFee];
                    }else if (indexPath.row == 3){
                        rightLab.text = [NSString stringWithFormat:@"%.1f元",self.returnDetailModel.OrderTotalMoney];
                    }else{
                        rightLab.text = [[self.returnDetailModel.PayTime substringWithRange:NSMakeRange(0, 16)] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                    }
                    
                    
                    return cell;
                }
            }
            
        }else if (self.step == 3){
            _RefoundId = _returnDetailModel.RefoundId;
            if (indexPath.section == 0) {
                UITableViewCell *cell = [[UITableViewCell alloc]init];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIImageView *leftIV = [[UIImageView alloc]init];
                [cell addSubview:leftIV];
                [leftIV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(cell.mas_left).mas_offset(20);
                    make.top.mas_equalTo(cell.mas_top).mas_offset(11);
                    make.height.and.width.mas_equalTo(38);
                }];
                leftIV.image = [UIImage imageNamed:@"iconfontZhuyi"];
                UILabel *titleLab = [[UILabel alloc]init];
                [cell addSubview:titleLab];
                [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(leftIV.mas_right).mas_offset(8.6);
                    make.top.mas_equalTo(cell.mas_top).mas_offset(18);
                    make.height.mas_equalTo(24);
                    make.width.mas_equalTo(200);
                }];
                titleLab.font = [UIFont fontWithName:TITLEFONTNAME size:16.8];
                titleLab.textColor = UUBLACK;
                titleLab.text = @"请退货并填写物流信息";
                
                UILabel *detailLab = [[UILabel alloc]init];
                [cell addSubview:detailLab];
                [detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(titleLab.mas_top).mas_offset(2);
                    make.left.mas_equalTo(cell.mas_left).mas_offset(59);
                    make.height.mas_equalTo(129);
                    make.right.mas_equalTo(cell.mas_right).mas_offset(-10);
                }];
                
                detailLab.textColor = UUBLACK;
                detailLab.font = [UIFont fontWithName:TITLEFONTNAME size:12];
                detailLab.numberOfLines = 0;
                detailLab.text = @"退货地址：浙江省 金华市 虽城区 一二三大道23号（张三 收）123781230123\n退货说明：请在退货包裹内留下纸条，协商退款编号，您的宝库会员以及联系方式，一边及时确认完成退款。\n宝库温馨提醒：未经卖家同意，请不要使用到付或平邮。\n建议的欠款还在宝库中间账户，确保您资金安全\n请填写真实退货物流信息，逾期未填写，退货申请将关闭";
                return cell;
                
                
            }else if (indexPath.section == 1){
                if (indexPath.row == 1){
                    UITableViewCell *cell = [[UITableViewCell alloc]init];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    UILabel *starLab = [[UILabel alloc]init];
                    [cell addSubview:starLab];
                    [starLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(cell.mas_left).mas_offset(9);
                        make.height.mas_equalTo(10);
                        make.top.mas_equalTo(cell.mas_top).mas_offset(22.5);
                        make.width.mas_equalTo(10);
                    }];
                    starLab.text = @"*";
                    starLab.textColor = UURED;
                    starLab.font = [UIFont systemFontOfSize:15];
                    UILabel *leftLab = [[UILabel alloc]init];
                    [cell addSubview:leftLab];
                    [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(cell.mas_left).mas_offset(22);
                        make.height.mas_equalTo(21);
                        make.top.mas_equalTo(cell.mas_top).mas_offset(14.5);
                        make.width.mas_equalTo(80);
                    }];
                    leftLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
                    leftLab.textAlignment = NSTextAlignmentLeft;
                    leftLab.textColor = UUBLACK;
                    leftLab.text = @"物流公司";
                    UITextField *expressName = [[UITextField alloc]init];
                    [cell addSubview:expressName];
                    [expressName mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.mas_equalTo(cell.mas_right).mas_offset(-22.5);
                        make.height.mas_equalTo(21);
                        make.top.mas_equalTo(cell.mas_top).mas_offset(14.5);
                        make.right.mas_equalTo(leftLab.mas_right).mas_offset(20);
                    }];
                    expressName.borderStyle = UITextBorderStyleNone;
                    expressName.font = [UIFont fontWithName:TITLEFONTNAME size:15];
                    expressName.textAlignment = NSTextAlignmentLeft;
                    expressName.placeholder = @"请填写物流公司名称";
                    expressName.delegate = self;
                    _expressNameTF = expressName;

                    return cell;
                }else if (indexPath.row == 2){
                    UITableViewCell *cell = [[UITableViewCell alloc]init];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    UILabel *starLab = [[UILabel alloc]init];
                    [cell addSubview:starLab];
                    [starLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(cell.mas_left).mas_offset(9);
                        make.height.mas_equalTo(10);
                        make.top.mas_equalTo(cell.mas_top).mas_offset(22.5);
                        make.width.mas_equalTo(10);
                    }];
                    starLab.text = @"*";
                    starLab.textColor = UURED;
                    starLab.font = [UIFont systemFontOfSize:15];
                    UILabel *leftLab = [[UILabel alloc]init];
                    [cell addSubview:leftLab];
                    [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(cell.mas_left).mas_offset(22);
                        make.height.mas_equalTo(21);
                        make.top.mas_equalTo(cell.mas_top).mas_offset(14.5);
                        make.width.mas_equalTo(80);
                    }];
                    leftLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
                    leftLab.textAlignment = NSTextAlignmentLeft;
                    leftLab.textColor = UUBLACK;
                    leftLab.text = @"物流单号";
                    UITextField *expressNum = [[UITextField alloc]init];
                    [cell addSubview:expressNum];
                    [expressNum mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.mas_equalTo(cell.mas_right).mas_offset(-22.5);
                        make.height.mas_equalTo(21);
                        make.top.mas_equalTo(cell.mas_top).mas_offset(14.5);
                        make.right.mas_equalTo(leftLab.mas_right).mas_offset(20);
                    }];
                    expressNum.borderStyle = UITextBorderStyleNone;
                    expressNum.font = [UIFont fontWithName:TITLEFONTNAME size:15];
                    expressNum.textAlignment = NSTextAlignmentLeft;
                    expressNum.placeholder = @"请填写物流单号";
                    expressNum.delegate = self;
                    _expressNumTF = expressNum;
                    return cell;
                }else if (indexPath.row == 3){
                    UITableViewCell *cell = [[UITableViewCell alloc]init];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    UILabel *starLab = [[UILabel alloc]init];
                    [cell addSubview:starLab];
                    [starLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(cell.mas_left).mas_offset(9);
                        make.height.mas_equalTo(10);
                        make.top.mas_equalTo(cell.mas_top).mas_offset(22.5);
                        make.width.mas_equalTo(10);
                    }];
                    starLab.text = @"*";
                    starLab.textColor = UURED;
                    starLab.font = [UIFont systemFontOfSize:15];
                    UILabel *leftLab = [[UILabel alloc]init];
                    [cell addSubview:leftLab];
                    [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(cell.mas_left).mas_offset(22);
                        make.height.mas_equalTo(21);
                        make.top.mas_equalTo(cell.mas_top).mas_offset(14.5);
                        make.width.mas_equalTo(80);
                    }];
                    leftLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
                    leftLab.textAlignment = NSTextAlignmentLeft;
                    leftLab.textColor = UUBLACK;
                    leftLab.text = @"退款说明";
                    
                    UITextView *returnReason = [[UITextView alloc]init];
                    [cell addSubview:returnReason];
                    [returnReason mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(cell.mas_left).mas_offset(22);
                        make.top.mas_equalTo(leftLab.mas_bottom).mas_offset(11.5);
                        make.width.mas_equalTo(self.view.frame.size.width - 22*2);
                        make.bottom.mas_equalTo(cell.mas_bottom).mas_offset(-5);
                    }];
                    returnReason.text = @"请输入退款说明";
                    returnReason.textColor = UUGREY;
                    return cell;
                }else{
                    UITableViewCell *cell = [[UITableViewCell alloc]init];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    UILabel *starLab = [[UILabel alloc]init];
                    [cell addSubview:starLab];
                    [starLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(cell.mas_left).mas_offset(9);
                        make.height.mas_equalTo(10);
                        make.top.mas_equalTo(cell.mas_top).mas_offset(22.5);
                        make.width.mas_equalTo(10);
                    }];
                    starLab.text = @"*";
                    starLab.textColor = UURED;
                    starLab.font = [UIFont systemFontOfSize:15];
                    UILabel *leftLab = [[UILabel alloc]init];
                    [cell addSubview:leftLab];
                    [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(cell.mas_left).mas_offset(22);
                        make.height.mas_equalTo(21);
                        make.top.mas_equalTo(cell.mas_top).mas_offset(14.5);
                        make.width.mas_equalTo(80);
                    }];
                    leftLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
                    leftLab.textAlignment = NSTextAlignmentLeft;
                    leftLab.textColor = UUBLACK;
                    leftLab.text = @"上传凭证";
                    
                    CGFloat imgWidth = (self.view.width - 13*2 - 20*2)/3.0;
                    for (int i = 0; i < _imageArray.count+1; i++) {
                        UIImageView *certificateIV1 = [[UIImageView alloc]initWithFrame:CGRectMake(13 +(20+imgWidth)*(i%3), 45.5 + (10+imgWidth)*(i/3), imgWidth, imgWidth)];
                        [cell addSubview:certificateIV1];
                        if (i <_imageArray.count) {
                            certificateIV1.image = _imageArray[i];
                        }else{
                            certificateIV1.image = [UIImage imageNamed:@"rectangle30Copy3"];
                            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(upLoadCertification)];
                            certificateIV1.userInteractionEnabled = YES;
                            [certificateIV1 addGestureRecognizer:tap];
                        }
                        
                    }
                    return cell;
                }
            }else{
                if (indexPath.row == 0) {
                    UUGoodsOrderTableViewCell *cell = [UUGoodsOrderTableViewCell cellWithTableView:self.tableView];
                    UIImageView *goodImg = [[UIImageView alloc]init];
                    [cell addSubview:goodImg];
                    [goodImg mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(cell.mas_left).mas_offset(12.5);
                        make.top.mas_equalTo(cell.mas_top).mas_offset(3.5);
                        make.height.and.width.mas_equalTo(100);
                    }];
                    [goodImg sd_setImageWithURL:[NSURL URLWithString:_returnDetailModel.ImageUrl]];
                    cell.goodsNameLab.text = _returnDetailModel.GoodsName;
                    cell.attrNameLab.text = _returnDetailModel.GoodsAttrName;
                    cell.rightBtn.hidden = YES;
                    cell.goodsNumLab.text = [NSString stringWithFormat:@"x%ld",_returnDetailModel.GoodsNum];
                    cell.priceLab1.text = [NSString stringWithFormat:@""];
                    cell.priceLab4.hidden = YES;
                    cell.lineLab.hidden = YES;
                    cell.priceLab2.text = [NSString stringWithFormat:@"￥%.2f",_returnDetailModel.StrikePrice];
                    
                    return cell;
                }else{
                    UITableViewCell *cell = [[UITableViewCell alloc]init];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    UILabel *titleLab = [[UILabel alloc]init];
                    [cell addSubview:titleLab];
                    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(cell.mas_top).mas_offset(8.5);
                        make.left.mas_equalTo(cell.mas_left).mas_offset(12.5);
                        make.width.mas_equalTo(65);
                        make.height.mas_equalTo(13.5);
                    }];
                    titleLab.font = [UIFont fontWithName:TITLEFONTNAME size:13];
                    titleLab.textColor = [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1];
                    NSArray *titleArr = @[@"退款类型",@"退款金额",@"退款原因",@"退款编号"];
                    titleLab.text = titleArr[indexPath.row-1];
                    UILabel *rightLab = [[UILabel alloc]init];
                    [cell addSubview:rightLab];
                    [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(cell.mas_top).mas_offset(7);
                        make.left.mas_equalTo(titleLab.mas_right).mas_offset(5);
                        make.right.mas_equalTo(cell.mas_right).mas_offset(-13.5);
                        make.height.mas_equalTo(13.5);
                    }];
                    rightLab.font = [UIFont fontWithName:TITLEFONTNAME size:13];
                    rightLab.textColor = UUBLACK;
                    rightLab.textAlignment = NSTextAlignmentRight;
                    if (indexPath.row == 1) {
                        rightLab.textColor = UURED;
                        if (_returnDetailModel.RefoundType == 0) {
                            rightLab.text = @"退款";
                        }else{
                            rightLab.text = @"退货退款";
                        }
                        
                    }else if (indexPath.row == 2){
                        rightLab.textColor = UURED;
                        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.2f元",_returnDetailModel.RefundMoney]];
                        [str addAttribute:NSForegroundColorAttributeName value:UUBLACK range:NSMakeRange(str.length -1, 1)];
                        rightLab.attributedText = str;
                    }else if (indexPath.row == 3){
                        rightLab.text = _returnDetailModel.RefundReason;
                    }else{
                        rightLab.text = [NSString stringWithFormat:@"%ld",_returnDetailModel.Skuid];

                    }
                    
                    return cell;
                }
            }
        }else if (self.step == -1){
            if (indexPath.section == 0) {
                UITableViewCell *cell = [[UITableViewCell alloc]init];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIImageView *leftIV = [[UIImageView alloc]init];
                [cell addSubview:leftIV];
                [leftIV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(cell.mas_left).mas_offset(20);
                    make.top.mas_equalTo(cell.mas_top).mas_offset(11);
                    make.height.and.width.mas_equalTo(38);
                }];
                leftIV.image = [UIImage imageNamed:@"iconfontZhuyi"];
                UILabel *titleLab = [[UILabel alloc]init];
                [cell addSubview:titleLab];
                [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(leftIV.mas_right).mas_offset(8.6);
                    make.top.mas_equalTo(cell.mas_top).mas_offset(18);
                    make.height.mas_equalTo(24);
                    make.width.mas_equalTo(200);
                }];
                titleLab.font = [UIFont fontWithName:TITLEFONTNAME size:16.8];
                titleLab.textColor = UUBLACK;
                titleLab.text = @"等待商家收货";
                return cell;
                
            }else{
                if (indexPath.row == 0) {
                    UUGoodsOrderTableViewCell *cell = [UUGoodsOrderTableViewCell cellWithTableView:self.tableView];
                    UIImageView *goodImg = [[UIImageView alloc]init];
                    [cell addSubview:goodImg];
                    [goodImg mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(cell.mas_left).mas_offset(12.5);
                        make.top.mas_equalTo(cell.mas_top).mas_offset(3.5);
                        make.height.and.width.mas_equalTo(100);
                    }];
                    [goodImg sd_setImageWithURL:[NSURL URLWithString:_returnDetailModel.ImageUrl]];
                    cell.goodsNameLab.text = _returnDetailModel.GoodsName;
                    cell.attrNameLab.text = _returnDetailModel.GoodsAttrName;
                    cell.rightBtn.hidden = YES;
                    cell.goodsNumLab.text = [NSString stringWithFormat:@"x%ld",_returnDetailModel.GoodsNum];
                    cell.priceLab1.text = [NSString stringWithFormat:@""];
                    cell.priceLab4.hidden = YES;
                    cell.lineLab.hidden = YES;
                    cell.priceLab2.text = [NSString stringWithFormat:@"￥%.2f",_returnDetailModel.StrikePrice];
                    
                    return cell;
                }else{
                    UITableViewCell *cell = [[UITableViewCell alloc]init];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    UILabel *titleLab = [[UILabel alloc]init];
                    [cell addSubview:titleLab];
                    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(cell.mas_top).mas_offset(8.5);
                        make.left.mas_equalTo(cell.mas_left).mas_offset(12.5);
                        make.width.mas_equalTo(65);
                        make.height.mas_equalTo(13.5);
                    }];
                    titleLab.font = [UIFont fontWithName:TITLEFONTNAME size:13];
                    titleLab.textColor = [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1];
                    NSArray *titleArr = @[@"退款类型",@"退款金额",@"退款原因",@"退款编号"];
                    titleLab.text = titleArr[indexPath.row-1];
                    UILabel *rightLab = [[UILabel alloc]init];
                    [cell addSubview:rightLab];
                    [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(cell.mas_top).mas_offset(7);
                        make.left.mas_equalTo(titleLab.mas_right).mas_offset(5);
                        make.right.mas_equalTo(cell.mas_right).mas_offset(-13.5);
                        make.height.mas_equalTo(13.5);
                    }];
                    rightLab.font = [UIFont fontWithName:TITLEFONTNAME size:13];
                    rightLab.textColor = UUBLACK;
                    rightLab.textAlignment = NSTextAlignmentRight;
                    if (indexPath.row == 1) {
                        rightLab.textColor = UURED;
                        if (_returnDetailModel.RefoundType == 0) {
                            rightLab.text = @"退款";
                        }else{
                            rightLab.text = @"退货退款";
                        }
                        
                    }else if (indexPath.row == 2){
                        rightLab.textColor = UURED;
                        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.2f元",_returnDetailModel.RefundMoney]];
                        [str addAttribute:NSForegroundColorAttributeName value:UUBLACK range:NSMakeRange(str.length -1, 1)];
                        rightLab.attributedText = str;
                    }else if (indexPath.row == 3){
                        rightLab.text = _returnDetailModel.RefundReason;
                    }else{
                        rightLab.text = [NSString stringWithFormat:@"%ld",_returnDetailModel.Skuid];

                    }
                    
                    return cell;
                }
            }

        }
        else{
            if (indexPath.section == 0) {
                UITableViewCell *cell = [[UITableViewCell alloc]init];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIImageView *imgV = [[UIImageView alloc]init];
                [cell addSubview:imgV];
                [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(cell.mas_top).mas_offset(22);
                    make.centerX.mas_equalTo(cell.mas_centerX);
                    make.height.and.width.mas_equalTo(59.5);
                }];
                imgV.image = [UIImage imageNamed:@"完成"];
                
                UILabel *successLabel = [[UILabel alloc]init];
                [cell addSubview:successLabel];
                [successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(imgV.mas_bottom).mas_offset(16);
                    make.centerX.mas_equalTo(cell.mas_centerX);
                    make.width.mas_equalTo(80);
                    make.height.mas_equalTo(22.5);
                }];
                successLabel.textColor = [UIColor colorWithRed:121/255.0 green:203/255.0 blue:79/255.0 alpha:1];
                successLabel.font = [UIFont fontWithName:TITLEFONTNAME size:16];
                successLabel.text = @"退款成功！";
                successLabel.textAlignment = NSTextAlignmentCenter;
                
                UILabel *returnAmountLab = [[UILabel alloc]init];
                [cell addSubview:returnAmountLab];
                [returnAmountLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(successLabel.mas_bottom);
                    make.centerX.mas_equalTo(cell.mas_centerX);
                    make.width.mas_equalTo(130);
                    make.height.mas_equalTo(21);
                }];
                returnAmountLab.textColor = UURED;
                returnAmountLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"退款金额：%.2f元",_returnDetailModel.RefundMoney]];
                [str addAttribute:NSForegroundColorAttributeName value:UUBLACK range:NSMakeRange(0, 5)];
                [str addAttribute:NSForegroundColorAttributeName value:UUBLACK range:NSMakeRange(str.length -1, 1)];
                returnAmountLab.textAlignment = NSTextAlignmentCenter;
                returnAmountLab.attributedText = str;
                UIView *backView = [[UIView alloc]init];
                [cell addSubview:backView];
                [backView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(returnAmountLab.mas_bottom).mas_offset(24);
                    make.left.mas_equalTo(cell.mas_left);
                    make.width.mas_equalTo(self.view.width);
                    make.height.mas_equalTo(35);
                }];
                backView.backgroundColor = UURED;
                UILabel *lineLab1 = [[UILabel alloc]init];
                [backView addSubview:lineLab1];
                [lineLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(backView.mas_top);
                    make.left.mas_equalTo(cell.mas_left).mas_offset(50.5);
                    make.width.mas_equalTo(0.5);
                    make.height.mas_equalTo(35);
                }];
                lineLab1.backgroundColor = [UIColor whiteColor];
                UILabel *lineLab2 = [[UILabel alloc]init];
                [backView addSubview:lineLab2];
                [lineLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(backView.mas_top);
                    make.left.mas_equalTo(lineLab1.mas_left).mas_offset(75.5);
                    make.width.mas_equalTo(0.5);
                    make.height.mas_equalTo(35);
                }];
                lineLab2.backgroundColor = [UIColor whiteColor];
                
                UILabel *lineLab3 = [[UILabel alloc]init];
                [backView addSubview:lineLab3];
                [lineLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(backView.mas_top);
                    make.left.mas_equalTo(lineLab2.mas_left).mas_offset(75.5);
                    make.width.mas_equalTo(0.5);
                    make.height.mas_equalTo(35);
                }];
                lineLab3.backgroundColor = [UIColor whiteColor];
                
                UILabel *NoLab = [[UILabel alloc]init];
                [backView addSubview:NoLab];
                [NoLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(backView.mas_top).mas_offset(12);
                    make.left.mas_equalTo(cell.mas_left);
                    make.width.mas_equalTo(50.5);
                    make.height.mas_equalTo(13);
                }];
                NoLab.textColor = [UIColor whiteColor];
                NoLab.textAlignment = NSTextAlignmentCenter;
                NoLab.font = [UIFont fontWithName:TITLEFONTNAME size:13];
                NoLab.text = @"序号";
                UILabel *detailLab = [[UILabel alloc]init];
                [backView addSubview:detailLab];
                [detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(backView.mas_top).mas_offset(12);
                    make.left.mas_equalTo(lineLab1.mas_right);
                    make.width.mas_equalTo(74.5);
                    make.height.mas_equalTo(13);
                }];
                detailLab.textColor = [UIColor whiteColor];
                detailLab.textAlignment = NSTextAlignmentCenter;
                detailLab.font = [UIFont fontWithName:TITLEFONTNAME size:13];
                detailLab.text = @"退款明细";
                
                UILabel *amountLab = [[UILabel alloc]init];
                [backView addSubview:amountLab];
                [amountLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(backView.mas_top).mas_offset(12);
                    make.left.mas_equalTo(lineLab2.mas_right);
                    make.width.mas_equalTo(74.5);
                    make.height.mas_equalTo(13);
                }];
                amountLab.textColor = [UIColor whiteColor];
                amountLab.textAlignment = NSTextAlignmentCenter;
                amountLab.font = [UIFont fontWithName:TITLEFONTNAME size:13];
                amountLab.text = @"金额";
                
                UILabel *statusLab = [[UILabel alloc]init];
                [backView addSubview:statusLab];
                [statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(backView.mas_top).mas_offset(12);
                    make.left.mas_equalTo(lineLab3.mas_right);
                    make.right.mas_equalTo(backView.mas_right);
                    make.height.mas_equalTo(13);
                }];
                statusLab.textColor = [UIColor whiteColor];
                statusLab.textAlignment = NSTextAlignmentCenter;
                statusLab.font = [UIFont fontWithName:TITLEFONTNAME size:13];
                statusLab.text = @"状态";
                
                UILabel *No1Lab = [[UILabel alloc]init];
                [cell addSubview:No1Lab];
                [No1Lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(backView.mas_bottom).mas_offset(11.5);
                    make.left.mas_equalTo(cell.mas_left);
                    make.width.mas_equalTo(50.5);
                    make.height.mas_equalTo(12);
                }];
                No1Lab.textColor = UUGREY;
                No1Lab.textAlignment = NSTextAlignmentCenter;
                No1Lab.font = [UIFont fontWithName:TITLEFONTNAME size:12];
                No1Lab.text = @"1";
                UILabel *detail1Lab = [[UILabel alloc]init];
                [cell addSubview:detail1Lab];
                [detail1Lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(backView.mas_bottom).mas_offset(11.5);
                    make.left.mas_equalTo(No1Lab.mas_right);
                    make.width.mas_equalTo(74.5);
                    make.height.mas_equalTo(12);
                }];
                detail1Lab.textColor = UUGREY;
                detail1Lab.textAlignment = NSTextAlignmentCenter;
                detail1Lab.font = [UIFont fontWithName:TITLEFONTNAME size:12];
                detail1Lab.text = @"退回我的金额";
                
                UILabel *amount1Lab = [[UILabel alloc]init];
                [cell addSubview:amount1Lab];
                [amount1Lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(backView.mas_bottom).mas_offset(11.5);
                    make.left.mas_equalTo(detail1Lab.mas_right);
                    make.width.mas_equalTo(74.5);
                    make.height.mas_equalTo(12);
                }];
                amount1Lab.textColor = UUGREY;
                amount1Lab.textAlignment = NSTextAlignmentCenter;
                amount1Lab.font = [UIFont fontWithName:TITLEFONTNAME size:12];
                amount1Lab.text = [NSString stringWithFormat:@"%.2f元",_returnDetailModel.ReturnBalance];
                
                UILabel *status1Lab = [[UILabel alloc]init];
                [cell addSubview:status1Lab];
                [status1Lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(backView.mas_bottom).mas_offset(11.5);
                    make.left.mas_equalTo(amount1Lab.mas_right);
                    make.right.mas_equalTo(backView.mas_right);
                    make.height.mas_equalTo(12);
                }];
                status1Lab.textColor = UUGREY;
                status1Lab.textAlignment = NSTextAlignmentCenter;
                status1Lab.font = [UIFont fontWithName:TITLEFONTNAME size:12];
                status1Lab.text = @"已退回我的金额";
                
                UILabel *No2Lab = [[UILabel alloc]init];
                [cell addSubview:No2Lab];
                [No2Lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(backView.mas_bottom).mas_offset(39);
                    make.left.mas_equalTo(cell.mas_left);
                    make.width.mas_equalTo(50.5);
                    make.height.mas_equalTo(12);
                }];
                No2Lab.textColor = UUGREY;
                No2Lab.textAlignment = NSTextAlignmentCenter;
                No2Lab.font = [UIFont fontWithName:TITLEFONTNAME size:12];
                No2Lab.text = @"2";
                UILabel *detail2Lab = [[UILabel alloc]init];
                [cell addSubview:detail2Lab];
                [detail2Lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(backView.mas_bottom).mas_offset(39);
                    make.left.mas_equalTo(No1Lab.mas_right);
                    make.width.mas_equalTo(74.5);
                    make.height.mas_equalTo(12);
                }];
                detail2Lab.textColor = UUGREY;
                detail2Lab.textAlignment = NSTextAlignmentCenter;
                detail2Lab.font = [UIFont fontWithName:TITLEFONTNAME size:12];
                detail2Lab.text = @"退回我的库币";
                
                UILabel *amount2Lab = [[UILabel alloc]init];
                [cell addSubview:amount2Lab];
                [amount2Lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(backView.mas_bottom).mas_offset(39);
                    make.left.mas_equalTo(detail1Lab.mas_right);
                    make.width.mas_equalTo(74.5);
                    make.height.mas_equalTo(12);
                }];
                amount2Lab.textColor = UUGREY;
                amount2Lab.textAlignment = NSTextAlignmentCenter;
                amount2Lab.font = [UIFont fontWithName:TITLEFONTNAME size:12];
                amount2Lab.text = [NSString stringWithFormat:@"%.0f库币",_returnDetailModel.ReturnIntegral];;
                
                UILabel *status2Lab = [[UILabel alloc]init];
                [cell addSubview:status2Lab];
                [status2Lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(backView.mas_bottom).mas_offset(39);
                    make.left.mas_equalTo(amount1Lab.mas_right);
                    make.right.mas_equalTo(backView.mas_right);
                    make.height.mas_equalTo(12);
                }];
                status2Lab.textColor = UUGREY;
                status2Lab.textAlignment = NSTextAlignmentCenter;
                status2Lab.font = [UIFont fontWithName:TITLEFONTNAME size:12];
                status2Lab.text = @"已退回我的库币";
                return cell;
            }else if (indexPath.section == 1){
                if (indexPath.row == 0) {
                    UUGoodsOrderTableViewCell *cell = [UUGoodsOrderTableViewCell cellWithTableView:self.tableView];
                    UIImageView *goodImg = [[UIImageView alloc]init];
                    [cell addSubview:goodImg];
                    [goodImg mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(cell.mas_left).mas_offset(12.5);
                        make.top.mas_equalTo(cell.mas_top).mas_offset(3.5);
                        make.height.and.width.mas_equalTo(100);
                    }];
                    [goodImg sd_setImageWithURL:[NSURL URLWithString:_returnDetailModel.ImageUrl]];
                    cell.goodsNameLab.text = _returnDetailModel.GoodsName;
                    cell.attrNameLab.text = _returnDetailModel.GoodsAttrName;
                    cell.rightBtn.hidden = YES;
                    cell.goodsNumLab.text = [NSString stringWithFormat:@"x%ld",_returnDetailModel.GoodsNum];
                    cell.priceLab1.text = [NSString stringWithFormat:@""];
                    cell.priceLab4.hidden = YES;
                    cell.lineLab.hidden = YES;
                    cell.priceLab2.text = [NSString stringWithFormat:@"￥%.2f",_returnDetailModel.StrikePrice];
                    
                    return cell;
                }else{
                    UITableViewCell *cell = [[UITableViewCell alloc]init];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    UILabel *titleLab = [[UILabel alloc]init];
                    [cell addSubview:titleLab];
                    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(cell.mas_top).mas_offset(8.5);
                        make.left.mas_equalTo(cell.mas_left).mas_offset(12.5);
                        make.width.mas_equalTo(65);
                        make.height.mas_equalTo(13.5);
                    }];
                    titleLab.font = [UIFont fontWithName:TITLEFONTNAME size:13];
                    titleLab.textColor = [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1];
                    NSArray *titleArr = @[@"退款类型",@"退款金额",@"退款原因",@"退款编号"];
                    titleLab.text = titleArr[indexPath.row-1];
                    UILabel *rightLab = [[UILabel alloc]init];
                    [cell addSubview:rightLab];
                    [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(cell.mas_top).mas_offset(7);
                        make.left.mas_equalTo(titleLab.mas_right).mas_offset(5);
                        make.right.mas_equalTo(cell.mas_right).mas_offset(-13.5);
                        make.height.mas_equalTo(13.5);
                    }];
                    rightLab.font = [UIFont fontWithName:TITLEFONTNAME size:13];
                    rightLab.textColor = UUBLACK;
                    rightLab.textAlignment = NSTextAlignmentRight;
                    if (indexPath.row == 1) {
                        rightLab.textColor = UURED;
                        if (_returnDetailModel.RefoundType == 0) {
                            rightLab.text = @"退款";
                        }else{
                            rightLab.text = @"退货退款";
                        }
                        
                    }else if (indexPath.row == 2){
                        rightLab.textColor = UURED;
                        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.2f元",_returnDetailModel.RefundMoney]];
                        [str addAttribute:NSForegroundColorAttributeName value:UUBLACK range:NSMakeRange(str.length -1, 1)];
                        rightLab.attributedText = str;
                    }else if (indexPath.row == 3){
                        rightLab.text = _returnDetailModel.RefundReason;
                    }else{
                        rightLab.text = [NSString stringWithFormat:@"%ld",_returnDetailModel.Skuid];
                    }
                    
                    return cell;
                }
                
            }else{
                if (indexPath.row==0) {
                    //login
                    UITableViewCell *cell = [[UITableViewCell alloc] init];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    UIImageView *LogoimageView = [[UIImageView alloc] initWithFrame:CGRectMake(17.5, 12.5, 12.8, 15)];
                    [LogoimageView setImage:[UIImage imageNamed:@"iconfont-zanxi"]];
                    [cell addSubview:LogoimageView];
                    //名称
                    UILabel *namelabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 9.5, 60, 21)];
                    namelabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
                    namelabel.text = @"热门推荐";
                    [cell addSubview:namelabel];
                    return cell;
                    
                }else{
                    
                    UITableViewCell *cell = [[UITableViewCell alloc] init];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    cell.backgroundColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1];
                    
                    if (self.guessShopArray != nil && ![self.guessShopArray isKindOfClass:[NSNull class]] && self.guessShopArray.count != 0) {
                        for (int i=0; i<self.guessShopArray.count; i++) {
                            UIView *backView = [[UIView alloc] init];
                            backView.backgroundColor = [UIColor whiteColor];
                            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goGoodsDetailWithGestureRecognizer:)];
                            [backView addGestureRecognizer:tap];
                            backView.tag = i;
                            backView.userInteractionEnabled = YES;

                            if (i%2==0) {
                                backView.frame = CGRectMake(0, i/2*260+1*i/2, self.view.width/2, 260);
                            }else{
                                
                                backView.frame = CGRectMake(self.view.width/2+1, i/2*260+1*i/2, self.view.width/2, 260);
                            }
                            
                            //图片所在的View
                            UIView *imageView = [[UIView alloc] initWithFrame:CGRectMake(18.5, 12, backView.width-18.5*2, backView.width-18.5*2)];
                            //                    imageView.backgroundColor = [UIColor redColor];
                            //图片
                            UIImageView *image = [[UIImageView alloc] initWithFrame:imageView.bounds];
                            [image sd_setImageWithURL:[NSURL URLWithString:[self.guessShopArray[i] valueForKey:@"Images"][0]]];
                            
                            
                            
                            // 价格表单
                            UIView *listView = [[UIView alloc] initWithFrame:CGRectMake(0, 104.5+25, imageView.width, 20.5)];
                            
                            listView.backgroundColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1];
                            
                            //原价
                            UILabel *originalLabel = [[UILabel alloc] initWithFrame:CGRectMake(3.5, 2, 80, 15)];
                            originalLabel.textColor = [UIColor whiteColor];
                            originalLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
                            originalLabel.text = @"原价：¥98";
                            originalLabel.text = [NSString stringWithFormat:@"原价:¥%@",[self.guessShopArray[i] valueForKey:@"BuyPrice"]];
                            [originalLabel sizeToFit];
                            [listView addSubview:originalLabel];
                            UILabel *lineLab = [[UILabel alloc]init];
                            [originalLabel addSubview:lineLab];
                            [lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.mas_equalTo(originalLabel.mas_left);
                                make.centerY.mas_equalTo(originalLabel.mas_centerY);
                                make.height.mas_equalTo(1);
                                make.width.mas_equalTo(originalLabel.mas_width);
                            }];
                            lineLab.backgroundColor = [UIColor whiteColor];
                            //购买数
                            UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(listView.width-75, 2, 75, 15)];
                            numberLabel.textColor = [UIColor whiteColor];
                            numberLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
                            numberLabel.text = @"已有234人购买";
                            numberLabel.text = [NSString stringWithFormat:@"已有%@人购买",[self.guessShopArray[i] valueForKey:@"GoodsSaleNum"]];
                            [listView addSubview:numberLabel];
                            
                            
                            
                            [imageView addSubview:image];
                            [imageView addSubview:listView];
                            
                            [backView addSubview:imageView];
                            
                            //商品介绍
                            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(18.5, 143+25, 150, 18)];
                            label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.5];
                            label.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
                            label.text = @"商品介绍";
                            label.text =[NSString stringWithFormat:@"%@",[self.guessShopArray[i] valueForKey:@"GoodsName"]];
                            [backView addSubview:label];
                            
                            //采购价
                            UILabel *purchaselabel = [[UILabel alloc] initWithFrame:CGRectMake(18.5, 172+25, 150, 18)];
                            
                            
                            [purchaselabel setTextColor:[UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1]];
                            
                            purchaselabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
                            
                            purchaselabel.text = @"采购价：¥25";
                            purchaselabel.text = [NSString stringWithFormat:@"采购价：¥%@",[self.guessShopArray[i] valueForKey:@"MarketPrice"]];
                            
                            [backView addSubview:purchaselabel];
                            
                            
                            //会员价
                            
                            UILabel *memberlabel = [[UILabel alloc] initWithFrame:CGRectMake(18.5, 187+25, 150, 18)];
                            [memberlabel setTextColor:[UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1]];
                            
                            memberlabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
                            memberlabel.text = @"会员价:¥55";
                            memberlabel.text =[NSString stringWithFormat:@"会员价：¥%@",[self.guessShopArray[i] valueForKey:@"MemberPrice"]];
                            
                            [backView addSubview:memberlabel];
                            
                            //赚库币  按钮
                            
                            UIButton *earnBtn = [[UIButton alloc] initWithFrame:CGRectMake(backView.width-18.5-50, 185+25, 50, 20)];
                            earnBtn.imageEdgeInsets = UIEdgeInsetsMake(4.5, 5, 5, 37.7);
                            earnBtn.titleEdgeInsets =UIEdgeInsetsMake(3, -15, 3, 4.5);
                            
                            [earnBtn setImage:[UIImage imageNamed:@"商城分享按钮"] forState:UIControlStateNormal];
                            [earnBtn setTitle:@"赚库币" forState:UIControlStateNormal];
                            [earnBtn addTarget:self action:@selector(earnKubiAction:) forControlEvents:UIControlStateNormal];
                            [earnBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                            earnBtn.titleLabel.font= [UIFont fontWithName:@"PingFangSC-Regular" size:10];
                            
                            
                            earnBtn.layer.masksToBounds = YES;
                            earnBtn.layer.cornerRadius = 2.5;
                            earnBtn.backgroundColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
                            
                            [backView addSubview:earnBtn];
                            
                            [cell addSubview:backView];
                            
                        }
                        
                        
                    }
                    
                    return cell;
                }
            }
        }
    }
}


- (void)earnKubiAction:(UIButton *)sender{
    [self.view addSubview:self.shareView];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.index == 1) {
        if (self.step == 1||self.step == 2) {
            if (section == 0) {
                return 90;
            }else{
                return 0.1;
            }

        }else{
            return 0.1;
        }
    }else{
        if (self.step == 1||self.step == 2||self.step == 3) {
            return 90;
        }else{
            return 0.1;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.index == 1) {
        if (section == 0) {
            
            UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 70)];
            footView.backgroundColor = BACKGROUNG_COLOR;
            UIButton *applyReturnBtn = [[UIButton alloc]init];
            [footView addSubview:applyReturnBtn];
            [applyReturnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(footView.mas_left).mas_offset(26);
                make.top.mas_equalTo(footView.mas_top).mas_offset(20);
                make.right.mas_equalTo(footView.mas_right).mas_offset(-26);
                make.height.mas_equalTo(50);
            }];
            applyReturnBtn.layer.cornerRadius = 2.5;
            if (self.step == 1) {
                [applyReturnBtn setTitle:@"提交申请退款" forState:UIControlStateNormal];
                [applyReturnBtn addTarget:self action:@selector(handInReturnApplication) forControlEvents:UIControlEventTouchDown];
            }else if (self.step == 2){
                [applyReturnBtn setTitle:@"撤销申请" forState:UIControlStateNormal];
                [applyReturnBtn addTarget:self action:@selector(cancelReturnApplication) forControlEvents:UIControlEventTouchDown];
            }else {
                return nil;
            }
            
            applyReturnBtn.backgroundColor = UURED;
            
            return footView;
        }else{
            return nil;
        }

    }else{
        if (section == 0) {
            
            UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 70)];
            footView.backgroundColor = BACKGROUNG_COLOR;
            UIButton *applyReturnBtn = [[UIButton alloc]init];
            [footView addSubview:applyReturnBtn];
            [applyReturnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(footView.mas_left).mas_offset(26);
                make.top.mas_equalTo(footView.mas_top).mas_offset(20);
                make.right.mas_equalTo(footView.mas_right).mas_offset(-26);
                make.height.mas_equalTo(50);
            }];
            applyReturnBtn.layer.cornerRadius = 2.5;
            applyReturnBtn.backgroundColor = UURED;
            if (self.step == 1) {
                if (self.index == 1) {
                    [applyReturnBtn setTitle:@"提交申请退款" forState:UIControlStateNormal];
                }
                
                if (self.index == 2) {
                    [applyReturnBtn setTitle:@"提交申请退货" forState:UIControlStateNormal];
                }
                [applyReturnBtn addTarget:self action:@selector(handInReturnApplication) forControlEvents:UIControlEventTouchDown];
                return footView;
            }else if (self.step == 2){
                [applyReturnBtn setTitle:@"撤销申请" forState:UIControlStateNormal];
                [applyReturnBtn addTarget:self action:@selector(cancelReturnApplication) forControlEvents:UIControlEventTouchDown];
                return footView;
            }else if (self.step == 3){
                [applyReturnBtn setTitle:@"提交物流信息" forState:UIControlStateNormal];
                [applyReturnBtn addTarget:self action:@selector(handInShippingInfo) forControlEvents:UIControlEventTouchDown];
                return footView;
            }else{
                return nil;
            }
            
        }else{
            return nil;
        }

    }
}

- (void)handInReturnApplication{
   
    if (_index == 1) {
        if (_reasonString.length == 0) {
            [self alertShowWithTitle:nil andDetailTitle:@"请选择退款原因"];
        }else{
            if (!_Explanation) {
                _Explanation = @"";
            }
            if (!_ProofImageUrl) {
                _ProofImageUrl = @"";
            }
            [self handInInfo];
        }
    }else{
        if (_reasonString.length == 0) {
            [self alertShowWithTitle:nil andDetailTitle:@"请选择退款原因"];
        }else if (_ProofImageUrl.length == 0){
            [self alertShowWithTitle:nil andDetailTitle:@"请上传退货凭证"];
        }else if (_Explanation.length == 0){
            [self alertShowWithTitle:nil andDetailTitle:@"请输入退款说明"];
        }else{
            [self handInInfo];
        }
    }
}


- (void)handInInfo{
    NSString *urlStr = [kAString(DOMAIN_NAME, REFOUND_APPLY) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSDictionary *dic = @{@"UserId":UserId,@"SKUID":[NSString stringWithFormat:@"%ld",_SKUID],@"OrderNO":_OrderNO,@"RefoundType":_RefundType,@"RefoundReason":_reasonString,@"GoodsAmount":[NSString stringWithFormat:@"%.2f",_GoodsAmount],@"ShipFee":[NSString stringWithFormat:@"%.2f",_ShipFee],@"Explanation":_Explanation,@"ProofimageUrl":_ProofImageUrl};
    [NetworkTools postReqeustWithParams:dic UrlString:urlStr successBlock:^(id responseObject) {
        [self alertShowWithTitle:nil andDetailTitle:responseObject[@"message"]];
        if ([responseObject[@"code"] isEqualToString:@"000000"]) {
            
            self.step = 2;
            self.firstLineLab.backgroundColor = UURED;
            self.secondLab.textColor = UURED;
            self.secondCircle.backgroundColor = UURED;
            _returnDetailModel = [[UUReturnDetailModel alloc]initWithDictionary:responseObject[@"data"]];
            if ([_RefundType integerValue] == 0) {
                self.index = 1;
                self.step = 2;
            }else if ([_RefundType integerValue] == 1){
                self.index = 2;
                self.step = 2;
            }
            [self.tableView reloadData];
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
    [self.tableView reloadData];

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
}
- (void)cancelReturnApplication{
    NSString *urlStr = [kAString(DOMAIN_NAME, REFOUND_CANCEL) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSDictionary *dict = @{@"UserID":UserId,@"RefoundId":_returnDetailModel.RefoundId};
    [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"000000"]) {
            _isCancel = 1;
            _returnDetailModel = [[UUReturnDetailModel alloc]initWithDictionary:responseObject[@"data"]];
            self.step = 1;
            [self initUIWithType:self.index+2];
        }
    } failureBlock:^(NSError *error) {
        
    }];
    
}

- (void)handInShippingInfo{
    
    if (_expressNumTF.text.length == 0||_expressNameTF.text.length == 0) {
        [self alertShowWithTitle:nil andDetailTitle:@"请填写物流信息"];
    }else{
        NSString *urlStr = [kAString(DOMAIN_NAME, ADD_LOGISTIC_INFO) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        
        NSDictionary *dic = @{@"UserId":UserId,@"RefoundId":_RefoundId,@"ExpressNumber":_expressNameTF.text,@"ExpressNumber":_expressNumTF.text,@"ExpressExplanation":_Explanation,@"WLProofimageUrl":_ProofImageUrl};
        [NetworkTools postReqeustWithParams:dic UrlString:urlStr successBlock:^(id responseObject) {
            [self alertShowWithTitle:nil andDetailTitle:responseObject[@"message"]];
            if ([responseObject[@"code"] isEqualToString:@"000000"]) {
                
                
                _returnDetailModel = [[UUReturnDetailModel alloc]initWithDictionary:responseObject[@"data"]];
                if ([_RefundType integerValue] == 0) {
                    self.index = 1;
                    self.step = 3;
                }else if ([_RefundType integerValue] == 1){
                    self.index = 2;
                    self.step = -1;
                }
                [self initUIWithType:self.index+2];
                [self initHeaderStatus];
                [self.tableView reloadData];
            }
            
        } failureBlock:^(NSError *error) {
            
        }];
        [self.tableView reloadData];
    }
    
}

- (void)initHeaderStatus{
    if (self.step == 1) {
        self.firstLineLab.backgroundColor = UUGREY;
        self.firstLab.textColor = UURED;
        self.firstCircle.backgroundColor = UURED;
    }
    if (self.step == 2) {
        self.firstLineLab.backgroundColor = UURED;
        self.firstLab.textColor = UURED;
        self.firstCircle.backgroundColor = UURED;
        self.secondLab.textColor = UURED;
        self.secondCircle.backgroundColor = UURED;
    }
    
    if (self.step == 3) {
        self.firstLineLab.backgroundColor = UURED;
        self.firstLab.textColor = UURED;
        self.firstCircle.backgroundColor = UURED;
        self.secondLineLab.backgroundColor = UURED;
        self.secondLab.textColor = UURED;
        self.secondCircle.backgroundColor = UURED;
        self.thirdLab.textColor = UURED;
        self.thirdCircle.backgroundColor = UURED;

    }
    if (self.step == -1) {
        self.firstLineLab.backgroundColor = UURED;
        self.firstLab.textColor = UURED;
        self.firstCircle.backgroundColor = UURED;
        self.secondLineLab.backgroundColor = UURED;
        self.secondLab.textColor = UURED;
        self.secondCircle.backgroundColor = UURED;
        self.thirdLab.textColor = UURED;
        self.thirdCircle.backgroundColor = UURED;
    }
    if (self.step == 4) {
        self.firstLineLab.backgroundColor = UURED;
        self.firstLab.textColor = UURED;
        self.firstCircle.backgroundColor = UURED;
        self.secondLineLab.backgroundColor = UURED;
        self.secondLab.textColor = UURED;
        self.secondCircle.backgroundColor = UURED;
        self.thirdLineLab.backgroundColor = UURED;
        self.thirdLab.textColor = UURED;
        self.thirdCircle.backgroundColor = UURED;
        self.forthLab.textColor = UURED;
        self.forthCircle.backgroundColor = UURED;
    }
}
//商城首页  获取数据
-(void)getUUMytreasureData{
    
    NSString *urlStr = [kAString(DOMAIN_NAME, HOT_RECOMMEND_GOODS) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSDictionary *dic = @{@"UserId":UserId,@"PageIndex":@"1",@"PageSize":@"6"};
    
    [NetworkTools postReqeustWithParams:dic UrlString:urlStr successBlock:^(id responseObject) {
        self.guessShopArray = [[responseObject valueForKey:@"data"] valueForKey:@"List"];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:2];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        [self prepareData];
    } failureBlock:^(NSError *error) {
        
    }];
    
}


-  (void)getReturnDetailData{
    NSString *urlStr = [kAString(DOMAIN_NAME, GET_REFOUND_DETAIL) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSDictionary *dic = @{@"UserID":UserId,@"RefoundId":self.RefoundId};
    [NetworkTools postReqeustWithParams:dic UrlString:urlStr successBlock:^(id responseObject) {
        _returnDetailModel = [[UUReturnDetailModel alloc]initWithDictionary:responseObject[@"data"]];
        if (_returnDetailModel.RefoundType == 0) {
            self.index = 1;
            if (self.pushType == 3) {
                self.step = 3;
                [self initUIWithType:3];
            }else if(self.pushType == 1){
                self.step = 1;
                [self initUIWithType:3];

            }else if (self.pushType == 2){
                self.step = 2;
                [self initUIWithType:3];

            }
        }else if (_returnDetailModel.RefoundType == 1){
            
            self.index = 2;
            if (self.pushType == 3) {
                self.step = 4;
            }else if(self.pushType == 1){
                self.step = 1;
            }else if (self.pushType == 2){
                self.step = 2;
            }else if (self.pushType == -1){
                self.step = -1;
            }
            [self initUIWithType:4];
        }
        
        [self initHeaderStatus];
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)getReasonData{
    NSString *urlStr = [kAString(DOMAIN_NAME, GET_REFOUND_REASON) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    [NetworkTools postReqeustWithParams:nil UrlString:urlStr successBlock:^(id responseObject) {
        for (NSDictionary *dict in responseObject[@"data"]) {
            self.reasonModel = [[UURefundReasonModel alloc]initWithDictionary:dict];
            [_reasonDataSource addObject:self.reasonModel];
        }
    } failureBlock:^(NSError *error) {
        
    }];
}
- (UIView *)cover{
    if (!_cover) {
        _cover = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [self.view addSubview:_cover];
        _cover.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        _reasonPicker = [[UIPickerView alloc]init];
        UIView *headerV = [[UIView alloc]init];
        [_cover addSubview:headerV];
        [headerV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_top).mas_offset(self.view.height/2.0);
            make.left.mas_equalTo(self.view.mas_left);
            make.width.mas_equalTo(self.view.width);
            make.height.mas_equalTo(44);
            
        }];
        headerV.backgroundColor = [UIColor whiteColor];
        headerV.userInteractionEnabled = YES;
        UIButton *cancelBtn = [[UIButton alloc]init];
        [headerV addSubview:cancelBtn];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(headerV.mas_top).mas_offset(14);
            make.left.mas_equalTo(headerV.mas_left).mas_offset(20);
            make.height.mas_equalTo(15);
            make.width.mas_equalTo(8.9);
        }];
        [cancelBtn setImage:[UIImage imageNamed:@"白条返回"] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(CancelClick) forControlEvents:UIControlEventTouchDown];
        
        UIButton *doneBtn = [[UIButton alloc]init];
        [headerV addSubview:doneBtn];
        [doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(headerV.mas_top).mas_offset(10);
            make.right.mas_equalTo(headerV.mas_right).mas_offset(-20);
            make.height.mas_equalTo(21);
            make.width.mas_equalTo(60);
        }];
        [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
        [doneBtn setTitleColor:UURED forState:UIControlStateNormal];
        [doneBtn addTarget:self action:@selector(DoneClick) forControlEvents:UIControlEventTouchDown];
        [_cover addSubview:_reasonPicker];
        [_reasonPicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_top).mas_offset(self.view.height/2.0+45);
            make.width.mas_equalTo(self.view.width);
            make.height.mas_equalTo(self.view.height/2.0);
            
        }];
        _reasonPicker.delegate = self;
        _reasonPicker.dataSource = self;
        _reasonPicker.backgroundColor = [UIColor whiteColor];
    }
    return _cover;
}


- (void)CancelClick{
    
    [_cover removeFromSuperview];
    _cover = nil;
}

- (void)DoneClick{
    if (!_reasonString) {
        UURefundReasonModel *model = _reasonDataSource[0];
        _reasonString = model.Label;
        _reasonID = model.ID;
    }
    _reasonLab.text = _reasonString;
    [_reasonPicker removeFromSuperview];
    [_cover removeFromSuperview];
    _cover = nil;
    
}

#pragma pickViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return 300;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _reasonDataSource.count;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    UURefundReasonModel *model = _reasonDataSource[row];
    return model.Label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    UURefundReasonModel *model = _reasonDataSource[row];
    _reasonString = model.Label;
    _reasonID = model.ID;
}

//选择退款原因
- (void)selectReturnReason{
    [self cover];
}

- (void)upLoadCertification{
    [self setIcon];
}
//设置头像的方法
-(void)setIcon{
    // 创建 提示
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"设置头像" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    // 添加按钮
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //            [self presentModalViewController:imagePicker animated:YES];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *loginAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 相册
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //            [self presentModalViewController:imagePicker animated:YES];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *quxiaoAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:quxiaoAction];
    [alertController addAction:loginAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
        NSLog(@"%i",imgNum);
        [self performSelector:@selector(saveImage:)  withObject:img afterDelay:0.5];
        
        
    }
    else if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeMovie]) {
        NSString *videoPath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        //        self.fileData = [NSData dataWithContentsOfFile:videoPath];
    }
    //    [picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //    [picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImage:(UIImage *)image{
    //    NSLog(@"保存头像！");
    //    [userPhotoButton setImage:image forState:UIControlStateNormal];
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
    NSLog(@"imageFile->>%@",imageFilePath);
    success = [fileManager fileExistsAtPath:imageFilePath];
    if(success) {
        success = [fileManager removeItemAtPath:imageFilePath error:&error];
    }
    //    UIImage *smallImage=[self scaleFromImage:image toSize:CGSizeMake(80.0f, 80.0f)];//将图片尺寸改为80*80
    UIImage *smallImage = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(93, 93)];
    [UIImageJPEGRepresentation(smallImage, 1.0f) writeToFile:imageFilePath atomically:YES];//写入文件
    UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];//读取图片文件
    NSLog(@"wenjianlijin%@",imageFilePath);
    NSData *data = [NSData dataWithContentsOfFile:imageFilePath];
    QZHUploadFormData *uploadParams = [[QZHUploadFormData alloc]init];
    uploadParams.data = data;
    uploadParams.name = @"faceImage.jpg";
    uploadParams.fileName = imageFilePath;
    uploadParams.dataType = 3;
    
    [self uploadImageInfoWithDictionary:@{@"Type":@"1",@"File":imageFilePath} andImage:selfPhoto];
    imgNum ++;
    [_imageArray addObject:selfPhoto];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:4 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

//上传图片
- (void)uploadImageInfoWithDictionary:(NSDictionary *)dict andImage:(UIImage *)image{
    NSString *urlStr = [kAString(DOMAIN_NAME, UP_IMG) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    
    NSURLSessionDataTask *task = [manager POST:urlStr parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        
        NSData *imageData =UIImageJPEGRepresentation(image,1);
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat =@"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:imageData
                                    name:@"file"
                                fileName:fileName
                                mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        //打印下上传进度
    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        [self alertShowWithTitle:nil andDetailTitle:responseObject[@"message"]];
        _ProofImageUrl = responseObject[@"data"];
//        //上传成功
//        if (_isFace == 1) {
//            self.CardImg = responseObject[@"data"];
//        }
//        if (_isFace == 2) {
//            self.CardImg2 = responseObject[@"data"];
//        }
        
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        //上传失败
    }];
}

// 改变图像的尺寸，方便上传服务器
- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//2.保持原来的长宽比，生成一个缩略图
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}


#pragma mark textViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    textView.text = @"";
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    _Explanation = textView.text;
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1],UITextAttributeTextColor,nil]];
    self.view.backgroundColor = BACKGROUNG_COLOR;
}

//去商品详情
- (void)goGoodsDetailWithGestureRecognizer:(UITapGestureRecognizer *)tap{
    UIView *view = [tap view];
    UUShopProductDetailsViewController *productDetails =[UUShopProductDetailsViewController new];
    productDetails.isNotActive = 1;
    
    productDetails.GoodsID = self.guessShopArray[view.tag][@"GoodsId"];
    [self.navigationController pushViewController:productDetails animated:YES];
}

- (void)earnAction:(UIButton *)sender{
    [self.view addSubview:self.shareView];
}
@end
