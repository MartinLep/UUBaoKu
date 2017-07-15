//
//  UUQuestionViewController.m
//  UUBaoKu
//
//  Created by dev on 17/3/7.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUQuestionViewController.h"
#import "UUQuestListModel.h"
#define QUESTIONLISTAPI @"http://api.uubaoku.com/My/GetPasswordProtectionQuestionList"
@interface UUQuestionViewController ()<
UITableViewDelegate,
UITableViewDataSource>
@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)NSMutableArray *modelArray;
@property(strong,nonatomic)UUQuestListModel *model;
@end

@implementation UUQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self prepareData];
    // Do any additional setup after loading the view.
}

- (void)prepareData{
    self.modelArray = [NSMutableArray array];
    NSString *urlStr = [QUESTIONLISTAPI stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    [NetworkTools postReqeustWithParams:nil UrlString:urlStr successBlock:^(id responseObject) {
        for (NSDictionary *dict in responseObject[@"data"]) {
            self.model = [[UUQuestListModel alloc]initWithDictionary:dict];
            [self.modelArray addObject:self.model];
            
        }
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        
    }];
}
- (void)initUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(20, 0, 200, 300)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellID"];
    [self.view addSubview:_tableView];
}

//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UUQuestListModel *model = _modelArray[indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
    cell.textLabel.text = model.Question;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UUQuestListModel *model = _modelArray[indexPath.row];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"QUESTIONREFRESH" object:@{@"ID":[NSString stringWithFormat:@"%ld",model.ID],@"Question":model.Question}];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
