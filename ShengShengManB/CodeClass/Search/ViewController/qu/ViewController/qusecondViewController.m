//
//  qusecondViewController.m
//  ShengShengManB
//
//  Created by mibo02 on 17/5/9.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "qusecondViewController.h"
#import "qudetailViewController.h"
#import "LoginViewController.h"
#import "qunewCell.h"
@interface qusecondViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@end

@implementation qusecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.title = self.str;
    [self.tableview registerNib:[UINib nibWithNibName:@"qunewCell" bundle:nil] forCellReuseIdentifier:@"qucell"];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    qunewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"qucell" forIndexPath:indexPath];
    cell.titlelab.text  = self.arr[indexPath.row][@"name"];
    if (self.arr[indexPath.row][@"introduce"] == [NSNull null]) {
        cell.sublab.text = @"";
    } else {
        cell.sublab.text = self.arr[indexPath.row][@"introduce"];
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.arr[indexPath.row][@"introduce"] == [NSNull null]) {
        return 45;
    } else {
        CGRect rect = [TodayDate getstringheightfor:self.arr[indexPath.row][@"introduce"]];
        return rect.size.height + 45;
        
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([UserInfoManager isLoading]) {
        qudetailViewController *detal = [qudetailViewController new];
        detal.name = self.arr[indexPath.row][@"name"];
        detal.newarr = self.arr[indexPath.row][@"subjects"];
        detal.yunshustr = self.arr[indexPath.row][@"yuntitle"];
        detal.headid = self.headid;
        detal.rhythmid = self.arr[indexPath.row][@"id"];
        detal.titlestr = self.title;
        [self.navigationController pushViewController:detal animated:YES];
    } else {
        LoginViewController *login = [LoginViewController new];
        [self.navigationController pushViewController:login animated:YES];
    }
}

@end
