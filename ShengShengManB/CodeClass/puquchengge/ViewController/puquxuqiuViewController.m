//
//  puquxuqiuViewController.m
//  ShengShengManB
//
//  Created by mibo02 on 17/4/27.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "puquxuqiuViewController.h"
#import "createCell.h"
#import "createtwoCell.h"
@interface puquxuqiuViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableivew;

@end

@implementation puquxuqiuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发送需求";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem initWithTitle:@"发送" titleColor:[UIColor whiteColor] target:self action:@selector(action)];
    [self.tableivew registerNib:[UINib nibWithNibName:@"createCell" bundle:nil] forCellReuseIdentifier:@"create"];
    [self.tableivew registerNib:[UINib nibWithNibName:@"createtwoCell" bundle:nil] forCellReuseIdentifier:@"createtwo"];
}
- (void)action
{
    createCell *cell = [self.tableivew cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0 ]];
    createCell *cell1 = [self.tableivew cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    createCell *cell2 = [self.tableivew cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    createtwoCell *cell3 = [self.tableivew cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    
    if (cell.textF.text.length == 0) {
        cell.textF.text = @"";
    }
    
    if (cell1.textF.text.length == 0) {
        cell1.textF.text = @"";
    }
    
    if (cell2.textF.text.length == 0) {
        cell2.textF.text = @"";
    }
    
    if (cell.textF.text.length == 0 && cell1.textF.text.length == 0 && cell2.textF.text.length == 0) {
        [MBProgressHUD showError:@"联系方式最少填写一项"];
        return;
    }
    
    if (cell3.textV.text.length == 0) {
        [MBProgressHUD showError:@"请填写需求"];
        return;
    }
    
    [NetWorkManager requestForPostWithUrl:musicaddURL parameter:@{@"token":[UserInfoManager getUserInfo].token,@"demand":cell3.textV.text,@"phone":cell1.textF.text,@"email":cell2.textF.text,@"wechat":cell.textF.text} success:^(id reponseObject) {
        if ([reponseObject[@"code"] integerValue] == 1) {
            [MBProgressHUD showError:reponseObject[@"msg"]];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
        [mdfivetool checkinternationInfomation:error];
        [self hideProgressHUD];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        createtwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"createtwo" forIndexPath:indexPath];
        cell.tleftlab.text = @"我的需求:";
    
        return cell;
    } else {
        createCell *cell = [tableView dequeueReusableCellWithIdentifier:@"create" forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.leftlab.text = @"微信号:";
            cell.textF.placeholder = @"请填写微信号";
        } else if (indexPath.row == 1){
            cell.leftlab.text = @"手机号:";
            cell.textF.placeholder = @"请填写手机号";
        } else if (indexPath.row == 2){
            cell.leftlab.text = @"邮箱:";
            cell.textF.placeholder = @"请填写邮箱";
        }
        
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        return 150;
    } else {
        return 45;
    }
}

@end
