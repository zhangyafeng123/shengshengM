//
//  zuopindetailCell.h
//  ShengShengManB
//
//  Created by mibo02 on 17/5/22.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface zuopindetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *headimg;
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UILabel *liulanlab;
@property (weak, nonatomic) IBOutlet UIButton *shoucangbtn;
@property (weak, nonatomic) IBOutlet UILabel *contentlab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintNew;

@property (weak, nonatomic) IBOutlet UIView *imgbackV;
@property (weak, nonatomic) IBOutlet UIButton *leftbtn;
@property (weak, nonatomic) IBOutlet UIButton *centerbtn;
@property (weak, nonatomic) IBOutlet UIButton *rightbtn;
@end
