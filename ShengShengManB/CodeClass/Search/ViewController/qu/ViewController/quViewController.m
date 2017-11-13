//
//  quViewController.m
//  ShengShengManB
//
//  Created by mibo02 on 17/5/9.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "quViewController.h"
#import "qusecondViewController.h"
@interface quViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong)NSMutableArray *dataArray;
@end

@implementation quViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray =[NSMutableArray new];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"曲";
    self.navigationController.navigationBar.translucent = NO;
    [self request];
}
-(void)request
{
    [NetWorkManager requestForGetWithUrl:songinfoURL parameter:@{} success:^(id reponseObject) {
        if ([reponseObject[@"code"] integerValue] == 1) {
            for (NSDictionary *dic in reponseObject[@"result"]) {
                [self.dataArray addObject:dic];
            }
        }
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
    cell.textLabel.text = self.dataArray[indexPath.row][@"name"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    qusecondViewController *ci = [qusecondViewController new];
    ci.arr = self.dataArray[indexPath.row][@"qupais"];
    ci.str = self.dataArray[indexPath.row][@"name"];
    ci.headid = self.dataArray[indexPath.row][@"id"];
    [self.navigationController pushViewController:ci animated:YES];
}



@end
