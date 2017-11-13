//
//  toneModel.h
//  ShengShengManB
//
//  Created by mibo02 on 17/5/9.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "BaseModel.h"
@class subtoneModel;
@interface toneModel : BaseModel

@property (nonatomic, copy)NSString *id;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, assign)NSInteger sort;
@property (nonatomic, strong)NSMutableArray <subtoneModel *>*tonesarr;

@end


@interface subtoneModel : NSObject
@property (nonatomic, copy)NSString *toneId;
@property (nonatomic, copy)NSString *id;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, assign)NSInteger sort;
@property (nonatomic, copy)NSString *font;
@property (nonatomic, assign)BOOL isopen;

@end
