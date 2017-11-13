//
//  mdfivetool.h
//  PractiseA
//
//  Created by mibo02 on 17/5/12.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface mdfivetool : NSObject

/**
 *  MD5加密, 32位 大写
 *
 *  @param str 传入要加密的字符串
 *
 *  @return 返回加密后的字符串
 */
+(NSString *)MD5ForUpper32Bate:(NSString *)str;

//检查网络连接状况
+(void)checkinternationInfomation:(NSError*)error;

@end
