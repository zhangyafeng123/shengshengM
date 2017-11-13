//
//  chuduilianViewController.m
//  ShengShengManB
//
//  Created by mibo02 on 17/5/27.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "chuduilianViewController.h"

@interface chuduilianViewController ()
@property (weak, nonatomic) IBOutlet UITextField *shangliantext;
@property (weak, nonatomic) IBOutlet UITextField *xialiantext;

@end

@implementation chuduilianViewController
- (IBAction)fabubtn:(UIButton *)sender {
    if (self.shangliantext.text.length == 0) {
        [MBProgressHUD showError:@"请填写上联"];
        return;
    }
    NSString *str;
    if (self.xialiantext.text.length == 0) {
        str = @"";
    } else {
        str = self.xialiantext.text;
    }
    [NetWorkManager requestForPostWithUrl:addshanglianURL parameter:@{@"token":[UserInfoManager getUserInfo].token,@"shanglian":self.shangliantext.text,@"annotation":str} success:^(id reponseObject) {
         [MBProgressHUD showError:reponseObject[@"msg"]];
        if ([reponseObject[@"code"] integerValue] == 1) {
           
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        [mdfivetool checkinternationInfomation:error];
        [self hideProgressHUD];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"写对联";
    self.navigationController.navigationBar.translucent = NO;
}



@end
