//
//  cidetailViewController.h
//  ShengShengManB
//
//  Created by mibo02 on 17/5/9.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "BaseViewController.h"

@interface cidetailViewController : BaseViewController
@property (nonatomic, strong)NSArray *newarr;

//韵书
@property (nonatomic, copy)NSString *yunshustr;
@property (nonatomic, copy)NSString *name;
//词
@property (nonatomic, copy)NSString *headid;
@property (nonatomic, copy)NSString *rhythmid;

//定义
@property (nonatomic, copy)NSString *body;
@property (nonatomic, copy)NSString *images;
@property (nonatomic, copy)NSString *poetry_notes;
//韵书id
@property (nonatomic, copy)NSString *yunid;


@property (nonatomic, copy)NSString *titlestr;

@property (nonatomic, copy)NSString *edittitle;

@end
