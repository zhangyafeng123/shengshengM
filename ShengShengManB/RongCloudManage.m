//
//  RongCloudManage.m
//  ShengShengManB
//
//  Created by mibo02 on 17/5/25.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "RongCloudManage.h"
#import "AppDelegate.h"

@implementation RongCloudManage
{
    NSMutableArray *dataSoure;
    
    NSMutableArray *_userIdArray;
    NSMutableArray *_nameArray;
    NSMutableArray *_urlArray;
}
- (instancetype)init
{
    if (self = [super init]) {
        
        [self createDateSource];
        [RCIM sharedRCIM].userInfoDataSource = self;
        [RCIM sharedRCIM].groupInfoDataSource = self;
        
    }
    return self;
}
+ (instancetype)shareDataManage
{
    static RongCloudManage *manage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manage = [[RongCloudManage alloc] init];
    });
    return manage;
}

#pragma mark - loginRogCloud
-(void)loginRongCloudWithUserInfo:(RCUserInfo *)userInfo withToken:(NSString *)token{
    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
        [RCIM sharedRCIM].globalNavigationBarTintColor = [UIColor redColor];
        NSLog(@"login success with userId %@",userId);
        //同步好友列表
        [self syncFriendList:^(NSMutableArray *friends, BOOL isSuccess) {
            
        }];
        [RCIMClient sharedRCIMClient].currentUserInfo = userInfo;
      
    } error:^(RCConnectErrorCode status) {
        NSLog(@"status = %ld",(long)status);
    } tokenIncorrect:^{
        NSLog(@"token 错误");
    }];
}

- (void)createDateSource
{
    
    
    _userIdArray = [NSMutableArray new];
    _nameArray = [NSMutableArray new];
    _urlArray = [NSMutableArray new];
    
            [NetWorkManager requestForGetWithUrl:[NSString  stringWithFormat:@"%@?token=%@",friendlistURL,[UserInfoManager getUserInfo].token] parameter:@{} success:^(id reponseObject) {
                for (NSDictionary *dic in reponseObject[@"result"][@"list"]) {
                    [_userIdArray addObject:dic[@"id"]];
                    if (dic[@"nick_name"] == [NSNull null]) {
                        [_nameArray addObject:@""];
                    } else {
                        [_nameArray addObject:dic[@"nick_name"]];
                    }
                    
                    if (dic[@"user_head"] == [NSNull null]) {
                        [_urlArray addObject:@""];
                    } else {
                       [_urlArray addObject:dic[@"user_head"]];
                    }
                    
                }
                
            } failure:^(NSError *error) {
                [mdfivetool checkinternationInfomation:error];
               
            }];
   
  
}


