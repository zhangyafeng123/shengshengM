//
//  shisecondViewController.m
//  ShengShengManB
//
//  Created by mibo02 on 17/5/9.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "shisecondViewController.h"
#import "shidetailViewController.h"
#import "LoginViewController.h"
@interface shisecondViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation shisecondViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.title = self.name;
   
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str=  @"fengfeng";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:str];
    }
    cell.textLabel.text = self.arr[indexPath.row][@"name"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([UserInfoManager isLoading]) {
        shidetailViewController *three =[shidetailViewController new];
        three.newarr = self.arr[indexPath.row][@"subjectList"];
        three.name = self.arr[indexPath.row][@"name"];
        three.yunshustr = self.arr[indexPath.row][@"yunyin"];
        three.headid = self.headid;
        three.rhythmid = self.arr[indexPath.row][@"id"];
        three.titlestr = self.title;
        [self.navigationController pushViewController:three animated:YES];
    } else {
        LoginViewController *login = [LoginViewController new];
        [self.navigationController pushViewController:login animated:YES];
    }
    
}







@end
