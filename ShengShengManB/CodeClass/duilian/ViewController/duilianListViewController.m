//
//  duilianListViewController.m
//  ShengShengManB
//
//  Created by mibo02 on 17/5/24.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "duilianListViewController.h"
#import "duilianCell.h"
#import "duilianModel.h"
@interface duilianListViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation duilianListViewController
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"下联列表";
    self.navigationController.navigationBar.translucent = NO;
    [self.tableview registerNib:[UINib nibWithNibName:@"duilianCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self request];
}
- (void)request
{
    [self showProgressHUD];
    [NetWorkManager requestForGetWithUrl:[NSString stringWithFormat:@"%@?couplet_id=%@",coupletinfoURL,self.newid] parameter:@{} success:^(id reponseObject) {
        if ([reponseObject[@"code"] integerValue] == 1) {
            for (NSDictionary *dic in reponseObject[@"result"]) {
                duilianModel *model = [duilianModel new];
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
    duilianCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    duilianModel *model = self.dataArray[indexPath.row];
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:model.user_head] placeholderImage:[UIImage imageNamed:@"wdl"]];
    
    NSString *str1 = [TodayDate getgradefor:model.grade];
    
    if (model.nick_name) {
        cell.nickLab.attributedText = [ZLabel attributedTextArray:@[model.nick_name,str1] textColors:@[[UIColor blueColor],[UIColor blackColor]] textfonts:@[H15,H11]];
    }
    
    NSString *str = [NSString stringWithFormat:@"%@\n注释：",model.xialian];
    if (model.annotation.length == 0) {
        cell.contentLab.text = model.xialian;
    } else {
        cell.contentLab.attributedText = [ZLabel attributedTextArray:@[str,model.annotation] textColors:@[[UIColor blackColor],[UIColor grayColor]] textfonts:@[H16,H14]];
    }
    cell.timeLab.text = [getTimes compareCurrentTime:model.create_time];

    cell.addbtn.hidden = YES;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    duilianModel *model = self.dataArray[indexPath.row];
    NSDictionary*fontDt = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName,nil];
    NSString *str;
    if (model.annotation.length == 0) {
        str = model.xialian;
    } else {
        str = [NSString stringWithFormat:@"%@\n注释：%@",model.xialian,model.annotation];
    }
    CGRect rect = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, 0) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:fontDt context:nil];
    
    return 90 + rect.size.height;
}

- (nullable NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    UIFont *font = [UIFont systemFontOfSize:17];
    UIColor *color = [UIColor blackColor];
    NSMutableDictionary *attribult = [NSMutableDictionary new];
    [attribult setObject:font forKey:NSFontAttributeName];
    [attribult setObject:color forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:@"还没有人对上呢!" attributes:attribult];
}

@end
