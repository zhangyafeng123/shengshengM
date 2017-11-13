//
//  zuopindetailViewController.h
//  ShengShengManB
//
//  Created by mibo02 on 17/5/22.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "BaseViewController.h"

@interface zuopindetailViewController : BaseViewController
@property (nonatomic, copy)NSString *newid;
//标题
@property (nonatomic, copy)NSString *titlestr;
//头像
@property (nonatomic, copy)NSString *headImg;
//是否收藏
@property (nonatomic, assign)NSInteger isshoucangnum;
//是否点赞
@property (nonatomic, assign)NSInteger islike;
//是否居中
@property (nonatomic, assign)NSInteger iscenter;


@end
