//
//  puquViewController.m
//  ShengShengManB
//
//  Created by mibo02 on 17/4/25.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "puquViewController.h"
#import "puquCell.h"
#import <AVFoundation/AVFoundation.h>
#import "puquleftmodel.h"
#import "puqumusicModel.h"
#import "puquxuqiuViewController.h"
#import "musicdetailViewController.h"
#import "LoginViewController.h"
@interface puquViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UIButton *leftbtn;
@property (weak, nonatomic) IBOutlet UIButton *rigbtn;

@property (weak, nonatomic) IBOutlet UITableView *leftTableview;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;
@property (nonatomic, strong)NSMutableArray *leftArr;
@property (nonatomic, strong)NSMutableArray *rightArr;
@end

@implementation puquViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"谱曲成歌";
     self.navigationItem.rightBarButtonItem = [UIBarButtonItem initWithTitle:@"发需求" titleColor:[UIColor whiteColor] target:self action:@selector(action)];
    [self.leftTableview registerNib:[UINib nibWithNibName:@"puquCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.leftbtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.leftbtn.backgroundColor = [UIColor lightGrayColor];
    [self.rigbtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    self.rigbtn.backgroundColor = [UIColor whiteColor];
    [self.leftbtn addTarget:self action:@selector(leftbtnaction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.rigbtn addTarget:self action:@selector(rightbtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self request];
}
- (void)leftbtnaction:(UIButton *)sender
{
    [self.leftbtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.leftbtn.backgroundColor = [UIColor lightGrayColor];
    [self.rigbtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    self.rigbtn.backgroundColor = [UIColor whiteColor];
    self.scroll.contentOffset = CGPointMake(0, 0);
}
- (void)rightbtnAction:(UIButton *)sender
{
    [self.rigbtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.rigbtn.backgroundColor = [UIColor lightGrayColor];
    [self.leftbtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    self.leftbtn.backgroundColor = [UIColor whiteColor];
    self.scroll.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
}
- (void)action
{
    puquxuqiuViewController *puqu = [puquxuqiuViewController new];
    
    [self.navigationController pushViewController:puqu animated:YES];
}
- (void)request
{
    [NetWorkManager requestForGetWithUrl:cianInfoURL parameter:@{} success:^(id reponseObject) {
        if ([reponseObject[@"code"] integerValue] == 1) {
            self.leftArr = [puquleftmodel mj_objectArrayWithKeyValuesArray:reponseObject[@"result"]];
        }
        [self.leftTableview reloadData];
    } failure:^(NSError *error) {
        [mdfivetool checkinternationInfomation:error];
       
    }];
    [NetWorkManager requestForGetWithUrl:appreciateURL parameter:@{} success:^(id reponseObject) {
        if ([reponseObject[@"code"] integerValue] == 1) {
            self.rightArr = [puqumusicModel mj_objectArrayWithKeyValuesArray:reponseObject[@"result"]];
        }
        [self.rightTableView reloadData];
    } failure:^(NSError *error) {
        [mdfivetool checkinternationInfomation:error];
       
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.leftTableview) {
        return self.leftArr.count;
    } else {
        return self.rightArr.count;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTableview) {
       puquCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        puquleftmodel *model = self.leftArr[indexPath.row];
        cell.titlelab.text = model.title;
        cell.contentlab.text = model.outline;
        cell.lianxibtn.tag = 150 + indexPath.row;
        [cell.lianxibtn addTarget:self action:@selector(lianxibtnaction:) forControlEvents:(UIControlEventTouchUpInside)];
         return cell;
    } else {
        static NSString *str = @"str";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:str];
        }
        puqumusicModel *model = self.rightArr[indexPath.row];
        cell.textLabel.text = model.song_name;
        cell.detailTextLabel.text = model.singer_name;
        
         return cell;
    }
}
- (void)lianxibtnaction:(UIButton *)sender
{
    puquleftmodel *model = self.leftArr[sender.tag - 150];
    musicdetailViewController *music = [musicdetailViewController new];
    music.model  = model;
    [self.navigationController pushViewController:music animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTableview) {
        puquleftmodel *model = self.leftArr[indexPath.row];
        CGRect rect = [TodayDate getstringheightfor:model.outline];
        return rect.size.height + 100;
    } else {
        return 45;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.rightTableView) {
        if ([UserInfoManager isLoading]) {
            puqumusicModel *model = self.rightArr[indexPath.row];
            NSString *url1  = [NSString stringWithFormat:@"https://m.y.qq.com/#search/%@",model.song_name];
            NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)url1, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:encodedString]];
        } else {
            LoginViewController *login = [LoginViewController new];
            [self.navigationController pushViewController:login animated:YES];
        }
    } else {
        musicdetailViewController *music = [musicdetailViewController new];
        music.model  = self.leftArr[indexPath.row];
        [self.navigationController pushViewController:music animated:YES];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x > 0) {
        [self.rigbtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        self.rigbtn.backgroundColor = [UIColor lightGrayColor];
        [self.leftbtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        self.leftbtn.backgroundColor = [UIColor whiteColor];
    } else {
        [self.leftbtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        self.leftbtn.backgroundColor = [UIColor lightGrayColor];
        [self.rigbtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        self.rigbtn.backgroundColor = [UIColor whiteColor];
    }
}

@end
