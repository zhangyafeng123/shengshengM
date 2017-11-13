//
//  yindaopageViewController.m
//  ShengShengManB
//
//  Created by mibo02 on 17/7/14.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "yindaopageViewController.h"
#import "TabBarViewController.h"
@interface yindaopageViewController (){
    // 判断是否是第一次进入应用
    BOOL flag;
}

@end

@implementation yindaopageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *imagev = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 100)];
    imagev.image = [UIImage imageNamed:@"g_bg"];
    [self.view addSubview:imagev];
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake((SCREEN_WIDTH - 150)/2, CGRectGetMaxY(imagev.frame) + 35, 150, 30);
    btn.backgroundColor = [UIColor blueColor];
    [btn setTitle:@"查看新手引导" forState:(UIControlStateNormal)];
    btn.titleLabel.font = H14;
    [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(btnacton:) forControlEvents:(UIControlEventTouchUpInside)];
    UIButton *newbtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.view addSubview:btn];
    newbtn.frame = CGRectMake(SCREEN_WIDTH - 100, CGRectGetMaxY(imagev.frame) + 35, 80, 30);
    [newbtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [newbtn  setTitle:@"跳过>" forState:(UIControlStateNormal)];
    newbtn.titleLabel.font = H14;
    [newbtn addTarget:self action:@selector(newbtnaction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:newbtn];
   
}
//按钮点击事件
- (void)btnacton:(UIButton *)sender
{
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://share.shengshengman.net/guidancedocuments.php"]];
}
- (void)newbtnaction:(UIButton *)sender
{
    flag = YES;
    NSUserDefaults *useDef = [NSUserDefaults standardUserDefaults];
    // 保存用户数据
    [useDef setBool:flag forKey:@"isfirst"];
    [useDef synchronize];
    // 设置窗口的根控制器
    self.view.window.rootViewController = [[TabBarViewController alloc] init];
    
   
}
@end
