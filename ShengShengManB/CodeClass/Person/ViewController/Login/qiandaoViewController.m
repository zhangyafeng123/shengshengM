//
//  qiandaoViewController.m
//  ShengShengManB
//
//  Created by mibo02 on 17/4/28.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "qiandaoViewController.h"

@interface qiandaoViewController ()
@property (weak, nonatomic) IBOutlet UIButton *qiandaobtn;
@property (weak, nonatomic) IBOutlet UILabel *firstLab;
@property (weak, nonatomic) IBOutlet UILabel *seclab;

@property (weak, nonatomic) IBOutlet UILabel *threelab;
@end

@implementation qiandaoViewController
- (IBAction)qiandaobtn:(UIButton *)sender {
    [NetWorkManager requestForGetWithUrl:[NSString stringWithFormat:@"%@?token=%@",signaddURL,[UserInfoManager getUserInfo].token] parameter:@{} success:^(id reponseObject) {
        if ([reponseObject[@"code"] integerValue] == 1) {
           
            [sender setTitle:@"今日已签到" forState:(UIControlStateNormal)];
            sender.enabled = NO;
        }
        
        [MBProgressHUD showError:reponseObject[@"msg"]];
        
    } failure:^(NSError *error) {
        [mdfivetool checkinternationInfomation:error];
        [self hideProgressHUD];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"签到";
    NSDate  *todaydate = [NSDate date];
    //获取今天的时间
    NSDateFormatter *datef = [[NSDateFormatter alloc] init];
    [datef setDateFormat:@"yyyy-MM-dd"];
    NSString *str = [datef stringFromDate:todaydate];
    NSLog(@"%@",str);
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"times"]);
    //获取签到的时间
    NSString *str1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"times"];
    NSArray *arr = [str1 componentsSeparatedByString:@" "];
    NSLog(@"%@",arr[0]);
    
    if ([arr[0] isEqualToString:str]) {
          [self.qiandaobtn setTitle:@"今日已签到" forState:(UIControlStateNormal)];
        self.qiandaobtn.enabled = NO;
    } 
    
    [self request];
}
- (void)request
{
    [NetWorkManager requestForGetWithUrl:[NSString stringWithFormat:@"%@?token=%@",signinfoURL,[UserInfoManager getUserInfo].token] parameter:@{} success:^(id reponseObject) {
        if ([reponseObject[@"code"] integerValue] == 1) {
            if (reponseObject[@"result"][@"integral"] != [NSNull null]) {
                self.firstLab.text = [NSString stringWithFormat:@"当前积分：%ld",[reponseObject[@"result"][@"integral"] integerValue]];
            } else{
                self.firstLab.text = @"当前积分：0";
            }
            
            if (reponseObject[@"result"][@"sign"] != [NSNull null]) {
                self.seclab.text = [NSString stringWithFormat:@"连续签到：%ld天",[reponseObject[@"result"][@"sign"][@"sign_day_count"] integerValue]];
                self.threelab.text = [NSString stringWithFormat:@"签到时间：%@",reponseObject[@"result"][@"sign"][@"sign_time"]];
                
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"times"];
                //保存到本地
                [[NSUserDefaults standardUserDefaults] setObject:reponseObject[@"result"][@"sign"][@"sign_time"] forKey:@"times"];
            } else {
                self.seclab.text = @"连续签到：0天";
                self.threelab.text = @"未查询到";
            }
            
            
        }
    } failure:^(NSError *error) {
        [mdfivetool checkinternationInfomation:error];
        [self hideProgressHUD];
    }];
}

@end
