//
//  TopView.m
//  ShengShengManB
//
//  Created by mibo02 on 17/1/12.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "TopView.h"

@implementation TopView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 25)];
        self.titleLab.text = @"标题";
        self.titleLab.font = [UIFont systemFontOfSize:20];
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLab];
        //
        self.timeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLab.frame) + 10, SCREEN_WIDTH, 20)];
        self.timeLab.textAlignment = NSTextAlignmentCenter;
        self.timeLab.text = @"当代";
        [self addSubview:self.timeLab];
        //
        self.AuthorLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.timeLab.frame) + 10, SCREEN_WIDTH, 25)];
        
        self.AuthorLab.text = [NSString stringWithFormat:@"%@",[UserInfoManager getUserInfo].nick_name];
        self.AuthorLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.AuthorLab];
        
        self.tap = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:self.tap];
    }
    return self;
}

@end
