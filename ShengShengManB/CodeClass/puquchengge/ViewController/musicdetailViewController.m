//
//  musicdetailViewController.m
//  ShengShengManB
//
//  Created by mibo02 on 17/7/25.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "musicdetailViewController.h"

@interface musicdetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation musicdetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"fengfeng";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:str];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = H15;
    cell.detailTextLabel.font = H15;
    if (indexPath.row == 0) {
        cell.detailTextLabel.text = self.model.wechat;
        cell.textLabel.text = @"微信号:";
    } else if (indexPath.row == 1){
        cell.textLabel.text = @"手机号:";
        cell.detailTextLabel.text = self.model.contact_number;
    } else {
        cell.textLabel.text = @"邮箱:";
        cell.detailTextLabel.text = self.model.contact_mailbox;
    }
    return cell;
}




@end
