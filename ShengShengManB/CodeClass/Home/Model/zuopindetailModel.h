//
//  zuopindetailModel.h
//  ShengShengManB
//
//  Created by mibo02 on 17/7/21.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "BaseModel.h"
@class contentsubmodel;
@interface zuopindetailModel : BaseModel
//relay
@property (nonatomic, copy)NSString *bbs_body_id;
@property (nonatomic, copy)NSString *nick_name;
@property (nonatomic, copy)NSString *user_head;
@property (nonatomic, copy)NSString *id;
@property (nonatomic, assign)NSInteger grade;
@property (nonatomic, copy)NSString *create_time;
@property (nonatomic, copy)NSString *user_id;
@property (nonatomic, copy)NSString *relay_type;
//comments
@property (nonatomic, copy)NSString *userId;
@property (nonatomic, copy)NSString *time;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *userHead;
@property (nonatomic, copy)NSString *bbsid;
@property (nonatomic, copy)NSString *nickName;
@property (nonatomic, strong)NSMutableArray<contentsubmodel *> *submodelarr;

@end

@interface contentsubmodel : NSObject

@property (nonatomic, copy)NSString *userId;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *time;
@property (nonatomic, copy)NSString *id;
@property (nonatomic, copy)NSString *userHead;
@property (nonatomic, assign)NSInteger grade;
@property (nonatomic, copy)NSString *nickName;
@end




