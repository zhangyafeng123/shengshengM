//
//  cisecondViewController.m
//  ShengShengManB
//
//  Created by mibo02 on 17/5/9.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "cisecondViewController.h"
#import "cidetailViewController.h"
#import "LoginViewController.h"
@interface cisecondViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation cisecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.str;
    self.navigationController.navigationBar.translucent = NO;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"fengfeng";
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
        cidetailViewController *detail = [cidetailViewController new];
        detail.name  = self.arr[indexPath.row][@"name"];
        detail.newarr = self.arr[indexPath.row][@"subjects"];
        detail.yunshustr = self.arr[indexPath.row][@"yunyin"];
        detail.headid = self.headid;
        detail.rhythmid = self.arr[indexPath.row][@"id"];
        detail.titlestr = self.title;
        [self.navigationController pushViewController:detail animated:YES];
    } else {
        LoginViewController *login = [LoginViewController new];
        [self.navigationController pushViewController:login animated:YES];
    }
   
}

@end
