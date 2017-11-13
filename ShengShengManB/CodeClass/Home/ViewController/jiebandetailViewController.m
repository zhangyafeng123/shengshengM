//
//  jiebandetailViewController.m
//  ShengShengManB
//
//  Created by mibo02 on 17/4/25.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "jiebandetailViewController.h"
#import "jiebanddetailimgCell.h"
#import "jiebancontentCell.h"
@interface jiebandetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UIButton *bottombtn;

@end

@implementation jiebandetailViewController
- (IBAction)baomingaction:(UIButton *)sender {
    //报名
    [self request];
}
- (void)request
{
    
    [NetWorkManager requestForPostWithUrl:signupURL parameter:@{@"token":[UserInfoManager getUserInfo].token,@"activity_id":self.model.activity.id} success:^(id reponseObject) {
        [MBProgressHUD showError:reponseObject[@"msg"]];
        if ([reponseObject[@"code"] integerValue] == 1) {
            [self.navigationController popViewControllerAnimated: YES];
        }
        
    } failure:^(NSError *error) {
        [mdfivetool checkinternationInfomation:error];
        [self hideProgressHUD];
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动详情";
    [self.tableview registerNib:[UINib nibWithNibName:@"jiebancontentCell" bundle:nil] forCellReuseIdentifier:@"contentcell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"jiebanddetailimgCell" bundle:nil] forCellReuseIdentifier:@"jiebanimg"];
    if (self.model.isSignup) {
        [self.bottombtn setTitle:@"已报名" forState:(UIControlStateNormal)];
        self.bottombtn.enabled = NO;
    }
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
        
        cell.textLabel.text = self.model.activity.title;
       
        return cell;
    } else if (indexPath.row == 1 ){
        jiebanddetailimgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jiebanimg" forIndexPath:indexPath];
        if (self.model.activity.nick_name.length == 0) {
            cell.leftlab.text = @"发起人:系统发起";
        } else {
            cell.leftlab.text = [NSString stringWithFormat:@"发起人:%@",self.model.activity.nick_name];
        }
        
        cell.rightlab.text = self.model.activity.create_time;
        if (![self.model.activity.picture isEqualToString:@""]) {
            NSArray *arr = [self.model.activity.picture componentsSeparatedByString:@"|"];
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
        cell.bigimg.contentMode = UIViewContentModeScaleAspectFit;
        return cell;
    } else if (indexPath.row == 2 || indexPath.row == 3){
        jiebancontentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contentcell" forIndexPath:indexPath];
        if (indexPath.row == 2) {
            cell.titleLab.text = @"【活动内容】:";
            cell.contentLab.text = self.model.activity.content;
        } else {
            cell.titleLab.text = @"【活动要求】:";
            cell.contentLab.text = self.model.activity.demand;
        }
        return cell;
    } else {
        static NSString *str = @"strnew";
        UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:str];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 4) {
            cell.textLabel.text = [NSString stringWithFormat:@"【每人预算费用】:%.1f元/人",self.model.activity.budget_money];
        } else if (indexPath.row == 5){
            cell.textLabel.text = [NSString stringWithFormat:@"【活动地址】:%@",self.model.activity.address];
        }else if (indexPath.row == 6){
            cell.textLabel.text = [NSString stringWithFormat:@"【活动开始时间】:%@",self.model.activity.activity_sta_time];
        } else if (indexPath.row == 7){
             cell.textLabel.text = [NSString stringWithFormat:@"【活动结束时间】:%@",self.model.activity.activity_end_time];
        } else if (indexPath.row == 8){
             cell.textLabel.text = [NSString stringWithFormat:@"【已参加人数】:%ld人",self.model.activity.attend_people_number];
        } else if (indexPath.row == 9){
             cell.textLabel.text = [NSString stringWithFormat:@"【活动上限人数】:%ld人",self.model.activity.max_people_number];
        } else if (indexPath.row == 10){
            cell.textLabel.text = [NSString stringWithFormat:@"【联系方式】:%@",self.model.activity.contact_phone];
        } else if (indexPath.row == 11){
            cell.textLabel.text = [NSString stringWithFormat:@"【报名截止时间】:%@",self.model.activity.signup_end_time];
        }
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = H14;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGRect rect = [TodayDate getstringheightfor:self.model.activity.content];
    CGRect rect1 = [TodayDate getstringheightfor:self.model.activity.demand];
    CGRect rect2 = [TodayDate getstringheightfor:self.model.activity.address];
    if (indexPath.row == 1) {
        if ([self.model.activity.picture isEqualToString:@""]) {
            return 44;
        } else {
            return 250;
        }
        
    } else if (indexPath.row == 2){
        return rect.size.height + 40;
    } else if ( indexPath.row == 3) {
        return rect1.size.height + 40;
    } else if (indexPath.row == 5){
        return rect2.size.height + 10;
    } else {
        return 44;
    }
}


@end
