//
//  musicxuqiuViewController.m
//  ShengShengManB
//
//  Created by mibo02 on 17/6/15.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "musicxuqiuViewController.h"
#import "musicnewCell.h"
#import "musicnewModel.h"
@interface musicxuqiuViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong)NSMutableArray *dataArray;
@end

@implementation musicxuqiuViewController
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =  @"需求";
    [self.tableview registerNib:[UINib nibWithNibName:@"musicnewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.navigationController.navigationBar.translucent = NO;
    [self request];
}
- (void)request
{
    [self showProgressHUD];
    [NetWorkManager requestForGetWithUrl:[NSString stringWithFormat:@"%@?token=%@",cianDemandURL,[UserInfoManager getUserInfo].token] parameter:@{} success:^(id reponseObject) {
        if ([reponseObject[@"code"] integerValue] == 1) {
            for (NSDictionary *dic in reponseObject[@"result"]) {
                musicnewModel *model = [musicnewModel new];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
            }
        }
        [self.tableview reloadData];
        [self hideProgressHUD];
    } failure:^(NSError *error) {
        [mdfivetool checkinternationInfomation:error];
        [self hideProgressHUD];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    musicnewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    musicnewModel *model = self.dataArray[indexPath.row];
    if ([model.demand_state isEqualToString:@"1"]) {
        cell.firstlab.text  = @"未处理";
    } else {
        cell.firstlab.text = @"已处理";
    }
    cell.seclab.text = [NSString stringWithFormat:@"需求内容:%@",model.demand];
    cell.threelab.text = [NSString stringWithFormat:@"微信号:%@",model.wechat];
    cell.fourlab.text = [NSString stringWithFormat:@"手机号:%@",model.contact_number];
    cell.fivelab.text = [NSString stringWithFormat:@"邮箱:%@",model.contact_mailbox];
    cell.sixlab.text = [NSString stringWithFormat:@"发布时间:%@",model.create_time];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
}

- (nullable NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    UIFont *font = [UIFont systemFontOfSize:15];
    UIColor *color = [UIColor blackColor];
    NSMutableDictionary *attribult = [NSMutableDictionary new];
    [attribult setObject:font forKey:NSFontAttributeName];
    [attribult setObject:color forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:@"你还没发布需求呢" attributes:attribult];
}

@end
