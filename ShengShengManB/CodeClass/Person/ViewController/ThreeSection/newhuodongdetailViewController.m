//
//  newhuodongdetailViewController.m
//  ShengShengManB
//
//  Created by mibo02 on 17/6/2.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "newhuodongdetailViewController.h"
#import "jiebanddetailimgCell.h"
#import "jiebancontentCell.h"
#import "huodongmenViewController.h"
@interface newhuodongdetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation newhuodongdetailViewController

- (IBAction)seeperson:(UIButton *)sender {
    huodongmenViewController *huodong =[huodongmenViewController new];
    huodong.firststr = self.model.id;
    [self.navigationController pushViewController:huodong animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动详情";
    [self.tableview registerNib:[UINib nibWithNibName:@"jiebancontentCell" bundle:nil] forCellReuseIdentifier:@"contentcell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"jiebanddetailimgCell" bundle:nil] forCellReuseIdentifier:@"jiebanimg"];
   
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 12;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *str = @"str";
        UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:str];
        }
        
        cell.textLabel.text = self.model.title;
        
        return cell;
    } else if (indexPath.row == 1 ){
        jiebanddetailimgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jiebanimg" forIndexPath:indexPath];
        
        cell.leftlab.text = [NSString stringWithFormat:@"发起人:%@",[UserInfoManager getUserInfo].nick_name];
        
        
        cell.rightlab.text = self.model.create_time;
        if (![self.model.picture isEqualToString:@""]) {
            NSArray *arr = [self.model.picture componentsSeparatedByString:@"|"];
            if (arr.count != 0) {
                if ([arr[0] isEqualToString:@""]) {
                    
                    if ([arr[1] hasPrefix:@"http"]) {
                        [cell.bigimg sd_setImageWithURL:[NSURL URLWithString:arr[1]]];
                    } else {
                        [cell.bigimg sd_setImageWithURL:[NSURL URLWithString:ImageViewURL(arr[1])]];
                    }
                    
                    
                } else {
                    
                    if ([arr[0] hasPrefix:@"http"]) {
                        [cell.bigimg sd_setImageWithURL:[NSURL URLWithString:arr[0]]];
                    } else {
                        [cell.bigimg sd_setImageWithURL:[NSURL URLWithString:ImageViewURL(arr[0])]];
                    }
                    
                }
                
            }
        }
        
        return cell;
    } else if (indexPath.row == 2 || indexPath.row == 3){
        jiebancontentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contentcell" forIndexPath:indexPath];
        if (indexPath.row == 2) {
            cell.titleLab.text = @"【活动内容】:";
            cell.contentLab.text = self.model.content;
        } else {
            cell.titleLab.text = @"【活动要求】:";
            cell.contentLab.text = self.model.demand;
        }
        return cell;
    } else {
        static NSString *str = @"strnew";
        UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:str];
        }
        cell.selectionStyle = NO;
        
        if (indexPath.row == 4) {
            cell.textLabel.text = [NSString stringWithFormat:@"【每人预算费用】:%.1f元/人",self.model.budget_money];
        } else if (indexPath.row == 5){
            cell.textLabel.text = [NSString stringWithFormat:@"【活动地址】:%@",self.model.address];
        }else if (indexPath.row == 6){
            cell.textLabel.text = [NSString stringWithFormat:@"【活动开始时间】:%@",self.model.activity_sta_time];
        } else if (indexPath.row == 7){
            cell.textLabel.text = [NSString stringWithFormat:@"【活动结束时间】:%@",self.model.activity_end_time];
        } else if (indexPath.row == 8){
            cell.textLabel.text = [NSString stringWithFormat:@"【已参加人数】:%ld人",self.model.attend_people_number];
        } else if (indexPath.row == 9){
            cell.textLabel.text = [NSString stringWithFormat:@"【活动上限人数】:%ld人",self.model.max_people_number];
        } else if (indexPath.row == 10){
            cell.textLabel.text = [NSString stringWithFormat:@"【联系方式】:%@",self.model.contact_phone];
        } else if (indexPath.row == 11){
            cell.textLabel.text = [NSString stringWithFormat:@"【报名截止时间】:%@",self.model.signup_end_time];
        }
        
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        if ([_model.picture isEqualToString:@""]) {
            return 44;
        } else {
          return 250;
        }
        
    } else if (indexPath.row == 2 || indexPath.row == 3){
        return 102;
    } else {
        return 44;
    }
}



@end
