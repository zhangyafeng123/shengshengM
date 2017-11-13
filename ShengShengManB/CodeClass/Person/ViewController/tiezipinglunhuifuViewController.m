//
//  tiezipinglunhuifuViewController.m
//  ShengShengManB
//
//  Created by mibo02 on 17/6/26.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "tiezipinglunhuifuViewController.h"

@interface tiezipinglunhuifuViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textV;
@end

@implementation tiezipinglunhuifuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"回复";
    self.navigationController.navigationBar.translucent = NO;
    [self.textV becomeFirstResponder];
}

- (void)request
{
    if (self.textV.text.length == 0) {
        [MBProgressHUD showError:@"评论内容不能为空"];
        return;
    }
        [NetWorkManager requestForPostWithUrl:bbsaddReplyURL parameter:@{@"token":[UserInfoManager getUserInfo].token,@"comment_id":self.str,@"content":[NSString stringWithFormat:@"@%@:%@",self.nickname,self.textV.text]} success:^(id reponseObject) {
            [MBProgressHUD showError:reponseObject[@"msg"]];
            if ([reponseObject[@"code"] integerValue] == 1) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(NSError *error) {
            [mdfivetool checkinternationInfomation:error];
            [self hideProgressHUD];
        }];
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
