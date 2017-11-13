//
//  menuneirongCell.m
//  ShengShengManB
//
//  Created by mibo02 on 17/5/22.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "menuneirongCell.h"
#import "subcontentCell.h"
@interface menuneirongCell ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)zuopindetailModel *newdetailmodel;
@end

@implementation menuneirongCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
- (void)setDetailModel:(zuopindetailModel *)detailModel
{
    
    [self.headimg sd_setImageWithURL:[NSURL URLWithString:detailModel.userHead]];
    NSString *str = [TodayDate getgradefor:detailModel.grade];
    if (detailModel.nickName) {
        self.nickname.attributedText = [ZLabel attributedTextArray:@[detailModel.nickName,str] textColors:@[[UIColor blueColor],[UIColor blackColor]] textfonts:@[H15,H11]];
    }
    self.content.text = detailModel.content;
    self.newdetailmodel = detailModel;
    CGRect rect;
    if (detailModel.submodelarr.count != 0) {
       rect = [TodayDate getstrheightfornew:[detailModel.submodelarr[0] content]];
        self.tablevconstrHeight.constant = detailModel.submodelarr.count * (rect.size.height + 100);
        
    } else {
        self.tablevconstrHeight.constant = 0;
    }
    
    
    self.subtableview.delegate = self;
    self.subtableview.dataSource = self;
    [self.subtableview registerNib:[UINib nibWithNibName:@"subcontentCell" bundle:nil] forCellReuseIdentifier:@"subcell"];
    
    [self.subtableview reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.newdetailmodel.submodelarr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    subcontentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"subcell" forIndexPath:indexPath];
    
    contentsubmodel *model  = self.newdetailmodel.submodelarr[indexPath.row];
    NSString *str = [TodayDate getgradefor:model.grade];
    if (model.nickName) {
        cell.nicklab.attributedText = [ZLabel attributedTextArray:@[model.nickName,str] textColors:@[[UIColor blueColor],[UIColor blackColor]] textfonts:@[H15,H11]];
    }
    cell.timelab.text = [getTimes compareCurrentTime:model.time];
    
    [cell.leftimg sd_setImageWithURL:[NSURL URLWithString:model.userHead]];
    cell.contentlab.text = model.content;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    contentsubmodel *model  = self.newdetailmodel.submodelarr[indexPath.row];
    CGRect rect = [TodayDate getstrheightfornew:model.content];
    return 100 + rect.size.height;
}





@end
