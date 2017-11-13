//
//  dashangnewmodel.h
//  ShengShengManB
//
//  Created by mibo02 on 17/4/27.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "BaseModel.h"

@interface dashangnewmodel : BaseModel

@property (nonatomic, copy)NSString *outline;
@property (nonatomic, assign)CGFloat money;
@property (nonatomic, copy)NSString *id;
@property (nonatomic, copy)NSString *time;
@property (nonatomic, copy)NSString *title;
//是否支付
@property (nonatomic, assign)BOOL possess;

@end
