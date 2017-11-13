//
//  AppDelegate.m
//  ShengShengManB
//
//  Created by mibo02 on 16/12/16.
//  Copyright © 2016年 mibo02. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarViewController.h"
#import <RongIMLib/RongIMLib.h>
#import <RongIMKit/RongIMKit.h>
#import "UMessage.h"
#import "WXApi.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "RongCloudManage.h"
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "yindaopageViewController.h"
@interface AppDelegate ()<UNUserNotificationCenterDelegate,WXApiDelegate,RCIMUserInfoDataSource>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSUserDefaults *userdf = [NSUserDefaults standardUserDefaults];
   
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    if (![userdf boolForKey:@"isfirst"]) {
        //
        _window.rootViewController = [yindaopageViewController new];
    } else {
        // 启动图片延时: 1秒
        [NSThread sleepForTimeInterval:4];
        // 设置窗口的根控制器
        self.window.rootViewController = [[TabBarViewController alloc] init];
    }
   
    // 显示窗口
    [self.window makeKeyAndVisible];
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    //友盟推送配置
    [UMessage startWithAppkey:@"5910472b4544cb6cdf0012cb" launchOptions:launchOptions];
    
    //注册通知，如果要使用category的自定义策略，可以参考demo中的代码。
    [UMessage registerForRemoteNotifications];
    
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
        }
    }];
    
    //打开日志，方便调试
    [UMessage setLogEnabled:YES];
    
    NSString *str = [NSString stringWithFormat:@"%@?token=%@",gettokenURL,[UserInfoManager getUserInfo].token];
    
    NSLog(@"%@",str);
    [NetWorkManager requestForGetWithUrl:str parameter:@{} success:^(id reponseObject) {
        
        if ([reponseObject[@"code"] integerValue] == 1) {
            //融云配置
            [[RCIM sharedRCIM] initWithAppKey:@"0vnjpoad0c7dz"];
            [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
            [[RongCloudManage shareDataManage] loginRongCloudWithUserInfo:[[RCUserInfo alloc] initWithUserId:[UserInfoManager getUserInfo].id name:[UserInfoManager getUserInfo].nick_name portrait:[UserInfoManager getUserInfo].user_head] withToken:reponseObject[@"result"]];
        
        }
        
    } failure:^(NSError *error) {
        [mdfivetool checkinternationInfomation:error];
    }];
   
    //微信配置
    [WXApi registerApp:@"wx0603b9745356610a"];
    //shareSDK
    [self setshareSDK];
    return YES;
}
- (void)setshareSDK
{
    
    [ShareSDK registerApp:@"iosv1101"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeCopy),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx0603b9745356610a"
                                       appSecret:@"64020361b8ec4c99936c0e3999a9f249"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1106182700"
                                      appKey:@"VXxwill0cqgywYQo"
                                    authType:SSDKAuthTypeBoth];
                 break;
            default:
                 break;
         }
        
     }];
}
//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    [UMessage didReceiveRemoteNotification:userInfo];
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭U-Push自带的弹出框
       // [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    //用户可以在这个方法里面获取devicetoken
        NSLog(@"%@",[NSString  stringWithFormat:@"%@",[NSData dataWithData:deviceToken]]);
    
    NSLog(@"%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                  stringByReplacingOccurrencesOfString: @">" withString: @""]
                 stringByReplacingOccurrencesOfString: @" " withString: @""]);
    NSString *deviceStr = [NSString stringWithFormat:@"%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                                             stringByReplacingOccurrencesOfString: @">" withString: @""]
                                                            stringByReplacingOccurrencesOfString: @" " withString: @""]];
    NSLog(@"%@", deviceStr);
}
//9.0前的方法，为了适配低版本 保留
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [WXApi handleOpenURL:url delegate:self];
}
//9.0后的方法
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    return [WXApi handleOpenURL:url delegate:self];
}
#pragma mark - WXApiDelegate
-(void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp*response=(PayResp*)resp;  // 微信终端返回给第三方的关于支付结果的结构体
        switch (response.errCode) {
            case WXSuccess:
            {// 支付成功，向后台发送消息
                [MBProgressHUD showError:@"支付成功"];
            }
                break;
            case WXErrCodeCommon:
            { //签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等
                [MBProgressHUD showError:@"支付失败"];
                
            }
                break;
            case WXErrCodeUserCancel:
            { //用户点击取消并返回
                [MBProgressHUD showError:@"取消支付"];
                //发送通知返回到主界面
                [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelPay" object:nil];
            }
                break;
            case WXErrCodeSentFail:
            { //发送失败
                [MBProgressHUD showError:@"发送失败"];
            }
                break;
            case WXErrCodeUnsupport:
            { //微信不支持
                [MBProgressHUD showError:@"微信不支持"];
            }
                break;
            case WXErrCodeAuthDeny:
            { //授权失败
                [MBProgressHUD showError:@"授权失败"];
            }
                break;
            default:
                break;
        }
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {

}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
  
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
 
}
- (void)applicationWillTerminate:(UIApplication *)application {
   
}
@end
