//
//  TabBarViewController.m
//  ShengShengManA
//
//  Created by mibo02 on 16/12/14.
//  Copyright © 2016年 mibo02. All rights reserved.
//

#import "TabBarViewController.h"
#import "HomeViewController.h"
#import "PersonnewViewController.h"
#import "SearchViewController.h"
#import "DLNavitationController.h"
@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置tabbar背景颜色
    [[UITabBar appearance] setBarTintColor:NavColor];
    [UITabBar appearance].translucent = NO;
    HomeViewController *home = [[HomeViewController alloc] init];
    [self createChildVCWithVC:home Title:@"天下诗友" Image:@"诗" SelectedImage:@"诗"];
    SearchViewController *search = [[SearchViewController alloc] init];
    [self createChildVCWithVC:search Title:@"格律助手" Image:@"助" SelectedImage:@"助"];
    PersonnewViewController *person = [[PersonnewViewController alloc] init];
    [self createChildVCWithVC:person Title:@"与我有关" Image:@"我" SelectedImage:@"我"];
    
}
- (void)createChildVCWithVC:(UIViewController *)childVC Title:(NSString *)title Image:(NSString *)image SelectedImage:(NSString *)selectedimage
{
    //设置控制器的文字
    childVC.title = title;//同时设置tabbar和navigation的标题
    //设置子控制器图片
    childVC.tabBarItem.image = [UIImage imageNamed:image];
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedimage] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    childVC.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    childVC.view.backgroundColor = [UIColor whiteColor];
    //给子控制器包装导航控制器
    DLNavitationController *nav = [[DLNavitationController alloc] initWithRootViewController:childVC];
    nav.navigationBar.barTintColor = NavColor;
    [nav.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self addChildViewController:nav];
    
}

@end
