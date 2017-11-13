//
//  PersonModel.h
//  ShengShengManB
//
//  Created by mibo02 on 17/4/25.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "BaseModel.h"

@interface PersonModel : BaseModel<NSCoding>
@property (nonatomic, copy)NSString *token;
@property (nonatomic, copy)NSString *birthday;
@property (nonatomic, copy)NSString *user_head;
@property (nonatomic, copy)NSString *sex;
@property (nonatomic, copy)NSString *autograph;
@property (nonatomic, copy)NSString *user_state;
@property (nonatomic, copy)NSString *password;
@property (nonatomic, assign)NSInteger integral;
@property (nonatomic, copy)NSString *referral_code;
@property (nonatomic, copy)NSString *reg_time;
@property (nonatomic, copy)NSString *id;
@property (nonatomic, copy)NSString *region;
@property (nonatomic, copy)NSString *account;
@property (nonatomic, copy)NSString *email;
@property (nonatomic, assign)NSInteger grade;
@property (nonatomic , copy)NSString *nick_name;
@property (nonatomic, copy)NSString *rong_token;
@property (nonatomic, assign)NSInteger works;
@property (nonatomic, assign)NSInteger fans;







@end
