//
//  RegistViewController.m
//  ShengShengManB
//
//  Created by mibo02 on 17/4/24.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "RegistViewController.h"

@interface RegistViewController ()<UITextFieldDelegate>{
    //定时器
    NSTimer *timer;
    NSInteger verificationTime;//重新获取验证码时间;
}
@property (weak, nonatomic) IBOutlet UITextField *nickName;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *yanzhengM;
@property (weak, nonatomic) IBOutlet UIButton *getbutton;
@property (weak, nonatomic) IBOutlet UITextField *tuijian;
@property (weak, nonatomic) IBOutlet UILabel *getlabel;
@property (weak, nonatomic) IBOutlet UITextField *imgtextf;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@end

@implementation RegistViewController
- (IBAction)sendmessageAction:(UIButton *)sender
{
    
    if (self.phone.text.length == 0) {
        [MBProgressHUD showError:@"手机号不能为空"];
        return;
    }
    if (self.imgtextf.text.length == 0) {
        [MBProgressHUD showError:@"图片验证码不能为空"];
        return;
    }
    [NetWorkManager requestForGetWithUrl:[NSString stringWithFormat:@"%@?phone=%@&model=%@&code=%@",senderMessageURL,self.phone.text,@"zc",self.imgtextf.text] parameter:@{} success:^(id reponseObject) {
        
        [MBProgressHUD showError:reponseObject[@"msg"]];
        
        if ([reponseObject[@"code"] integerValue] == 1) {
            
            self.yanzhengM.text = reponseObject[@"result"];
            sender.hidden = YES;
            _getlabel.text = [NSString stringWithFormat:@"%ld重新发送",verificationTime];
            timer  = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
            
        }
        
    } failure:^(NSError *error) {
        [mdfivetool checkinternationInfomation:error];
        [self hideProgressHUD];
    }];
    
}

- (IBAction)buttonaction:(UIButton *)sender
{
    if (self.phone.text.length == 0) {
        [MBProgressHUD showError:@"手机号不能为空"];
        return;
    }
    if (self.password.text.length == 0) {
        [MBProgressHUD showError:@"密码不能为空"];
        return;
    }
    if (self.imgtextf.text.length == 0) {
        [MBProgressHUD showError:@"图片验证码不能为空"];
        return;
    }
    if (self.yanzhengM.text.length == 0) {
        [MBProgressHUD showError:@"验证码不能为空"];
        return;
    }
  [NetWorkManager requestForPostWithUrl:registerURL parameter:@{@"phone":self.phone.text,@"password":self.password.text,@"nick_name":self.nickName.text,@"code":self.yanzhengM.text} success:^(id reponseObject) {
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
    self.title = @"注册";
    //刚开始60秒
    verificationTime = 180;
    self.navigationController.navigationBar.translucent  = NO;
    self.phone.delegate = self;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if (textField.text.length == 11) {
        [NetWorkManager requestForGetWithUrl:[NSString stringWithFormat:@"%@?phone=%@",imageotherURL,textField.text] parameter:@{} success:^(id reponseObject) {
            if ([reponseObject[@"code"] integerValue] == 1) {
                NSData *imageData = [[NSData alloc] initWithBase64EncodedString:reponseObject[@"result"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
                self.imageV.image = [UIImage imageWithData:imageData];
            }
        } failure:^(NSError *error) {
            
        }];
    }
}
- (void)timerAction:(NSTimer *)sender
{
    verificationTime -= 1;
    if (verificationTime == 0) {
        [timer invalidate];
        timer = nil;
        verificationTime = 180;
        _getbutton.hidden = NO;
        _getlabel.text = @"获取验证码";
    } else {
        _getlabel.text = [NSString stringWithFormat:@"%ld(s)",verificationTime];
    }
    
}
//当视图将要消失的时候销毁定时器
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [timer invalidate];
    timer = nil;
}
@end
