//
//  PersonnewViewController.m
//  ShengShengManB
//
//  Created by mibo02 on 17/5/11.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "PersonnewViewController.h"
#import "firstcollectionCell.h"
#import "itemCell.h"
#import "PersonModel.h"
#import "qiandaoViewController.h"
#import "LoginViewController.h"
#import "settingViewController.h"
#import "secondCollectionViewCell.h"
#import "LastsettingViewController.h"
#import "ouxiangViewController.h"
#import "shijiViewController.h"
#import "fensiViewController.h"
#import "xitongViewController.h"
#import "ShouCangViewController.h"
#import "guanzhuViewController.h"
#import "pinglunViewController.h"
#import "huifuViewController.h"
#import "chatlistViewController.h"
#import "newhuodongViewController.h"
#import "musicxuqiuViewController.h"
#import "caogaoViewController.h"
@interface PersonnewViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong)PersonModel *model;
@property (nonatomic, strong)NSArray *titleArr;
@property (nonatomic, strong)NSDictionary *persondic;

@end

@implementation PersonnewViewController
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //获取个人信息接口
    [self request];
}
- (void)request
{
    [NetWorkManager requestForGetWithUrl:[NSString stringWithFormat:@"%@?token=%@",accountinfoURL,[UserInfoManager getUserInfo].token] parameter:@{} success:^(id reponseObject) {
        if ([reponseObject[@"code"] integerValue] == 1) {
            self.persondic = reponseObject[@"result"];
            _model = [PersonModel mj_objectWithKeyValues:reponseObject[@"result"][@"user"]];
          
        }
        
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        [mdfivetool checkinternationInfomation:error];
        [self hideProgressHUD];
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _titleArr = @[@"关注",@"评论",@"回复",@"聊天",@"收藏",@"活动",@"设置",@"系统消息",@"签到",@"需求",@"草稿"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"secondCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"second"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"firstcollectionCell" bundle:nil] forCellWithReuseIdentifier:@"first"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"itemCell" bundle:nil] forCellWithReuseIdentifier:@"newcell"];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        return 1;
    } else {
        return _titleArr.count;
    }
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        firstcollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"first" forIndexPath:indexPath];
        if ([UserInfoManager isLoading]) {
            [cell.leftImg sd_setImageWithURL:[NSURL URLWithString:_model.user_head] placeholderImage:[UIImage imageNamed:@"wdl"]];
            NSString *str = [TodayDate getgradefor:_model.grade];
            
            if (_model.nick_name) {
               cell.titleLab.attributedText = [ZLabel attributedTextArray:@[_model.nick_name,str] textColors:@[[UIColor blueColor],[UIColor blackColor]] textfonts:@[H17,H11]];
            }
        
            cell.scoreLab.text = [NSString stringWithFormat:@"积分:%ld",_model.integral];
           
        } else {
            cell.leftImg.image = [UIImage imageNamed:@"wdl"];
            cell.titleLab.text = @"未登录";
            cell.scoreLab.text = @"积分:0";
        }
        return cell;
    } else if (indexPath.section == 1){
        secondCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"second" forIndexPath:indexPath];
        
        NSInteger i;
        NSInteger j;
        NSInteger k;
        if ([UserInfoManager isLoading]) {
            i = [self.persondic[@"idol"] integerValue];
            j = [self.persondic[@"user"][@"fans"] integerValue];
            k = [self.persondic[@"user"][@"works"] integerValue];
        } else {
            i = 0;
            j = 0;
            k = 0;
        }
        
        [cell.leftbtn setTitle:[NSString stringWithFormat:@"偶像\n%ld",i] forState:(UIControlStateNormal)];
        
        cell.leftbtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.leftbtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        cell.leftbtn.titleLabel.numberOfLines = 2;
        [cell.centerbtn setTitle:[NSString stringWithFormat:@"粉丝\n%ld",j] forState:(UIControlStateNormal)];
        cell.centerbtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.centerbtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        cell.centerbtn.titleLabel.numberOfLines = 2;
        [cell.rightbtn setTitle:[NSString stringWithFormat:@"诗集\n%ld",k] forState:(UIControlStateNormal)];
        cell.rightbtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.rightbtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        cell.rightbtn.titleLabel.numberOfLines = 2;
        [cell.leftbtn addTarget:self action:@selector(btnaction:) forControlEvents:(UIControlEventTouchUpInside)];
        [cell.centerbtn addTarget:self action:@selector(btnaction:) forControlEvents:(UIControlEventTouchUpInside)];
        [cell.rightbtn addTarget:self action:@selector(btnaction:) forControlEvents:(UIControlEventTouchUpInside)];
        return cell;
    }else {
        itemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"newcell" forIndexPath:indexPath];
        cell.itemlab.text = self.titleArr[indexPath.item];
        cell.itemimg.image = [UIImage imageNamed:self.titleArr[indexPath.item]];
        return cell;
    }
}
- (void)btnaction:(UIButton *)sender
{
    if ([UserInfoManager isLoading]) {
        if (sender.tag == 120) {
            ouxiangViewController *ouxiang = [ouxiangViewController new];
            ouxiang.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ouxiang animated:YES];
        } else if (sender.tag == 121){
            fensiViewController *fensi = [fensiViewController new];
            fensi.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:fensi animated:YES];
        } else {
            shijiViewController *shiji = [shijiViewController new];
            shiji.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:shiji animated:YES];
        }
    }else {
        LoginViewController *login = [LoginViewController new];
        login.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:login animated:YES];
    }
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake(SCREEN_WIDTH, 80);
    } else if (indexPath.section == 1){
        return CGSizeMake(SCREEN_WIDTH, 60);
    } else {
        return CGSizeMake((SCREEN_WIDTH - 8) / 3, (SCREEN_WIDTH - 8) / 3);
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2, 2, 2, 2);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if ([UserInfoManager isLoading]) {
            settingViewController *set1 = [settingViewController new];
            set1.hidesBottomBarWhenPushed = YES;
            set1.setmodel = self.model;
            [self.navigationController pushViewController:set1 animated:YES];
        } else {
            LoginViewController *login = [[LoginViewController alloc] init];
            login.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:login animated:YES];
        }
    } else if(indexPath.section == 1){
        
    } else {
        if ([UserInfoManager isLoading]) {
            if (indexPath.row == 7) {
                //系统消息
                xitongViewController *xitong = [xitongViewController new];
                xitong.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:xitong animated:YES];
                
            } else if (indexPath.row == 5){
                //签到
                if ([UserInfoManager isLoading]) {
                    newhuodongViewController *new = [newhuodongViewController new];
                    new.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:new animated:YES];
                } else {
                    LoginViewController *login = [LoginViewController new];
                    login.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:login animated:YES];
                }
              
            } else if (indexPath.row == 6){
                //退出登录
                LastsettingViewController *set = [LastsettingViewController new];
                set.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:set animated:YES];
                
            } else if (indexPath.row == 4){
                ShouCangViewController *shoucang = [ShouCangViewController new];
                shoucang.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:shoucang animated:YES];
            }else if (indexPath.row == 0){
                //关注
                guanzhuViewController *guanzhu = [guanzhuViewController new];
                guanzhu.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:guanzhu animated:YES];
            } else if (indexPath.row == 1){
                //评论
                pinglunViewController *pinglun = [pinglunViewController new];
                pinglun.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:pinglun animated:YES];
            } else if (indexPath.row == 2){
                huifuViewController *huifu = [huifuViewController new];
                huifu.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:huifu animated:YES];
            } else if (indexPath.row == 3){
                chatlistViewController *chat = [chatlistViewController new];
                chat.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:chat animated:YES];
            } else if (indexPath.row == 8){
                //签到
                if ([UserInfoManager isLoading]) {
                    qiandaoViewController *qiandao = [qiandaoViewController new];
                    qiandao.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:qiandao animated:YES];
                } else {
                    LoginViewController *login = [LoginViewController new];
                    login.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:login animated:YES];
                }
            } else if (indexPath.row == 9){
                   if ([UserInfoManager isLoading]) {
                       musicxuqiuViewController *music = [musicxuqiuViewController new];
                       music.hidesBottomBarWhenPushed = YES;
                       [self.navigationController pushViewController:music animated:YES];
                   }else {
                    LoginViewController *login = [LoginViewController new];
                    login.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:login animated:YES];
                }
            }  else {
                caogaoViewController *caogao = [caogaoViewController new];
                caogao.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:caogao animated:YES];
            }

        } else {
            LoginViewController *login = [LoginViewController new];
            login.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:login animated:YES];
        }
        
    }
}
@end
