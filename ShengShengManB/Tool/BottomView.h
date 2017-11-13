//
//  BottomView.h
//  ShengShengManB
//
//  Created by mibo02 on 17/1/10.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BottomView : UIView
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIButton *AddButton;

@property (weak, nonatomic) IBOutlet UIImageView *firstImage;

@property (weak, nonatomic) IBOutlet UIImageView *secondImage;
@property (weak, nonatomic) IBOutlet UIImageView *threeImage;


@end
