//
//  BtnTitleView.h
//  TravelProjectA
//
//  Created by lanouhn on 16/6/8.
//  Copyright © 2016年 申红涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BtnTitleView : UIView

/**定义btn点击回调的block*/
@property (nonatomic, copy) void(^BtnClickedBlock)(NSInteger index);

/**自定义初始化方法*/
- (instancetype)initWithFrame:(CGRect)frame andTitleArray:(NSArray *)titleArray;


@end
