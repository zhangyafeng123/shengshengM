//
//  huodongmenViewController.m
//  ShengShengManB
//
//  Created by mibo02 on 17/6/5.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "huodongmenViewController.h"
#import "numModel.h"
@interface huodongmenViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, assign)NSInteger pages;
@end

@implementation huodongmenViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title = @"查看报名信息";
    self.pages = 1;
    [self request];
}
- (void)request
{
    [self showProgressHUD];
    [NetWorkManager requestForGetWithUrl:[NSString stringWithFormat:@"%@?token=%@&activity_id=%@&page_no=%ld",signupInfoURL,[UserInfoManager getUserInfo].token,self.firststr,self.pages] parameter:@{} success:^(id reponseObject) {
        if ([reponseObject[@"code"] integerValue] == 1) {
            for (NSDictionary *dic in reponseObject[@"result"][@"list"]) {
                numModel *model = [numModel new];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
            }
            
        }
        [self hideProgressHUD];
        [self.tableview reloadData];
        
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
    static NSString *str = @"fengfeng";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:str];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([self.dataArray[indexPath.row] userHead] == nil) {
        cell.imageView.image = [UIImage imageNamed:@"wdl"];
    } else {
       [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[self.dataArray[indexPath.row] userHead]]];
    }
   
    cell.textLabel.text = [self.dataArray[indexPath.row] nickName];
    cell.detailTextLabel.text = [getTimes compareCurrentTime:[self.dataArray[indexPath.row] dateTime]];
    return cell;
}
- (nullable NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    UIFont *font = [UIFont systemFontOfSize:15];
    UIColor *color = [UIColor blackColor];
    NSMutableDictionary *attribult = [NSMutableDictionary new];
    [attribult setObject:font forKey:NSFontAttributeName];
    [attribult setObject:color forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:@"还没有人报名呢" attributes:attribult];
}



@end
