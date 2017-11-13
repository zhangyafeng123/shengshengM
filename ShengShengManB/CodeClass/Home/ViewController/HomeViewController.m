//
//  HomeViewController.m
//  ShengShengManA
//
//  Created by mibo02 on 16/12/14.
//  Copyright © 2016年 mibo02. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeCell.h"
#import "aixinViewController.h"
#import "SDCycleScrollView.h"
#import "puquViewController.h"
#import "jiebanViewController.h"
#import "duilianViewController.h"
#import "zuopinViewController.h"
#import "LoginViewController.h"
@interface HomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)SDCycleScrollView *sdcCycleScrollView;
@property (nonatomic, strong)NSArray *ImageArr;
@property (nonatomic, strong)NSArray *titleArr;
//轮播图数组
@property (nonatomic, strong)NSMutableArray *BannerArray;
@end

@implementation HomeViewController
- (NSMutableArray *)BannerArray
{
    if (!_BannerArray) {
        self.BannerArray = [NSMutableArray new];
    }
    return _BannerArray;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        flow.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 200);
     
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:flow];
        flow.itemSize = CGSizeMake((SCREEN_WIDTH - 8) / 3, (SCREEN_WIDTH - 8) / 3);
        flow.minimumLineSpacing = 2;
        flow.minimumInteritemSpacing = 2;
        flow.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
        [_collectionView registerClass:[HomeCell class] forCellWithReuseIdentifier:@"cell"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [NetWorkManager afnreachability];
    self.titleArr = @[@"作品欣赏",@"步韵和诗",@"出联应对",@"谱曲成歌",@"结伴游玩",@"百家争鸣",@"",@"爱心驿站"];
    self.ImageArr = @[@"first",@"second",@"three",@"four",@"five",@"six",@"",@"seven"];
   
    [self.view addSubview:self.collectionView];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.BannerArray removeAllObjects];
    //轮播图请求
    [self requst];
}
- (void)requst
{
    [self showProgressHUD];
    [NetWorkManager requestForGetWithUrl:[NSString stringWithFormat:@"%@?type=%@",bannerURL,@"home"] parameter:@{} success:^(id reponseObject) {
        if ([reponseObject[@"code"] integerValue] == 1) {
            for (NSDictionary *dic in reponseObject[@"result"]) {
                NSString *imgstr = dic[@"img_url"];
                
                NSString *str = ImageViewURL(imgstr);
                
                [self.BannerArray addObject:str];
            }
        }
        [self hideProgressHUD];
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        [mdfivetool checkinternationInfomation:error];
        [self hideProgressHUD];
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _ImageArr.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    HomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell sizeToFit];
    cell.imageView.image = [UIImage imageNamed:self.ImageArr[indexPath.item]];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.titleLab.text = self.titleArr[indexPath.item];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2, 2, 2, 2);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        self.sdcCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200) imageURLStringsGroup:_BannerArray];
        self.sdcCycleScrollView.showPageControl = NO;
        
        [header addSubview:self.sdcCycleScrollView];
        return header;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        puquViewController *puqu = [puquViewController new];
        puqu.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:puqu animated:YES];
    } else if (indexPath.row == 4){
        jiebanViewController *jieban = [jiebanViewController new];
        jieban.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:jieban animated:YES];
    } else if(indexPath.row == 2){
        if ([UserInfoManager isLoading]) {
            duilianViewController *duilian = [duilianViewController new];
            duilian.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:duilian animated:YES];
        } else {
            LoginViewController *login = [LoginViewController new];
            login.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:login animated:YES];
        }
        
    } else if(indexPath.row == 7){
        aixinViewController *aixin = [aixinViewController new];
        aixin.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:aixin animated:YES];
        
    } else if (indexPath.row == 0){
        if ([UserInfoManager isLoading]) {
            zuopinViewController *first = [[zuopinViewController alloc] init];
            first.hidesBottomBarWhenPushed = YES;
            first.typestr = @"mr";
            [self.navigationController pushViewController:first animated:YES];
        } else {
            LoginViewController *login = [LoginViewController new];
            login.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:login animated:YES];
        }
       
    } else if (indexPath.row == 1){
        if ([UserInfoManager isLoading]) {
            zuopinViewController *first = [[zuopinViewController alloc] init];
            first.hidesBottomBarWhenPushed = YES;
            first.typestr = @"shi";
            [self.navigationController pushViewController:first animated:YES];
        } else {
            LoginViewController *login = [LoginViewController new];
            login.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:login animated:YES];
        }
        
    } else if (indexPath.row == 5){
        if ([UserInfoManager isLoading]) {
            zuopinViewController *first = [[zuopinViewController alloc] init];
            first.hidesBottomBarWhenPushed = YES;
            first.typestr = @"ot";
            [self.navigationController pushViewController:first animated:YES];
        } else {
            LoginViewController *login = [LoginViewController new];
            login.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:login animated:YES];
        }
        
    }
    
}

@end
