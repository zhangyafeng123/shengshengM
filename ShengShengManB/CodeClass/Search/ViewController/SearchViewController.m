//
//  SearchViewController.m
//  ShengShengManA
//
//  Created by mibo02 on 16/12/14.
//  Copyright © 2016年 mibo02. All rights reserved.
//

#import "SearchViewController.h"
#import "HomeCell.h"
#import "shiViewController.h"
#import "ciViewController.h"
#import "quViewController.h"
#import "cilinViewController.h"
#import "zhonghuaViewController.h"
#import "pingshuiViewController.h"
#import "webViewController.h"
@interface SearchViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    NSArray *firstArr, *secondArr, *threeArr, *AimageArr, *BimageArr, *CimageArr;
    
}
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@end

@implementation SearchViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        flow.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 50);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49) collectionViewLayout:flow];
        flow.itemSize = CGSizeMake((SCREEN_WIDTH - 8) / 3, (SCREEN_WIDTH - 8)/3);
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
    self.navigationController.navigationBar.translucent = NO;
    firstArr = @[@"诗",@"词",@"曲"];
    secondArr = @[@"平水韵",@"词林正韵",@"中华新韵"];
    threeArr = @[@"唐诗三百首",@"宋词三百首",@"元曲三百首"];
    AimageArr = @[[UIImage imageNamed:@"1"],[UIImage imageNamed:@"2"],[UIImage imageNamed:@"3"]];
    BimageArr = @[[UIImage imageNamed:@"4"],[UIImage imageNamed:@"5"],[UIImage imageNamed:@"6"]];
    CimageArr = @[[UIImage imageNamed:@"7"],[UIImage imageNamed:@"8"],[UIImage imageNamed:@"9"]];
    
    [self.view addSubview:self.collectionView];
    
    [self request];
    
    
}
- (void)request
{
    [NetWorkManager requestForGetWithUrl:yunyininfoURL parameter:@{} success:^(id reponseObject) {
        if ([reponseObject[@"code"] integerValue] == 1) {
            for (NSDictionary *newdic in reponseObject[@"result"]) {
                [self.dataArray addObject:newdic];
            }
            
            [[NSUserDefaults standardUserDefaults] setValue:reponseObject[@"result"] forKey:@"search"];
        }
    } failure:^(NSError *error) {
        [mdfivetool checkinternationInfomation:error];
        [self hideProgressHUD];
    }];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   
    return 3;
   
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    HomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    [cell sizeToFit];
    if (indexPath.section == 0) {
        cell.imageView.image = AimageArr[indexPath.item];
        cell.titleLab.text = firstArr[indexPath.item];
    } else if (indexPath.section == 1){
        cell.imageView.image = BimageArr[indexPath.item];
        cell.titleLab.text = secondArr[indexPath.item];
    } else {
        cell.imageView.image = CimageArr[indexPath.item];
        cell.titleLab.text = threeArr[indexPath.item];
    }

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH - 20, 50)];
    lab.textAlignment = NSTextAlignmentLeft;
    lab.textColor = [UIColor blackColor];
    header.backgroundColor = [UIColor whiteColor];
    if (indexPath.section == 0) {
        lab.text = @"格律";
    } else if (indexPath.section == 1){
        lab.text = @"韵书";
    } else {
        lab.text = @"经典";
    }
   
    [header addSubview:lab];
    
    return header;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            shiViewController *shi = [shiViewController new];
            shi.hidesBottomBarWhenPushed  = YES;
            [self.navigationController pushViewController:shi animated:YES];
        } else if (indexPath.row == 1){
            ciViewController *ci = [ciViewController new];
            ci.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ci animated:YES];
        } else {
            quViewController *qu = [quViewController new];
            qu.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:qu animated:YES];
        }
    } else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            pingshuiViewController *pingshui = [pingshuiViewController new];
            if (self.dataArray.count != 0) {
               pingshui.newdic = self.dataArray[indexPath.row]; 
            }
            
            pingshui.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:pingshui animated:YES];
        } else if (indexPath.row == 1){
            cilinViewController *cilin = [cilinViewController new];
            cilin.hidesBottomBarWhenPushed = YES;
            if (self.dataArray.count != 0) {
               cilin.newdic = self.dataArray[indexPath.row];
            }
            
            [self.navigationController pushViewController:cilin animated:YES];
        } else {
            zhonghuaViewController *zhonghua = [zhonghuaViewController new];
            zhonghua.hidesBottomBarWhenPushed = YES;
            if (self.dataArray.count != 0) {
              zhonghua.newdic = self.dataArray[indexPath.row];
            }
            
            [self.navigationController pushViewController:zhonghua animated:YES];
        }
        
    } else {
        
        if (indexPath.item == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://m.diyifanwen.com/sicijianshang/tangshisanbaishou"]];
        } else if (indexPath.item == 1){
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://m.diyifanwen.com/sicijianshang/songcisanbaishou"]];
            
        } else {
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://wap.exam58.com/yqsbsr/list_40_3.html"]];
            
        }
        
    }
   
}




@end
