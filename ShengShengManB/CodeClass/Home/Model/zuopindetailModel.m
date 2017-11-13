//
//  zuopindetailModel.m
//  ShengShengManB
//
//  Created by mibo02 on 17/7/21.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "zuopindetailModel.h"

@implementation zuopindetailModel
- (instancetype)init
{
    self  = [super init];
    if (self) {
        self.submodelarr  = [NSMutableArray new];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"replys"]) {
        for (NSDictionary *dic in value) {
            contentsubmodel *model = [contentsubmodel new];
            [model setValuesForKeysWithDictionary:dic];
            [self.submodelarr addObject:model];
        }
    }
}

@end
@implementation contentsubmodel



@end
