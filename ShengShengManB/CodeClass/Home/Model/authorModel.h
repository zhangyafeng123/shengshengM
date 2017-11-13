//
//  authorModel.h
//  ShengShengManB
//
//  Created by mibo02 on 17/6/29.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "BaseModel.h"

@interface authorModel : BaseModel

@property (nonatomic, assign)NSInteger works;
@property (nonatomic, copy)NSString *id;
@property (nonatomic, copy)NSString *user_head;
@property (nonatomic, assign)NSInteger grade;
@property (nonatomic, assign)NSInteger fans;
@property (nonatomic, copy)NSString *nick_name;

@end
