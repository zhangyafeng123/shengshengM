//
//  pinglunViewController.m
//  ShengShengManB
//
//  Created by mibo02 on 17/5/9.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "pinglunViewController.h"
#import "pinglunCell.h"
#import "tiezipinglunhuifuViewController.h"
@interface pinglunViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, assign)NSInteger pages;
@end

@implementation pinglunViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评论我的";
    self.navigationController.navigationBar.translucent = NO;
    [self.tableview registerNib:[UINib nibWithNibName:@"pinglunCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.pages = 1;
    [self request];
}
- (void)request
{
    [self showProgressHUD];
    [NetWorkManager requestForGetWithUrl:[NSString stringWithFormat:@"%@?token=%@",commentonmeURL,[UserInfoManager  getUserInfo].token] parameter:@{} success:^(id reponseObject) {
        if ([reponseObject[@"code"] integerValue] == 1) {
            for (NSDictionary *dic in reponseObject[@"result"][@"list"]) {
                [self.dataArray addObject:dic];
            }
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
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    pinglunCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell.headimg sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.row][@"user_head"]]];
    cell.nicklab.text = self.dataArray[indexPath.row][@"nick_name"];
    
    NSString *timestr = [getTimes compareCurrentTime:self.dataArray[indexPath.row][@"create_time"]];
    cell.timelab.text = timestr;
    
    NSString *str1 = [NSString stringWithFormat:@"评论我的:\n%@\n",self.dataArray[indexPath.row][@"comments_content"]];
    NSString *str2 = self.dataArray[indexPath.row][@"subject"];
    
    cell.mycontentlab.attributedText = [ZLabel attributedTextArray:@[str1,str2] textColors:@[[UIColor blackColor],[UIColor grayColor]] textfonts:@[H14,H14]];
    cell.deletebtn.layer.borderColor = [UIColor blueColor].CGColor;
    cell.deletebtn.layer.borderWidth = 0.5;
    [cell.deletebtn setTitle:@"回复" forState:(UIControlStateNormal)];
    cell.deletebtn.tag = 150 + indexPath.row;
    [cell.deletebtn addTarget:self action:@selector(huifubtnaction:) forControlEvents:(UIControlEventTouchUpInside)];
    cell.huifubtn.hidden = YES;
    return cell;
}

- (void)huifubtnaction:(UIButton *)sender
{
    tiezipinglunhuifuViewController *tiezi = [tiezipinglunhuifuViewController new];
    tiezi.nickname = self.dataArray[sender.tag - 150][@"nick_name"];
    tiezi.str = self.dataArray[sender.tag - 150][@"id"];
    [self.navigationController pushViewController:tiezi animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary*fontDt = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName,nil];
    NSString *str1 = [NSString stringWithFormat:@"评论我的:\n%@\n%@",self.dataArray[indexPath.row][@"comments_content"],self.dataArray[indexPath.row][@"subject"]];
    CGRect rect = [str1  boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 65, 0) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:fontDt context:nil];
    return 80 + rect.size.height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (nullable NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    UIFont *font = [UIFont systemFontOfSize:15];
    UIColor *color = [UIColor blackColor];
    NSMutableDictionary *attribult = [NSMutableDictionary new];
    [attribult setObject:font forKey:NSFontAttributeName];
    [attribult setObject:color forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:@"您还没有评论哦" attributes:attribult];
}

@end
