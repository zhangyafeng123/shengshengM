//
//  ouxiangViewController.m
//  ShengShengManB
//
//  Created by mibo02 on 17/5/16.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "ouxiangViewController.h"
#import "personinfoViewController.h"
@interface ouxiangViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, assign)NSInteger pages;
@end

@implementation ouxiangViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"我的偶像";
    self.pages = 1;
    [self request];
}
- (void)request
{
    [self showProgressHUD];
    [NetWorkManager requestForPostWithUrl:accountidolURL parameter:@{@"token":[UserInfoManager getUserInfo].token} success:^(id reponseObject) {
        if ([reponseObject[@"code"] integerValue] == 1) {
            for (NSDictionary *dic in reponseObject[@"result"][@"list"]) {
                [self.dataArray addObject:dic];
            }
            
        }
       [self hideProgressHUD];
        [self.tableview reloadData];
        
        [self refrestForpages:[reponseObject[@"result"][@"totalPage"] integerValue]];
    } failure:^(NSError *error) {
        [mdfivetool checkinternationInfomation:error];
        [self hideProgressHUD];
    }];
}
- (void)refrestForpages:(NSInteger)page
{
    if (page > self.pages) {
        self.pages += 1;
        self.tableview.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
            [self.tableview.mj_footer beginRefreshing];
            [self request];
            [self.tableview.mj_footer endRefreshing];
        }];
    } else {
        self.tableview.mj_footer.state = MJRefreshStateNoMoreData;
    }
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
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:str];
    }
    cell.textLabel.text = self.dataArray[indexPath.row][@"nick_name"];
    if (self.dataArray[indexPath.row][@"user_head"] != [NSNull null]) {
       [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.row][@"user_head"]] placeholderImage:[UIImage imageNamed:@"wdl"]];
    } else {
        cell.imageView.image = [UIImage imageNamed:@"wdl"];
    }
    cell.imageView.layer.cornerRadius = 5;
    cell.imageView.layer.masksToBounds  = YES;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    personinfoViewController *person = [personinfoViewController new];
    person.userid = self.dataArray[indexPath.row][@"id"];
    person.nickname = self.dataArray[indexPath.row][@"nick_name"];
    [self.navigationController pushViewController:person animated:YES];
}
- (nullable NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    UIFont *font = [UIFont systemFontOfSize:15];
    UIColor *color = [UIColor blackColor];
    NSMutableDictionary *attribult = [NSMutableDictionary new];
    [attribult setObject:font forKey:NSFontAttributeName];
    [attribult setObject:color forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:@"还没有偶像呢" attributes:attribult];
}


@end
