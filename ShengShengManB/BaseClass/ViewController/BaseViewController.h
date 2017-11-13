//
//  BaseViewController.h
//  ShengShengManA
//
//  Created by mibo02 on 16/12/14.
//  Copyright © 2016年 mibo02. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
/**
 *  显示loading动画
 */
- (void)showProgressHUD;
/**
 *  隐藏loading动画
 */
- (void)hideProgressHUD;

//显示带有文字的loading
- (void)showProgressHUDWithThitle:(NSString *)title;

@end