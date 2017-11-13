//
//  TodayDate.h
//  ShengShengManB
//
//  Created by mibo02 on 17/1/9.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TodayDate : NSObject
//获取当天日期
+(NSString *)todayDateString;
//封装显示框
+(void)AlertZYFController:(void(^)(NSString *title,NSString *dates,NSString *authorStr))successAlert UIViewController:(UIViewController *)vc;
+(UIButton *)createButton;

+(CGRect)getstringheightfor:(NSString *)str;

//等级
+ (NSString *)getgradefor:(NSInteger)num;
+(CGRect)getstrheightfornew:(NSString *)str;
@end
