//
//  shidetailViewController.h
//  ShengShengManB
//
//  Created by mibo02 on 17/5/9.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "BaseViewController.h"

@interface shidetailViewController : BaseViewController

@property (nonatomic, strong)NSArray *newarr;

@property (nonatomic, copy)NSString *name;

//韵书
@property (nonatomic, copy)NSString *yunshustr;

//诗词曲编号
@property (nonatomic, copy)NSString *headid;
@property (nonatomic, copy)NSString *rhythmid;

//合诗传过来的标题
@property (nonatomic, copy)NSString *namestr;
//合诗的内容
@property (nonatomic, copy)NSString *subjectstr;

//定义
@property (nonatomic, copy)NSString *body;
@property (nonatomic, copy)NSString *images;
@property (nonatomic, copy)NSString *poetry_notes;

//韵书id
@property (nonatomic, copy)NSString *yunid;

//上个界面的标题
@property (nonatomic, copy)NSString *titlestr;

//标题(编辑)
@property (nonatomic, copy)NSString *edittitle;

@end