-(BOOL)hasTheFriendWithUserId:(NSString *)userId
{
    
    if (self.friendsArray) {
        NSMutableArray *tempArray = [[NSMutableArray alloc]init];
        
        for (RCUserInfo *aUserInfo in self.friendsArray) {
            [tempArray addObject:aUserInfo.userId];
        }
        
        if ([tempArray containsObject:userId]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)hasTheGroupWithGroupId:(NSString *)groupId
{
    NSLog(@"group-->%@<--", self.groupsArray);
    if (self.groupsArray.count) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (RCGroup *aGroupInfo in self.groupsArray) {
            [tempArray addObject:aGroupInfo.groupId];
        }
        if ([tempArray containsObject:groupId]) {
            return YES;
        }
    }
    return NO;
}
/**
 *  从服务器同步好友列表
 */
-(void)syncFriendList:(void (^)(NSMutableArray* friends,BOOL isSuccess))completion
{
    dataSoure = [[NSMutableArray alloc]init];
    
    for (NSInteger i = 0; i<_nameArray.count; i++) {
        
        RCUserInfo *aUserInfo =[[RCUserInfo alloc]initWithUserId:_userIdArray[i] name:_nameArray[i] portrait:_urlArray[i]];
        [dataSoure addObject:aUserInfo];
        
    }
    self.friendsArray = dataSoure;
    completion(dataSoure,YES);
    
}
/**
 *  从服务器同步群组列表
 */
-(void) syncGroupList:(void (^)(NSMutableArray * groups,BOOL isSuccess))completion{
    if (self.groupsArray) {
        [self.groupsArray removeAllObjects];
    }
    NSMutableArray *_dataSourceGroup = [[NSMutableArray alloc] init];
    for (NSInteger i = 1; i<3; i++) {
        if (i==1){
            RCGroup *aGroup = [[RCGroup alloc]initWithGroupId:@"8888888" groupName:@"医食保健群_an" portraitUri:@"http://farm2.staticflickr.com/1715/23815656639_ef86cf1498_m.jpg"];
            [_dataSourceGroup addObject:aGroup];
            
        }
        else if (i==2){
            RCGroup *aGroup = [[RCGroup alloc]initWithGroupId:@"66666666" groupName:@"青龙帮" portraitUri:@"http://farm2.staticflickr.com/1455/23888379640_edf9fce919_m.jpg"];
            [_dataSourceGroup addObject:aGroup];
        }
    }
    //    NSLog(@"111->>>%@", _dataSourceGroup);
    self.groupsArray = _dataSourceGroup;
    completion(self.groupsArray,YES);
    
}
#pragma mark
#pragma mark 根据userId获取RCUserInfo
-(RCUserInfo *)currentUserInfoWithUserId:(NSString *)userId{
    for (NSInteger i = 0; i<self.friendsArray.count; i++) {
        RCUserInfo *aUser = self.friendsArray[i];
        if ([userId isEqualToString:aUser.userId]) {
            NSLog(@"current ＝ %@",aUser.name);
            return aUser;
        }
    }
    return nil;
}
#pragma mark
#pragma mark 根据userId获取RCGroup
-(RCGroup *)currentGroupInfoWithGroupId:(NSString *)groupId{
    for (NSInteger i = 0; i<self.groupsArray.count; i++) {
        RCGroup *aGroup = self.groupsArray[i];
        if ([groupId isEqualToString:aGroup.groupId]) {
            return aGroup;
        }
    }
    return nil;
}
-(NSString *)currentNameWithUserId:(NSString *)userId{
    for (NSInteger i = 0; i < self.friendsArray.count; i++) {
        RCUserInfo *aUser = self.friendsArray[i];
        if ([userId isEqualToString:aUser.userId]) {
            NSLog(@"current ＝ %@",aUser.name);
            return aUser.name;
        }
    }
    return nil;
}

#pragma mark - RCIMUserInfoDataSource
- (void)getUserInfoWithUserId:(NSString*)userId completion:(void (^)(RCUserInfo*))completion
{
    NSLog(@"getUserInfoWithUserId ----- %@", userId);
    
    if (userId == nil || [userId length] == 0 )
    {
        [self syncFriendList:^(NSMutableArray *friends, BOOL isSuccess) {
            
        }];
        
        completion(nil);
        return ;
    }
    
    if ([userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
        RCUserInfo *myselfInfo = [[RCUserInfo alloc]initWithUserId:[RCIM sharedRCIM].currentUserInfo.userId name:[RCIM sharedRCIM].currentUserInfo.name portrait:[RCIM sharedRCIM].currentUserInfo.portraitUri];
        completion(myselfInfo);
        
    }
    
    for (NSInteger i = 0; i < self.friendsArray.count; i++) {
        RCUserInfo *aUser = self.friendsArray[i];
        if ([userId isEqualToString:aUser.userId]) {
            completion(aUser);
            break;
        }
    }
}

#pragma mark - RCIMGroupInfoDataSource
- (void)getGroupInfoWithGroupId:(NSString *)groupId
                     completion:(void (^)(RCGroup *groupInfo))completion{
    for (NSInteger i = 0; i < self.groupsArray.count; i++) {
        RCGroup *aGroup = self.groupsArray[i];
        if ([groupId isEqualToString:aGroup.groupId]) {
            completion(aGroup);
            break;
        }
    }
}

@end

