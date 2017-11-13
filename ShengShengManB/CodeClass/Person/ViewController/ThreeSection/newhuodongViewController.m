//
//  newhuodongViewController.m
//  ShengShengManB
//
//  Created by mibo02 on 17/6/2.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "newhuodongViewController.h"
#import "newhuodongModel.h"
#import "newhuodongdetailViewController.h"
#import "jiebanCell.h"
@interface newhuodongViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, assign)NSInteger pages;
@end

@implementation newhuodongViewController
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的活动";
    self.navigationController.navigationBar.translucent = NO;
    self.pages = 1;
    [self.tableview registerNib:[UINib nibWithNibName:@"jiebanCell" bundle:nil] forCellReuseIdentifier:@"jieban"];
    [self request];
}
- (void)request
{
    [self showProgressHUD];
    NSString *str = [NSString stringWithFormat:@"%@?token=%@&page_no=%ld",myListURL,[UserInfoManager getUserInfo].token,self.pages];
    
    [NetWorkManager requestForGetWithUrl:str parameter:@{} success:^(id reponseObject) {
        for (NSDictionary *dic in  reponseObject[@"result"][@"list"]) {
            newhuodongModel *model = [[newhuodongModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        [self hideProgressHUD];
        [self.tableview reloadData];
        [self  refrestForpages:[reponseObject[@"result"][@"totalPage"] integerValue]];
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
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    jiebanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jieban" forIndexPath:indexPath];
    newhuodongModel *model  = self.dataArray[indexPath.row];
    
    cell.titlelab.text = model.title;
    
    
    cell.timelab.text = model.create_time;
    cell.addresslab.text = model.address;
    if ([model.activity_state isEqualToString:@"0"]) {
        cell.statelab.text = @"审核中";
    } else if ([model.activity_state isEqualToString:@"1"]){
        cell.statelab.text = @"进行中";
    } else if ([model.activity_state isEqualToString:@"2"]){
        cell.statelab.text = @"已结束";
    } else if ([model.activity_state isEqualToString:@"-1"]){
        cell.statelab.text = @"已关闭";
    }
    
    NSString *imgstr = model.picture;
    if (![model.picture isEqualToString:@""]) {
        NSArray *arr = [imgstr componentsSeparatedByString:@"|"];
        NSLog(@"%@",arr[0]);
        if (arr.count != 0) {
            if ([arr[0] isEqualToString:@""]) {
                UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 200)];
                if ([arr[1] hasPrefix:@"http"]) {
                    [image sd_setImageWithURL:[NSURL URLWithString:arr[1]]];
                } else {
                    [image sd_setImageWithURL:[NSURL URLWithString:ImageViewURL(arr[1])]];
                }
                
                [cell.imgbottomview addSubview:image];
            } else {
                UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 200)];
                if ([arr[0] hasPrefix:@"http"]) {
                    [image sd_setImageWithURL:[NSURL URLWithString:arr[0]]];
                } else {
                    [image sd_setImageWithURL:[NSURL URLWithString:ImageViewURL(arr[0])]];
                }
                [cell.imgbottomview addSubview:image];
            }
            
        }
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    newhuodongModel *model  = self.dataArray[indexPath.row];
    NSString *imgstr = model.picture;
    if (![imgstr isEqualToString:@""]) {
        NSArray *arr = [imgstr componentsSeparatedByString:@"|"];
        if (arr.count != 0) {
            return 350;
        } else {
            return 170;
        }
    } else {
        return 170;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    newhuodongdetailViewController *detail = [newhuodongdetailViewController new];
    detail.model = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
}

- (nullable NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    UIFont *font = H14;
    UIColor *color = [UIColor blackColor];
    NSMutableDictionary *attribult = [NSMutableDictionary new];
    [attribult setObject:font forKey:NSFontAttributeName];
    [attribult setObject:color forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:@"暂未发布活动" attributes:attribult];
}
@end
