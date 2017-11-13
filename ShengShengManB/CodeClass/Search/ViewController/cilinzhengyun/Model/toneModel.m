//
//  toneModel.m
//  ShengShengManB
//
//  Created by mibo02 on 17/5/9.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "toneModel.h"

@implementation toneModel

- (instancetype)init
{
    self  = [super init];
    if (self) {
        self.tonesarr = [NSMutableArray new];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"tones"]) {
        for (NSDictionary *dic in value) {
            subtoneModel *model = [subtoneModel new];
            [model setValuesForKeysWithDictionary:dic];
            [self.tonesarr addObject:model];
        }
        
    }
}
@end

@implementation subtoneModel



@end
