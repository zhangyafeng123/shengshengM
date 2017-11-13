//
//  pinglunselectViewController.m
//  ShengShengManB
//
//  Created by mibo02 on 17/5/23.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "pinglunselectViewController.h"
#import "LoginViewController.h"
@interface pinglunselectViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textV;

@end

@implementation pinglunselectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title = @"评论";
    self.navigationController.navigationBar.translucent = NO;
    [self.textV becomeFirstResponder];
    
}
- (void)request
{
    if (self.textV.text.length == 0) {
        [MBProgressHUD showError:@"评论内容不能为空"];
        return;
    }
    if ([UserInfoManager isLoading]) {
        [NetWorkManager requestForPostWithUrl:bbsaddCommentsURL parameter:@{@"token":[UserInfoManager getUserInfo].token,@"bbsid":self.str,@"content":self.textV.text} success:^(id reponseObject) {
            [MBProgressHUD showError:reponseObject[@"msg"]];
            if ([reponseObject[@"code"] integerValue] == 1) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(NSError *error) {
            [mdfivetool checkinternationInfomation:error];
            [self hideProgressHUD];
        }];
    } else {
        LoginViewController *login = [LoginViewController new];
        [self.navigationController pushViewController:login animated:YES];
    }
   
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [self request];
        return NO;
    }
   
    return YES;
}
@end
