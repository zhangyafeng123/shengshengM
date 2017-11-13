//
//  RongCloudManage.h
//  ShengShengManB
//
//  Created by mibo02 on 17/5/25.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMKit/RongIMKit.h>
@interface RongCloudManage : NSObject<RCIMUserInfoDataSource, RCIMGroupInfoDataSource>
@property (nonatomic, strong) NSMutableArray *friendsArray;//好友数组
@property (nonatomic, strong) NSMutableArray *groupsArray; //群组数组

//单例类
+ (instancetype)shareDataManage;

//登录
-(void)loginRongCloudWithUserInfo:(RCUserInfo *)userInfo withToken:(NSString *)token;

//通过userid得到RCUserInfo
- (void)getUserInfoWithUserId:(NSString*)userId completion:(void (^)(RCUserInfo*))completion;

//好友中是否有这个userid
-(BOOL)hasTheFriendWithUserId:(NSString *)userId;

//群组中是否有这个groupid
- (BOOL)hasTheGroupWithGroupId:(NSString *)groupId;

// 从服务器同步好友列表
-(void) syncFriendList:(void (^)(NSMutableArray * friends,BOOL isSuccess))completion;

// 从服务器同步群组列表
-(void) syncGroupList:(void (^)(NSMutableArray * groups,BOOL isSuccess))completion;


//根据用户参数的id获取当前用户的name
-(NSString *)currentNameWithUserId:(NSString *)userId;

//根据用户参数的id（userId）获取RCUserInfo
-(RCUserInfo *)currentUserInfoWithUserId:(NSString *)userId;

//根据群组的id（groupId）获取RCGroup
-(RCGroup *)currentGroupInfoWithGroupId:(NSString *)groupId;
@end
