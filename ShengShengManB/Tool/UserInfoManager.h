//
//  UserInfoManager.h
//  TravelProjectA
//
//  Created by lanouhn on 16/6/17.
//  Copyright © 2016年 申红涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersonModel.h"
@interface UserInfoManager : NSObject

/**
 *  保存用户信息
 */
+ (void)saveUserInfoWithModel:(PersonModel *)entity;

/**
 *  清空用户信息
 */
+ (void)cleanUserInfo;

/**
 *  获取用户信息
 */
+ (PersonModel *)getUserInfo;

/**
 *  判断用户是否登录
 */
+ (BOOL)isLoading;


@end
