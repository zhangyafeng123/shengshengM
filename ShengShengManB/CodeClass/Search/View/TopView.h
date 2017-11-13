//
//  TopView.h
//  ShengShengManB
//
//  Created by mibo02 on 17/1/12.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopView : UIView

@property (nonatomic, strong)UILabel *titleLab, *timeLab, *AuthorLab;
@property (nonatomic, strong)UITapGestureRecognizer *tap;
- (instancetype)initWithFrame:(CGRect)frame;

@end
