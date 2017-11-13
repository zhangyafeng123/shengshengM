//
//  HomeCell.m
//  ShengShengManA
//
//  Created by mibo02 on 16/12/14.
//  Copyright © 2016年 mibo02. All rights reserved.
//

#import "HomeCell.h"

@implementation HomeCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, self.frame.size.width  - 60, self.frame.size.width - 60)];
        
        self.imageView.layer.cornerRadius = (self.frame.size.width - 60)/ 2;
        self.imageView.layer.masksToBounds = YES;
        self.imageView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.imageView];
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imageView.frame) , self.frame.size.width, self.frame.size.height - self.imageView.frame.size.height)];
        self.titleLab.backgroundColor = [UIColor clearColor];
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLab];
    }
    return self;
}
@end
