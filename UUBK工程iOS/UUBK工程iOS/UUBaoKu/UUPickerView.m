//
//  UUPickerView.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/19.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUPickerView.h"
#import "UUAddressModel.h"

@interface  UUPickerView()<
UIPickerViewDelegate,
UIPickerViewDataSource>

@property (nonatomic,strong)UIPickerView *pickerView;
@property (nonatomic,strong)NSString *response;
@property (nonatomic,strong)UUAddressModel *address;
@property (nonatomic,strong)UUCategoryModel *category;
@property (nonatomic,assign)PickerType pickerType;
@end
@implementation UUPickerView

- (instancetype)initWithFrame:(CGRect)frame andType:(PickerType )pickerType{
    self.pickerType = pickerType;
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        UIView *headerV = [[UIView alloc]init];
        [self addSubview:headerV];
        [headerV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).mas_offset(pickerType == PickerViewAddressType? self.height/3.0:self.height/2.0);
            make.left.mas_equalTo(self.mas_left);
            make.width.mas_equalTo(self.width);
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
        UILabel *lineLab = [[UILabel alloc]init];
        [self addSubview:lineLab];
        [lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.top.mas_equalTo(headerV.mas_bottom);
            make.width.mas_equalTo(self.width);
            make.height.mas_equalTo(1);
        }];
        lineLab.backgroundColor = UUGREY;
        _pickerView = [[UIPickerView alloc]init];
        
        [self addSubview:_pickerView];
        [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).mas_offset(pickerType == PickerViewAddressType? self.height/3.0+45:self.height/2.0+45);
            make.width.mas_equalTo(self.width);
            make.height.mas_equalTo(self.pickerType==PickerViewAddressType?self.height/3.0*2:self.height/2.0);
            
        }];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)DoneClick{
    if (self.pickerType == PickerViewAddressType) {
        self.selectedAddress(_address);
    }else if (self.pickerType == PickerViewCategoryType){
        self.selectedCategory(_category);
    }else{
        self.selectedResponse(_response);
    }
    [self removeFromSuperview];
}

- (void)CancelClick{
    [self removeFromSuperview];
}

- (void)setDataSource:(NSArray *)dataSource{
    _dataSource = dataSource;
    [_pickerView reloadComponent:0];
}

#pragma mark --PickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _dataSource.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (self.pickerType == PickerViewAddressType) {
        UUAddressModel *model = _dataSource[row];
        if (!_address) {
            _address = _dataSource[0];
        }
        return model.RegionName;
    }else if (self.pickerType == PickerViewCategoryType){
        UUCategoryModel *model = _dataSource[row];
        if (!_category) {
            _category = _dataSource[0];
        }
        return model.ClassName;
    }else{
        if (!_response) {
            _response = _dataSource[0];
        }
        return _dataSource[row];
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (self.pickerType == PickerViewAddressType) {
        UUAddressModel *model = _dataSource[row];
        _address = model;
    }else if (self.pickerType == PickerViewCategoryType){
        UUCategoryModel *model = _dataSource[row];
        _category = model;
    }else{
        _response = _dataSource[row];
    }
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 35;
}
@end
