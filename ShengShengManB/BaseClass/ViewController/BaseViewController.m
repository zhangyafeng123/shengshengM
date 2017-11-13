//
//  BaseViewController.m
//  ShengShengManA
//
//  Created by mibo02 on 16/12/14.
//  Copyright © 2016年 mibo02. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
@property (nonatomic, strong)MBProgressHUD *HUD;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
   
   
}

- (MBProgressHUD *)HUD{
    if (_HUD == nil) {
        self.HUD = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:self.HUD];
    }
    return _HUD;
}
#pragma mark - 显示loading动画 -
- (void)showProgressHUD{
    [self showProgressHUDWithThitle:nil];
}


#pragma mark - 隐藏loading动画 -
- (void)hideProgressHUD{
    if (self.HUD != nil) {
        //移除并置空
        [self.HUD removeFromSuperview];
        self.HUD = nil;
    }
}


#pragma mark - 显示带有文字的loading -
- (void)showProgressHUDWithThitle:(NSString *)title{
    if (title.length == 0) {
        self.HUD.labelText = @"请稍后";
    } else {
        //self.HUD.labelText = title;
        self.HUD.detailsLabelText = title;
    }
    //显示loading
    [self.HUD show:YES];
}







@end