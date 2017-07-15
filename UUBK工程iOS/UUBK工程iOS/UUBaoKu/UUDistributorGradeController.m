//
//  UUDistributorGradeController.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/23.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUDistributorGradeController.h"
#import "UUGradeReferenceCell.h"
#import "UUGradeListCell.h"
#import "UUGradeThirdCell.h"

@interface UUDistributorGradeController ()<
UITableViewDelegate,
UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
static NSString *firstCellId = @"UUGradeReferenceCell";
static NSString *secondCellId = @"UUGradeListCell";
static NSString *thirdCellId = @"UUGradeThirdCell";
@implementation UUDistributorGradeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUNG_COLOR;
    [self setUpTableView];
    // Do any additional setup after loading the view from its nib.
}

- (void)setUpTableView{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:firstCellId bundle:nil] forCellReuseIdentifier:firstCellId];
    [self.tableView registerNib:[UINib nibWithNibName:secondCellId bundle:nil] forCellReuseIdentifier:secondCellId];
    [self.tableView registerNib:[UINib nibWithNibName:thirdCellId bundle:nil] forCellReuseIdentifier:thirdCellId];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UUGradeReferenceCell *cell = [tableView dequeueReusableCellWithIdentifier:firstCellId forIndexPath:indexPath];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:firstCellId owner:nil options:nil].lastObject;
        }
        return cell;
        
    }else if (indexPath.section == 1){
        UUGradeListCell *cell = [tableView dequeueReusableCellWithIdentifier:secondCellId forIndexPath:indexPath];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:secondCellId owner:nil options:nil].lastObject;
        }
        return cell;
    }else{
        UUGradeThirdCell *cell = [tableView dequeueReusableCellWithIdentifier:thirdCellId forIndexPath:indexPath];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:thirdCellId owner:nil options:nil].lastObject;
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 30;
    }
    return 100;
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
