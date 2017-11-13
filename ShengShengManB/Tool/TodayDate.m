//
//  TodayDate.m
//  ShengShengManB
//
//  Created by mibo02 on 17/1/9.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "TodayDate.h"

@implementation TodayDate
+(NSString *)todayDateString
{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY年MM月dd日"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}
//封装显示框
+(void)AlertZYFController:(void(^)(NSString *title,NSString *dates,NSString *authorStr))successAlert UIViewController:(UIViewController *)vc
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"编辑" message:@"" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *OKaction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        NSString *firststr = [alert.textFields[0] text];
        NSString *secondstr = [alert.textFields[1] text];
        NSString *threestr = [alert.textFields[2] text];
        
        NSString *first;
        NSString *second;
        NSString *three;
        
        if (firststr.length == 0) {
            first = [alert.textFields[0] placeholder];
        } else {
            first = firststr;
        }
        if (secondstr.length == 0) {
            second = [alert.textFields[1] placeholder];
        } else {
            second = secondstr;
        }
        if (threestr.length == 0) {
            three = [alert.textFields[2] placeholder];
        } else {
            three = threestr;
        }
        successAlert(first,second,three);
        
    }];
    

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.borderStyle = UITextBorderStyleNone;
        textField.placeholder = @"标题";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.borderStyle = UITextBorderStyleNone;
        textField.placeholder = @"当代";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.borderStyle = UITextBorderStyleNone;
        if ([UserInfoManager isLoading]) {
            textField.placeholder = [NSString stringWithFormat:@"%@",[UserInfoManager getUserInfo].nick_name];
        } else {
          textField.placeholder = @"作者";
        }
        
    }];
    [alert addAction:cancelAction];
    [alert addAction:OKaction];
    [vc presentViewController:alert animated:YES completion:nil];

}
+(UIButton *)createButton
{
    UIWindow *window = [UIApplication sharedApplication].windows[0];
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = [UIColor blackColor].CGColor;
    [btn setTitle:@"注释" forState:(UIControlStateNormal)];
    btn.titleLabel.font = H15;
    [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    btn.frame  = CGRectMake(SCREEN_WIDTH - 70, SCREEN_HEIGHT - 50, 50, 30);
    [window addSubview:btn];
    return btn;
}
+(CGRect)getstringheightfor:(NSString *)str 
{
    NSDictionary*fontDt = [NSDictionary dictionaryWithObjectsAndKeys:H14,NSFontAttributeName,nil];
    return  [str  boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, 0) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:fontDt context:nil];
}
+(CGRect)getstrheightfornew:(NSString *)str
{
    NSDictionary*fontDt = [NSDictionary dictionaryWithObjectsAndKeys:H14,NSFontAttributeName,nil];
    return  [str  boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 120, 0) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:fontDt context:nil];
}

+ (NSString *)getgradefor:(NSInteger)num
{
    NSString *str;
    if (num == 0) {
        str = @"";
    } else if (num == 1) {
        str = @"  (等级:贤人)";
    } else if (num == 2){
        str = @"  (等级:圣人)";
    } else if (num == 3){
        str = @"  (等级:道人)";
    } else if (num == 4){
        str = @"  (等级:仙人)";
    } else if (num == 5){
        str = @"  (等级:真人)";
    } else if (num == 6){
        str = @"  (等级:神人)";
    }
    return str;
}


@end
