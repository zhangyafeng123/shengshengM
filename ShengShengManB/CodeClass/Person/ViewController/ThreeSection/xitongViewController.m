//
//  xitongViewController.m
//  ShengShengManB
//
//  Created by mibo02 on 17/5/16.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "xitongViewController.h"
#import "xitongCell.h"
@interface xitongViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, assign)NSInteger pages;
@property (nonatomic, strong)NSMutableArray *dataArray;
@end

@implementation xitongViewController

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
    self.title = @"系统消息";
    [self.tableview registerNib:[UINib nibWithNibName:@"xitongCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.pages = 1;
    [self request];
}

- (void)request
{
    [self showProgressHUD];
    [NetWorkManager requestForPostWithUrl:accountmessageURL parameter:@{@"token":[UserInfoManager getUserInfo].token} success:^(id reponseObject) {
        if ([reponseObject[@"code"] integerValue] == 1) {
            for (NSDictionary *dic in reponseObject[@"result"][@"list"]) {
                [self.dataArray addObject:dic];
            }
        }
        [self.tableview reloadData];
        [self hideProgressHUD];
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
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    xitongCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSString *str = [NSString stringWithFormat:@"%@\n",self.dataArray[indexPath.row][@"title"]];
    cell.contentlab.attributedText = [ZLabel attributedTextArray:@[str,self.dataArray[indexPath.row][@"content"]] textColors:@[[UIColor blueColor],[UIColor blackColor]] textfonts:@[H17,H14]];
    cell.timelab.text = [getTimes compareCurrentTime:self.dataArray[indexPath.row][@"time"]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *newstr = [NSString stringWithFormat:@"%@\n%@",self.dataArray[indexPath.row][@"title"],self.dataArray[indexPath.row][@"content"]];
    CGRect rect1 = [TodayDate getstringheightfor:newstr];
    return rect1.size.height + 50;
}
- (nullable NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    UIFont *font = H14;
    UIColor *color = [UIColor blackColor];
    NSMutableDictionary *attribult = [NSMutableDictionary new];
    [attribult setObject:font forKey:NSFontAttributeName];
    [attribult setObject:color forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:@"还没有消息呢" attributes:attribult];
}


@end
