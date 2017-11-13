//
//  tongyongCell.h
//  ShengShengManB
//
//  Created by mibo02 on 17/5/20.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tongyongCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *imgbackview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnconstraint;
@property (weak, nonatomic) IBOutlet UIButton *headimg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintview;

@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UILabel *liulanlab;
@property (weak, nonatomic) IBOutlet UIButton *shoucangbtn;
@property (weak, nonatomic) IBOutlet UILabel *contentlab;

@property (weak, nonatomic) IBOutlet UIButton *leftimglab;
@property (weak, nonatomic) IBOutlet UIButton *centerlab;
@property (weak, nonatomic) IBOutlet UIButton *rightlab;
@property (weak, nonatomic) IBOutlet UIButton *zhuanfabtn;
@property (weak, nonatomic) IBOutlet UIButton *pinglunbtn;
@property (weak, nonatomic) IBOutlet UIButton *dianzanbtn;
@property (weak, nonatomic) IBOutlet UIButton *editbutton;

@end
