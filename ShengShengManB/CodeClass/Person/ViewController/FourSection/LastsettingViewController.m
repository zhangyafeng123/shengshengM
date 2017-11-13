//
//  LastsettingViewController.m
//  ShengShengManB
//
//  Created by 张亚峰 on 2017/5/7.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "LastsettingViewController.h"
#import "changepasswordViewController.h"
#import "UMessage.h"
@interface LastsettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong)NSArray *arr;
@end

@implementation LastsettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _arr = @[@"修改密码",@"清除缓存"];
   self.title = @"设置";
    self.navigationController.navigationBar.translucent = NO;
    [self createfoot];
    
}
- (void)createfoot
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
    view.backgroundColor = [UIColor whiteColor];
    self.tableview.tableFooterView = view;
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(30, 30, SCREEN_WIDTH - 60, 40);
    [btn setTitle:@"退出登录" forState:(UIControlStateNormal)];
    btn.backgroundColor = NavColor;
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(btnaction:) forControlEvents:(UIControlEventTouchUpInside)];
    [view addSubview:btn];
}
- (void)btnaction:(UIButton *)sender
{
    [NetWorkManager requestForGetWithUrl:[NSString stringWithFormat:@"%@?token=%@",logoutURL,[UserInfoManager getUserInfo].token] parameter:@{} success:^(id reponseObject) {
        if ([reponseObject[@"code"] integerValue] == 1) {
            [MBProgressHUD showError:reponseObject[@"msg"]];
            
            [UMessage removeAlias:[UserInfoManager getUserInfo].id type:@"UserId" response:^(id responseObject, NSError *error) {
                NSLog(@"responseObject%@",responseObject);
            }];
            
            [UserInfoManager cleanUserInfo];
            [self.navigationController popViewControllerAnimated:YES];
            
        } else if ([reponseObject[@"code"] integerValue] == 422){
            [MBProgressHUD showError:@"请重新登录"];
        }
    } failure:^(NSError *error) {
        [mdfivetool checkinternationInfomation:error];
        [self hideProgressHUD];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"fengfeng";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:str];
    }
    cell.textLabel.text = _arr[indexPath.row];
     if (indexPath.row == 1){
        NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM",[self folderSizeAtPath:cachePath]];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell.detailTextLabel.text.length != 0) {
            cell.detailTextLabel.text = @"";
            NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            [self clearCache:cachePath];
            
            [MBProgressHUD showError:@"清除成功"];
        }else{
            [MBProgressHUD showError:@"暂无缓存"];
        }
    } else if (indexPath.row == 0){
        changepasswordViewController *change= [changepasswordViewController new];
        [self.navigationController pushViewController:change animated:YES];
    }
}

#pragma mark --- 清除缓存
/**计算文件的大小*/
- (float)fileSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    } else{
        return 0;
    }
}
/**获取文件目录的大小*/
- (float)folderSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            folderSize += [self fileSizeAtPath:absolutePath];
        }
        return folderSize;
    }
    return 0;
}
/**清理缓存*/
- (void)clearCache:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //可以在这里加入条件过滤不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
}

@end
