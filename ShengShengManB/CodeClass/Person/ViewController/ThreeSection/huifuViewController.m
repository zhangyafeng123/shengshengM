//
//  huifuViewController.m
//  ShengShengManB
//
//  Created by mibo02 on 17/5/9.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "huifuViewController.h"
#import "pinglunCell.h"
#import "shiModel.h"
#import "tiezipinglunhuifuViewController.h"
@interface huifuViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, assign)NSInteger pages;
@end

@implementation huifuViewController
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的回复";
    [self.tableview registerNib:[UINib nibWithNibName:@"pinglunCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.navigationController.navigationBar.translucent = NO;
     self.pages = 1;
    [self request];
}
- (void)request
{
    
    [NetWorkManager requestForGetWithUrl:[NSString stringWithFormat:@"%@?token=%@",mycommentURL,[UserInfoManager getUserInfo].token] parameter:@{} success:^(id reponseObject) {
        if ([reponseObject[@"code"] integerValue] == 1) {
            for (NSDictionary *dic in reponseObject[@"result"][@"list"]) {
                shiModel *model = [shiModel new];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
            }
        }
        
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
    shiModel *model = self.dataArray[indexPath.row];
    [cell.headimg sd_setImageWithURL:[NSURL URLWithString:model.user_head] placeholderImage:[UIImage imageNamed:@"wdl"]];
    
    cell.nicklab.text = model.nick_name;
    
    cell.timelab.text =  [getTimes compareCurrentTime:model.comments_time];
    
    NSString *str1 = [NSString stringWithFormat:@"我的回复是:\n%@\n",model.comments_content];
    NSString *str2 = model.subject;
    cell.mycontentlab.attributedText = [ZLabel attributedTextArray:@[str1,str2] textColors:@[[UIColor blackColor],[UIColor grayColor]] textfonts:@[H14,H14]];
    cell.huifubtn.layer.borderWidth = 0.5;
    cell.huifubtn.layer.borderColor = [UIColor blueColor].CGColor;
    cell.deletebtn.layer.borderWidth = 0.5;
    cell.deletebtn.layer.borderColor = [UIColor blueColor].CGColor;
    cell.huifubtn.tag = 150 + indexPath.row;
    [cell.huifubtn addTarget:self action:@selector(huifubtnaction:) forControlEvents:(UIControlEventTouchUpInside)];
    cell.deletebtn.tag = 200 + indexPath.row;
    [cell.deletebtn addTarget:self action:@selector(deletebtnaction:) forControlEvents:(UIControlEventTouchUpInside)];
    return cell;
    
}
- (void)huifubtnaction:(UIButton *)sender
{
    
    tiezipinglunhuifuViewController *tiezi = [tiezipinglunhuifuViewController new];
    tiezi.str = [self.dataArray[sender.tag - 150] id];
    [self.navigationController pushViewController:tiezi animated:YES];
}
- (void)deletebtnaction:(UIButton *)sender
{
    
    [NetWorkManager requestForGetWithUrl:[NSString stringWithFormat:@"%@?token=%@&comment_id=%@",bbsdeletecommentURL,[UserInfoManager getUserInfo].token,[self.dataArray[sender.tag - 200] id]] parameter:@{} success:^(id reponseObject) {
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary*fontDt = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName,nil];
    shiModel *model = self.dataArray[indexPath.row];
    NSString *newstr =  [NSString stringWithFormat:@"我回复的:\n%@\n%@",model.comments_content,model.subject];
    CGRect rect = [newstr  boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 65, 0) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:fontDt context:nil];
    return 80 + rect.size.height;
}

- (nullable NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    UIFont *font = [UIFont systemFontOfSize:15];
    UIColor *color = [UIColor blackColor];
    NSMutableDictionary *attribult = [NSMutableDictionary new];
    [attribult setObject:font forKey:NSFontAttributeName];
    [attribult setObject:color forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:@"还没收到回复哦" attributes:attribult];
}
@end
