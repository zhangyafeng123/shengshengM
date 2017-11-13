//
//  jiebanViewController.m
//  ShengShengManB
//
//  Created by mibo02 on 17/4/25.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "jiebanViewController.h"
#import "jiebanCell.h"
#import "jiebandetailViewController.h"
#import "jiebanlistModel.h"
#import "jiebancreateViewController.h"
@interface jiebanViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, assign)NSInteger pages;
@property (nonatomic, strong)NSMutableArray *dataArray;
@end

@implementation jiebanViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self request];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.pages = 1;
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"结伴游玩";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem initWithTitle:@"发起" titleColor:[UIColor whiteColor] target:self action:@selector(action)];
    [self.tableview registerNib:[UINib nibWithNibName:@"jiebanCell" bundle:nil] forCellReuseIdentifier:@"jieban"];
}

- (void)action
{
    jiebancreateViewController *jieban = [jiebancreateViewController new];
    [self.navigationController pushViewController:jieban animated:YES];
}

- (void)request
{
    [self showProgressHUD];
    NSString *str;
    if ([UserInfoManager isLoading]) {
        str = [NSString stringWithFormat:@"%@?token=%@&page_no=%ld",infoListURL,[UserInfoManager getUserInfo].token,self.pages];
    } else {
        str = [NSString stringWithFormat:@"%@?page_no=%ld",infoListURL,self.pages];
    }
    [NetWorkManager requestForGetWithUrl:str parameter:@{} success:^(id reponseObject) {
        
        self.dataArray = [jiebanlistModel mj_objectArrayWithKeyValuesArray:reponseObject[@"result"][@"list"]];
        [self hideProgressHUD];
        [self.tableview reloadData];
       
        [self  refrestForpages:[reponseObject[@"result"][@"totalPage"] integerValue]];
    } failure:^(NSError *error) {
        [mdfivetool checkinternationInfomation:error];
        [self hideProgressHUD];
    }];
}

- (void)refrestForpages:(NSInteger)page
{
    if (page > self.pages) {
        self.pages += 1;
        self.tableview.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
            [self.tableview.mj_footer beginRefreshing];
            [self request];
            [self.tableview.mj_footer endRefreshing];
        }];
    } else {
        self.tableview.mj_footer.state = MJRefreshStateNoMoreData;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    jiebanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jieban" forIndexPath:indexPath];
    jiebanlistModel *model  = self.dataArray[indexPath.row];
    if (model.isSignup) {
        cell.titlelab.text = [NSString stringWithFormat:@"%@(已报名)",model.activity.title];
    } else {
        cell.titlelab.text = model.activity.title;
    }
    
    cell.timelab.text = model.activity.create_time;
    cell.addresslab.text = model.activity.address;
    if ([model.activity.activity_state isEqualToString:@"0"]) {
         cell.statelab.text = @"审核中";
    } else if ([model.activity.activity_state isEqualToString:@"1"]){
        cell.statelab.text = @"进行中";
    } else if ([model.activity.activity_state isEqualToString:@"2"]){
        cell.statelab.text = @"已结束";
    } else if ([model.activity.activity_state isEqualToString:@"-1"]){
        cell.statelab.text = @"已关闭";
    }
    
    NSString *imgstr = model.activity.picture;
    if (![imgstr isEqualToString:@""]) {
        NSArray *arr = [imgstr componentsSeparatedByString:@"|"];
        if (arr.count != 0) {
            if ([arr[0] isEqualToString:@""]) {
                UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 200)];
                image.contentMode = UIViewContentModeScaleAspectFit;
                if ([arr[1] hasPrefix:@"http"]) {
                    [image sd_setImageWithURL:[NSURL URLWithString:arr[1]]];
                } else {
                    [image sd_setImageWithURL:[NSURL URLWithString:ImageViewURL(arr[1])]];
                }
                
                [cell.imgbottomview addSubview:image];
            } else {
                UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 200)];
                image.contentMode = UIViewContentModeScaleAspectFit;
                if ([arr[0] hasPrefix:@"http"]) {
                    [image sd_setImageWithURL:[NSURL URLWithString:arr[0]]];
                } else {
                    [image sd_setImageWithURL:[NSURL URLWithString:ImageViewURL(arr[0])]];
                }
                [cell.imgbottomview addSubview:image];
            }
            
        }
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    jiebanlistModel *model  = self.dataArray[indexPath.row];
    
    NSDictionary*fontDt = [NSDictionary dictionaryWithObjectsAndKeys:H14,NSFontAttributeName,nil];
    CGRect rect = [model.activity.address  boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, 0) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:fontDt context:nil];
    
    NSString *imgstr = model.activity.picture;
    if (![imgstr isEqualToString:@""]) {
        NSArray *arr = [imgstr componentsSeparatedByString:@"|"];
        if (arr.count != 0) {
            return 350 + rect.size.height;
        } else {
            return 170 + rect.size.height;
        }
    } else {
        return 170 + rect.size.height;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    jiebandetailViewController *detail = [jiebandetailViewController new];
    detail.model = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
}


- (nullable NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    UIFont *font = H15;
    UIColor *color = [UIColor blackColor];
    NSMutableDictionary *attribult = [NSMutableDictionary new];
    [attribult setObject:font forKey:NSFontAttributeName];
    [attribult setObject:color forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:@"快去发布吧" attributes:attribult];
}






@end
