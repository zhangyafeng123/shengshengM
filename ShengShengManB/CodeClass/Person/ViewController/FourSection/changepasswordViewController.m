//
//  changepasswordViewController.m
//  ShengShengManB
//
//  Created by mibo02 on 17/5/8.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "changepasswordViewController.h"

@interface changepasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *password;
@end

@implementation changepasswordViewController
- (IBAction)compbtn:(id)sender {
    if (self.password.text.length == 0) {
        [MBProgressHUD showError:@"密码不能为空"];
        return;
    }
    [NetWorkManager requestForPostWithUrl:passwordURL parameter:@{@"token":[UserInfoManager getUserInfo].token,@"password":self.password.text} success:^(id reponseObject) {
        [MBProgressHUD showError:reponseObject[@"msg"]];
        if ([reponseObject[@"code"] integerValue] == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
         [mdfivetool checkinternationInfomation:error];
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    self.navigationController.navigationBar.translucent = NO;
}

@end
