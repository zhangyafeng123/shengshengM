//
//  mdfivetool.m
//  PractiseA
//
//  Created by mibo02 on 17/5/12.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "mdfivetool.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation mdfivetool
#pragma mark - 32位 大写

+(NSString *)MD5ForUpper32Bate:(NSString *)str{
    
    //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02X", result[i]];
    }
    
    return digest;
}
//检查网络连接状况
+(void)checkinternationInfomation:(NSError*)error
{
    if (error.code == -1009) {
        [MBProgressHUD showError:@"请检查网络"];
    }
}


@end
