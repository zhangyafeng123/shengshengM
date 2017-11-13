//
//  PersonModel.m
//  ShengShengManB
//
//  Created by mibo02 on 17/4/25.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "PersonModel.h"

@implementation PersonModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _token  = [aDecoder decodeObjectForKey:@"token"];
        _nick_name = [aDecoder decodeObjectForKey:@"nick_name"];
        _rong_token = [aDecoder decodeObjectForKey:@"rong_token"];
        _id = [aDecoder decodeObjectForKey:@"id"];
        _user_head = [aDecoder decodeObjectForKey:@"user_head"];
//        _sex = [aDecoder decodeObjectForKey:@"sex"];
//        _autograph = [aDecoder decodeObjectForKey:@"autograph"];
//        _user_state = [aDecoder decodeObjectForKey:@"user_state"];
//        _password = [aDecoder decodeObjectForKey:@"password"];
//        _integral = [aDecoder decodeIntegerForKey:@"integral"];
//        _referral_code = [aDecoder decodeObjectForKey:@"referral_code"];
//        _reg_time = [aDecoder decodeObjectForKey:@"reg_time"];
//        _id = [aDecoder decodeObjectForKey:@"id"];
//        _region = [aDecoder decodeObjectForKey:@"region"];
//        _account = [aDecoder decodeObjectForKey:@"account"];
//        _email = [aDecoder decodeObjectForKey:@"email"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_token forKey:@"token"];
    [aCoder encodeObject:_nick_name forKey:@"nick_name"];
    [aCoder encodeObject:_rong_token forKey:@"rong_token"];
    [aCoder encodeObject:_id forKey:@"id"];
    [aCoder encodeObject:_user_head forKey:@"user_head"];
//    [aCoder encodeObject:_sex forKey:@"sex"];
//    [aCoder encodeObject:_autograph forKey:@"autograph"];
//    [aCoder encodeObject:_user_state forKey:@"user_state"];
//    [aCoder encodeObject:_password forKey:@"password"];
//    [aCoder encodeInteger:_integral forKey:@"integral"];
//    [aCoder encodeObject:_referral_code forKey:@"referral_code"];
//    [aCoder encodeObject:_reg_time forKey:@"reg_time"];
//    [aCoder encodeObject:_id forKey:@"id"];
//    [aCoder encodeObject:_region forKey:@"region"];
//    [aCoder encodeObject:_account forKey:@"account"];
//    [aCoder encodeObject:_email forKey:@"email"];
    
}

@end
