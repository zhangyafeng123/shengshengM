//
//  fensiViewController.m
//  ShengShengManB
//
//  Created by mibo02 on 17/5/16.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "fensiViewController.h"
#import "personinfoViewController.h"
#import "fensiCell.h"
@interface fensiViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, assign)NSInteger pages;
@end

@implementation fensiViewController

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
    self.title = @"我的粉丝";
    [self.tableview registerNib:[UINib nibWithNibName:@"fensiCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.pages = 1;
    [self request];
}
- (void)request
{
    [self showProgressHUD];
    [NetWorkManager requestForPostWithUrl:accountfansURL parameter:@{@"token":[UserInfoManager getUserInfo].token} success:^(id reponseObject) {
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
    fensiCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *newdic = self.dataArray[indexPath.row];
    cell.nicklab.text = newdic[@"nick_name"];
    if (newdic[@"user_head"] != [NSNull null]) {
       [cell.headimg sd_setImageWithURL:[NSURL URLWithString:newdic[@"user_head"]] placeholderImage:[UIImage imageNamed:@"wdl"]];
    } else {
        cell.headimg.image = [UIImage imageNamed:@"wdl"];
    }
    cell.sublab.text = [NSString stringWithFormat:@"粉丝(%ld) 作品(%ld)",[newdic[@"fans"] integerValue],[newdic[@"works"] integerValue]];
    if ([newdic[@"is_mutual_fans"] isEqualToString:@"no"]) {
        cell.addbtn.selected = NO;
    } else {
        cell.addbtn.selected = YES;
    }
    cell.addbtn.tag = 1100 + indexPath.row;
    [cell.addbtn addTarget:self action:@selector(addbtnaction:) forControlEvents:(UIControlEventTouchUpInside)];
    return cell;
}
- (void)addbtnaction:(UIButton *)sender
{
    NSDictionary *newdic = self.dataArray[sender.tag - 1100];
    if (sender.isSelected) {
        [NetWorkManager requestForPostWithUrl:[NSString stringWithFormat:@"%@?token=%@&user_id=%@",accountcancelfollowURL,[UserInfoManager getUserInfo].token,newdic[@"id"]] parameter:@{} success:^(id reponseObject) {
            if ([reponseObject[@"code"] integerValue] == 1) {
                [self.dataArray removeAllObjects];
                [self request];
            }
            [MBProgressHUD showError:reponseObject[@"msg"]];
        } failure:^(NSError *error) {
            [mdfivetool checkinternationInfomation:error];
            [self hideProgressHUD];
        }];
    } else {
        [NetWorkManager requestForPostWithUrl:[NSString stringWithFormat:@"%@?token=%@&user_id=%@",accountaddfollowURL,[UserInfoManager getUserInfo].token,newdic[@"id"]] parameter:@{} success:^(id reponseObject) {
            if ([reponseObject[@"code"] integerValue] == 1) {
                [self.dataArray removeAllObjects];
                [self request];
            }
            [MBProgressHUD showError:reponseObject[@"msg"]];
        } failure:^(NSError *error) {
            [mdfivetool checkinternationInfomation:error];
            [self hideProgressHUD];
        }];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    personinfoViewController *person = [personinfoViewController new];
    person.nickname = self.dataArray[indexPath.row][@"nick_name"];
    person.userid = self.dataArray[indexPath.row][@"id"];
    [self.navigationController pushViewController:person animated:YES];
}
- (nullable NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    UIFont *font = [UIFont systemFontOfSize:15];
    UIColor *color = [UIColor blackColor];
    NSMutableDictionary *attribult = [NSMutableDictionary new];
    [attribult setObject:font forKey:NSFontAttributeName];
    [attribult setObject:color forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:@"还没有粉丝呢" attributes:attribult];
}
@end
