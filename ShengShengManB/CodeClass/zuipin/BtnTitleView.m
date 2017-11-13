//
//  BtnTitleView.m
//  TravelProjectA
//
//  Created by lanouhn on 16/6/8.
//  Copyright © 2016年 申红涛. All rights reserved.
//

#import "BtnTitleView.h"

@interface BtnTitleView ()
@property (nonatomic, strong)NSMutableArray *arr;
@end

@implementation BtnTitleView


/**自定义初始化方法*/
- (instancetype)initWithFrame:(CGRect)frame andTitleArray:(NSArray *)titleArray{
    if (self = [super initWithFrame:frame]) {
        self.arr = [NSMutableArray new];
        for (int i = 0; i < titleArray.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i * SCREEN_WIDTH / titleArray.count, 0, SCREEN_WIDTH / titleArray.count,40);
            [btn setTitle:titleArray[i] forState:(UIControlStateNormal)];
            btn.backgroundColor = [UIColor whiteColor];
            [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            [btn setTitleColor:NavColor forState:(UIControlStateSelected)];
            btn.tag = 190 + i;
            btn.titleLabel.font = H15;
            [btn addTarget:self action:@selector(btnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
            [self addSubview:btn];
            if (i == 0) {
                btn.selected = YES;
            }
            [self.arr addObject:btn];
        }
    }
    return self;
}

- (void)btnClicked:(UIButton *)sender{
     [self btselectedornot:sender];
    if (self.BtnClickedBlock) {
        self.BtnClickedBlock(sender.tag - 190);
    }
}

- (void)btselectedornot:(UIButton *)sender
{
    for (UIButton *btn in self.arr) {
        if (btn.tag  == sender.tag) {
            btn.selected = YES;
        } else {
            btn.selected = NO;
        }
    }
}

@end
