//
//  guanzhuModel.h
//  ShengShengManB
//
//  Created by mibo02 on 17/7/25.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "BaseModel.h"
@class guanzhusubModel;
@interface guanzhuModel : BaseModel


@property (nonatomic, strong)guanzhusubModel *bbsbody;
@property (nonatomic, assign)BOOL isRiokin;
@property (nonatomic, assign)BOOL isCollect;

@end

@interface guanzhusubModel : guanzhuModel

@property (nonatomic, copy)NSString *poetry_notes;
@property (nonatomic, copy)NSString *subject;
@property (nonatomic, copy)NSString *id;
@property (nonatomic, copy)NSString *rhythm_id;
@property (nonatomic, assign)NSInteger comments_number;
@property (nonatomic, copy)NSString *user_head;
@property (nonatomic, copy)NSString *nick_name;
@property (nonatomic, copy)NSString *user_id;
@property (nonatomic, copy)NSString *type;
@property (nonatomic, assign)NSInteger relay_number;
@property (nonatomic, copy)NSString *yunyun_id;
@property (nonatomic, copy)NSString *poetry_id;
@property (nonatomic, assign)NSInteger collect_number;
@property (nonatomic, copy)NSString *images;
@property (nonatomic, copy)NSString *create_time;
@property (nonatomic, assign)NSInteger browse_number;
@property (nonatomic, assign)NSInteger grade;
@property (nonatomic, assign)NSInteger riokin_number;
@end
