//
//  LoginViewController.m
//  ShengShengManA
//
//  Created by mibo02 on 16/12/15.
//  Copyright © 2016年 mibo02. All rights reserved.
//
#import <RongIMLib/RongIMLib.h>
#import <RongIMKit/RongIMKit.h>
#import "RongCloudManage.h"
#import "UMessage.h"
#import "LoginViewController.h"
#import "RegistViewController.h"


@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *password;


@end

@implementation LoginViewController
- (IBAction)loginBtnaction:(UIButton *)sender
{
    
    if (self.phone.text.length == 0) {
        [MBProgressHUD showError:@"手机号不能为空"];
        return;
    }
    
    if (self.password.text.length == 0) {
        [MBProgressHUD showError:@"密码不能为空"];
        return;
    }
    [NetWorkManager requestForPostWithUrl:loginURL parameter:@{@"phone":self.phone.text,@"password":self.password.text,@"device":@"ios"} success:^(id reponseObject) {
        [MBProgressHUD showError:reponseObject[@"msg"]];
        if ([reponseObject[@"code"] integerValue] == 1) {
            [UserInfoManager cleanUserInfo];
            PersonModel *model = [[PersonModel alloc] init];
            model.token = reponseObject[@"result"][@"token"];
            model.nick_name = reponseObject[@"result"][@"user"][@"nick_name"];
            model.rong_token = reponseObject[@"result"][@"user"][@"rong_token"];
            model.id = reponseObject[@"result"][@"user"][@"id"];
            model.user_head = reponseObject[@"result"][@"user"][@"user_head"];
            [UserInfoManager saveUserInfoWithModel:model];
            
            
            [NetWorkManager requestForGetWithUrl:[NSString stringWithFormat:@"%@?token=%@",gettokenURL,[UserInfoManager getUserInfo].token] parameter:@{} success:^(id reponseObject) {
                if ([reponseObject[@"code"] integerValue] == 1) {
                    //融云配置
                    [[RCIM sharedRCIM] initWithAppKey:@"0vnjpoad0c7dz"];
                    
                    [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
                    [[RongCloudManage shareDataManage] loginRongCloudWithUserInfo:[[RCUserInfo alloc] initWithUserId:[UserInfoManager getUserInfo].id name:[UserInfoManager getUserInfo].nick_name portrait:[UserInfoManager getUserInfo].user_head] withToken:reponseObject[@"result"]];
                    
                    //别名
                    [UMessage addAlias:[UserInfoManager getUserInfo].id   type:@"UserId" response:^(id responseObject, NSError *error) {
                        NSLog(@"responseObject%@",responseObject);
                    }];
                    
                }
                
            } failure:^(NSError *error) {
                [mdfivetool checkinternationInfomation:error];
                [self hideProgressHUD];
            }];

            [self.navigationController popViewControllerAnimated:YES];
        }
        
        
    } failure:^(NSError *error) {
        [mdfivetool checkinternationInfomation:error];
        [self hideProgressHUD];
    }];
}
- (IBAction)registerAction:(UIButton *)sender
{
    RegistViewController *regist = [RegistViewController new];
    [self.navigationController pushViewController:regist animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent  = NO;
    self.title = @"登录";
    
}



@end
