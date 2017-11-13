//
//  menuneirongCell.h
//  ShengShengManB
//
//  Created by mibo02 on 17/5/22.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "zuopindetailModel.h"
@interface menuneirongCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headimg;
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tablevconstrHeight;
@property (weak, nonatomic) IBOutlet UITableView *subtableview;

@property (nonatomic, strong)zuopindetailModel *detailModel;



@end
