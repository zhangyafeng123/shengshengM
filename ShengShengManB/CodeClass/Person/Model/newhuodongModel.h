//
//  newhuodongModel.h
//  ShengShengManB
//
//  Created by mibo02 on 17/6/2.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "BaseModel.h"

@interface newhuodongModel : BaseModel

@property (nonatomic, copy)NSString *id;
@property (nonatomic, copy)NSString *signup_end_time;
@property (nonatomic, copy)NSString *activity_end_time;
@property (nonatomic, copy)NSString *contact_phone;
@property (nonatomic, copy)NSString *activity_sta_time;
@property (nonatomic, copy)NSString *picture;
@property (nonatomic, copy)NSString *activity_state;
@property (nonatomic, copy)NSString *user_id;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, assign)CGFloat budget_money;
@property (nonatomic, copy)NSString *address;
@property (nonatomic, assign)NSInteger max_people_number;
@property (nonatomic, assign)NSInteger attend_people_number;
@property (nonatomic, copy)NSString *create_time;
@property (nonatomic, copy)NSString *demand;
@property (nonatomic, copy)NSString *content;

@end
