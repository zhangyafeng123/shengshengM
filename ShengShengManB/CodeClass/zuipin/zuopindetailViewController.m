//
//  zuopindetailViewController.m
//  ShengShengManB
//
//  Created by mibo02 on 17/5/22.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "zuopindetailViewController.h"
#import "zuopindetailCell.h"
#import "menubtnView.h"
#import "tongyongCell.h"
#import "menuneirongCell.h"
#import "BtnTitleView.h"
#import "pinglunselectViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
// 弹出分享菜单需要导入的头文件
#import <ShareSDKUI/ShareSDK+SSUI.h>
// 自定义分享菜单栏需要导入的头文件
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import "zuopindetailViewController.h"
#import <ShareSDKUI/SSUIEditorViewStyle.h>
#import "LoginViewController.h"
#import "shidetailViewController.h"
#import "zuopindetailModel.h"
@interface zuopindetailViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UIButton *zhuanfabtn;
@property (weak, nonatomic) IBOutlet UIButton *pinglunbtn;
@property (weak, nonatomic) IBOutlet UIButton *zanbtn;


@property (nonatomic, strong)BtnTitleView *titleView;
@property (nonatomic, strong)menubtnView *menubtnV;
@property (nonatomic, strong)NSDictionary *newdic;

@property (nonatomic, strong)NSMutableArray *btnArray;
@property (nonatomic, strong)NSMutableArray *firstArray;
@property (nonatomic, strong)NSMutableArray *secondArray;
@property (nonatomic, strong)NSMutableArray *threeArray;
@property (nonatomic, strong)NSMutableArray *fourArray;

@property (nonatomic, assign)NSInteger num;


@end

@implementation zuopindetailViewController
- (NSMutableArray *)btnArray
{
    if (!_btnArray) {
        self.btnArray = [NSMutableArray new];
    }
    return _btnArray;
}

- (NSMutableArray *)firstArray
{
    if (!_firstArray) {
        self.firstArray = [NSMutableArray new];
    }
    return _firstArray;
}
- (NSMutableArray *)secondArray
{
    if (!_secondArray) {
        self.secondArray = [NSMutableArray new];
    }
    return _secondArray;
}
- (NSMutableArray *)threeArray
{
    if (!_threeArray) {
        self.threeArray = [NSMutableArray new];
    }
    return _threeArray;
}
- (NSMutableArray *)fourArray
{
    if (!_fourArray) {
        self.fourArray = [NSMutableArray new];
    }
    return _fourArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.num = 0;
    self.title = self.titlestr;
    self.navigationController.navigationBar.translucent = NO;
    [self.tableview registerNib:[UINib nibWithNibName:@"zuopindetailCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"menuneirongCell" bundle:nil] forCellReuseIdentifier:@"newcell"];
    [self request];
    if (self.islike == 1) {
        self.zanbtn.selected = YES;
    } else {
        self.zanbtn.selected = NO;
    }
    [self.zhuanfabtn addTarget:self action:@selector(zhuanfabtnaction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.pinglunbtn addTarget:self action:@selector(pinglunbtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.zanbtn addTarget:self action:@selector(zanbtnaction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    if (self.iscenter == 1) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem initWithTitle:@"和诗" titleColor:[UIColor whiteColor] target:self action:@selector(shiaction)];
    }
    
}


- (void)shidic:(NSDictionary *)editdic
{
    
    NSMutableArray *shiarr = [NSMutableArray new];
    [NetWorkManager requestForGetWithUrl:poetryinfoURL parameter:@{} success:^(id reponseObject) {
        
        if ([reponseObject[@"code"] integerValue] == 1) {
            
            for (NSDictionary *dic in reponseObject[@"result"]) {
                if ([dic[@"id"] isEqualToString:editdic[@"poetry_id"]]) {
                    
                    for (NSDictionary *newdic in dic[@"rhythmList"]) {
                        
                        if ([newdic[@"id"] isEqualToString:editdic[@"rhythm_id"]]) {
                            
                            [shiarr addObject:newdic[@"subjectList"]];
                            
                        }
                    }
                }
            }
        }
        if (shiarr.count != 0) {
            NSArray *subjectarr = [editdic[@"subject"] componentsSeparatedByString:@"\n"];
            shidetailViewController *three =[shidetailViewController new];
            three.newarr = shiarr[0];
            three.headid = editdic[@"poetry_id"];
            three.rhythmid = editdic[@"rhythm_id"];
            three.namestr = subjectarr[0];
            three.subjectstr = editdic[@"subject"];
            three.yunid = editdic[@"yunyun_id"];
            three.yunshustr = @"平水韵";
            [self.navigationController pushViewController:three animated:YES];
        }
        
    } failure:^(NSError *error) {
        [mdfivetool checkinternationInfomation:error];
        [self hideProgressHUD];
    }];
    
}


- (void)shiaction
{
    [self shidic:self.newdic];
    
}
//转发
- (void)zhuanfabtnaction:(UIButton *)sender
{
    if ([UserInfoManager isLoading]) {
        [self zhuanfa];
    } else {
        LoginViewController *login = [LoginViewController new];
        [self.navigationController pushViewController:login animated:YES];
    }
}
- (void)zhuanfa
{
    NSString *wechaturl = [NSString stringWithFormat:@"http://share.shengshengman.net/?id=%@",self.newid];
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    [shareParams SSDKSetupShareParamsByText:@"声声慢"
                                     images:@[@"http://app.shengshengman.net/ssmcms/userfiles/20170317141631707000857331759957/images/icon/show_img.png"]
                                        url:[NSURL URLWithString:wechaturl]
                                      title:@"声声慢"
                                       type:SSDKContentTypeAuto];
    
    // 设置分享菜单栏样式（非必要）
    
    //设置分享编辑界面状态栏风格
    [SSUIEditorViewStyle setStatusBarStyle:UIStatusBarStyleLightContent];
    //设置简单分享菜单样式
    [SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSimple];
    
    //分享
    [ShareSDK showShareActionSheet:self.view
     //将要自定义顺序的平台传入items参数中
                             items:@[@(SSDKPlatformTypeWechat),@(SSDKPlatformTypeQQ)]
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                       case SSDKResponseStateSuccess:
                           NSLog(@"成功");
                       {
                           
                           NSString *typestr;
                           
                           
                           /**
                            *  微信朋友圈
                            */
                           
                           if (platformType == SSDKPlatformSubTypeWechatTimeline) {
                               
                               typestr = @"wcc";
                           } else if (platformType == SSDKPlatformSubTypeWechatSession){
                               /**
                                *  微信好友
                                */
                               typestr = @"wcg";
                           } else if (platformType == SSDKPlatformSubTypeQZone){
                               //QQ空间
                               typestr = @"qqz";
                           } else if (platformType == SSDKPlatformSubTypeQQFriend){
                               //QQ好友
                               typestr = @"qq";
                           }
                           
                           
                           
                           [NetWorkManager requestForPostWithUrl:bbsaddRelayURL parameter:@{@"token":[UserInfoManager getUserInfo].token,@"type":typestr,@"bbsid":self.newid} success:^(id reponseObject) {
                               [MBProgressHUD showError:reponseObject[@"msg"]];
                               
                              
                               [self.firstArray removeAllObjects];
                               [self.secondArray removeAllObjects];
                               [self.threeArray removeAllObjects];
                               [self.fourArray removeAllObjects];
                               
                               [self request];
                           } failure:^(NSError *error) {
                               [mdfivetool checkinternationInfomation:error];
                               [self hideProgressHUD];
                           }];
                       }
                           break;
                       case SSDKResponseStateBegin:
                           
                           break;
                       case SSDKResponseStateCancel:
                           //取消
                           [MBProgressHUD showError:@"已取消！"];
                           break;
                       case SSDKResponseStateFail:
                           [MBProgressHUD showError:@"转发失败！"];
                           break;
                       default:
                           break;
                   }
               }];

}
//评论btn
- (void)pinglunbtnAction:(UIButton *)sender
{
    if ([UserInfoManager isLoading]) {
        pinglunselectViewController *pinglun = [pinglunselectViewController new];
        pinglun.str = self.newdic[@"id"];
        [self.navigationController pushViewController:pinglun animated:YES];
    } else {
        LoginViewController *login = [LoginViewController new];
        [self.navigationController pushViewController:login animated:YES];
    }
    
}
//赞
- (void)zanbtnaction:(UIButton *)sender
{
    
    [NetWorkManager requestForGetWithUrl:[NSString stringWithFormat:@"%@?token=%@&bbsid=%@",bbsaddRiokinURL,[UserInfoManager getUserInfo].token,self.newid] parameter:@{} success:^(id reponseObject) {
        if ([reponseObject[@"code"] integerValue] == 422) {
            LoginViewController *login = [LoginViewController new];
            [self.navigationController pushViewController:login animated:YES];
        } else {
           
            [self.firstArray removeAllObjects];
            [self.secondArray removeAllObjects];
            [self.threeArray removeAllObjects];
            [self.fourArray removeAllObjects];
            [self request];
        }
        
        [MBProgressHUD showError:reponseObject[@"msg"]];
        
    } failure:^(NSError *error) {
        [mdfivetool checkinternationInfomation:error];
        [self hideProgressHUD];
    }];
}

- (void)request
{
    __weak typeof(self) WeakSelf = self;
    [self.btnArray removeAllObjects];
    [NetWorkManager requestForGetWithUrl:[NSString stringWithFormat:@"%@?token=%@&bbsid=%@",bbsinfoURL,[UserInfoManager getUserInfo].token,self.newid] parameter:@{} success:^(id reponseObject) {
        if ([reponseObject[@"code"] integerValue] == 1) {
            
            self.newdic = reponseObject[@"result"][@"body"];
            
            //
            for (NSDictionary *firstdic in reponseObject[@"result"][@"collect"]) {
                zuopindetailModel *model = [zuopindetailModel new];
                [model setValuesForKeysWithDictionary:firstdic];
                [self.firstArray addObject:model];
            }
            for (NSDictionary *secdic in reponseObject[@"result"][@"relay"]) {
                zuopindetailModel *model = [zuopindetailModel new];
                [model setValuesForKeysWithDictionary:secdic];
                [self.secondArray addObject:model];
            }
            for (NSDictionary *threedic in reponseObject[@"result"][@"comments"]) {
                zuopindetailModel *model = [zuopindetailModel new];
                [model setValuesForKeysWithDictionary:threedic];
                [self.threeArray addObject:model];
            }
            for (NSDictionary *fourdic in reponseObject[@"result"][@"riokin"]) {
                zuopindetailModel *model = [zuopindetailModel new];
                [model setValuesForKeysWithDictionary:fourdic];
                [self.fourArray addObject:model];
            }
            
        }
        //createBtnView
        [self.btnArray addObject:[NSString stringWithFormat:@"收藏%ld",[self.newdic[@"collect_number"] integerValue]]];
        [self.btnArray addObject:[NSString stringWithFormat:@"转发%ld",[self.newdic[@"relay_number"] integerValue]]];
        [self.btnArray addObject:[NSString stringWithFormat:@"评论%ld",[self.newdic[@"comments_number"] integerValue]]];
        [self.btnArray addObject:[NSString stringWithFormat:@"赞%ld",[self.newdic[@"riokin_number"] integerValue]]];
        
        self.titleView = [[BtnTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) andTitleArray:self.btnArray];
        
        self.titleView.BtnClickedBlock =^(NSInteger  index){
            [WeakSelf clickAction:index];
        };
        [self hideProgressHUD];
        [self.tableview reloadData];
        
    } failure:^(NSError *error) {
        [mdfivetool checkinternationInfomation:error];
        [self hideProgressHUD];
    }];
}

- (void)clickAction:(NSInteger)index
{
    self.num = index;
    
    [self.tableview reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:(UITableViewRowAnimationNone)];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else if(section == 1){
        return 0;
    } else {
        if (self.num == 0) {
            return  self.firstArray.count;
        } else if (self.num == 1){
            return  self.secondArray.count;
        } else if (self.num == 2){
            return  self.threeArray.count;
        } else {
            return  self.fourArray.count;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        zuopindetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        
        [cell.headimg sd_setBackgroundImageWithURL:[NSURL URLWithString:self.headImg] forState:(UIControlStateNormal)];
        cell.nickname.text = self.titlestr;
        if (self.iscenter == 1) {
            cell.contentlab.textAlignment = NSTextAlignmentCenter;
        } else {
            cell.contentlab.textAlignment = NSTextAlignmentLeft;
        }
        if (self.newdic[@"poetry_notes"] == [NSNull null])
        {
            cell.contentlab.text = self.newdic[@"subject"];
        } else
        {
            cell.contentlab.text = [NSString stringWithFormat:@"%@\n注释:%@",self.newdic[@"subject"], self.newdic[@"poetry_notes"]];
        }
        if (self.isshoucangnum == 1) {
            cell.shoucangbtn.selected = YES;
        } else {
            cell.shoucangbtn.selected = NO;
        }
           NSString *timestr = [getTimes compareCurrentTime:self.newdic[@"create_time"]];
        
         [cell.shoucangbtn setTitle:[NSString stringWithFormat:@"%ld",[self.newdic[@"collect_number"] integerValue]] forState:(UIControlStateNormal)];
        cell.liulanlab.text = [NSString stringWithFormat:@"%@ 浏览(%ld)",timestr,[self.newdic[@"browse_number"] integerValue]];
        NSArray *arr;
        if (self.newdic[@"images"] == [NSNull null] || [self.newdic[@"images"] isEqualToString:@""]){
            
            cell.imgbackV.hidden = YES;
            cell.constraintNew.constant = 5;
            
        } else {
            
            cell.imgbackV.hidden = NO;
            cell.constraintNew.constant = 150;
            NSString *str = self.newdic[@"images"];
            arr = [str componentsSeparatedByString:@"|"];
            if (arr.count == 1) {
                [cell.leftbtn sd_setImageWithURL:[NSURL URLWithString:str] forState:(UIControlStateNormal)];
            } else if (arr.count == 2){
                [cell.leftbtn sd_setImageWithURL:[NSURL URLWithString:arr[0]] forState:(UIControlStateNormal)];
                [cell.centerbtn sd_setImageWithURL:[NSURL URLWithString:arr[1]] forState:(UIControlStateNormal)];
            } else {
                [cell.leftbtn sd_setImageWithURL:[NSURL URLWithString:arr[0]] forState:(UIControlStateNormal)];
                [cell.centerbtn sd_setImageWithURL:[NSURL URLWithString:arr[1]] forState:(UIControlStateNormal)];
                [cell.rightbtn sd_setImageWithURL:[NSURL URLWithString:arr[2]] forState:(UIControlStateNormal)];
            }
        }
        cell.leftbtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.centerbtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.rightbtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        return cell;
    } else if (indexPath.section == 2){
       
        menuneirongCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newcell" forIndexPath:indexPath];
        
        if (self.num == 0) {
            zuopindetailModel *model = self.firstArray[indexPath.row];
            NSString *str = [TodayDate getgradefor:model.grade];
            if (model.nick_name) {
                cell.nickname.attributedText = [ZLabel attributedTextArray:@[model.nick_name,str] textColors:@[[UIColor blueColor],[UIColor blackColor]] textfonts:@[H15,H11]];
            }
            [cell.headimg sd_setImageWithURL:[NSURL URLWithString:model.user_head]];
            cell.content.text = @"已收藏";
           
        } else if (self.num == 1){
            zuopindetailModel *model = self.secondArray[indexPath.row];
            [cell.headimg sd_setImageWithURL:[NSURL URLWithString:model.user_head]];
            NSString *str = [TodayDate getgradefor:model.grade];
            if (model.nick_name) {
                cell.nickname.attributedText = [ZLabel attributedTextArray:@[model.nick_name,str] textColors:@[[UIColor blueColor],[UIColor blackColor]] textfonts:@[H15,H11]];
            }
            cell.content.text = @"已转发";
        } else if (self.num == 2){
           cell.detailModel = self.threeArray[indexPath.row];
           
        } else {
            zuopindetailModel *model = self.fourArray[indexPath.row];
            [cell.headimg sd_setImageWithURL:[NSURL URLWithString:model.user_head]];
            NSString *str = [TodayDate getgradefor:model.grade];
            if (model.nick_name) {
                cell.nickname.attributedText = [ZLabel attributedTextArray:@[model.nick_name,str] textColors:@[[UIColor blueColor],[UIColor blackColor]] textfonts:@[H15,H11]];
            }
            cell.content.text = @"已赞";
        
        }
       
        return cell;
        
    } else {
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return self.titleView;
    } else {
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 40;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
       
        CGRect rect = [TodayDate getstringheightfor:self.newdic[@"subject"]];
        CGRect rect1;
        if (self.newdic[@"poetry_notes"] != [NSNull null]) {
            rect1 = [TodayDate getstringheightfor:self.newdic[@"poetry_notes"]];
        } else {
            rect1 = CGRectZero;
        }
        
        if (self.newdic[@"images"] == [NSNull null] || [self.newdic[@"images"] isEqualToString:@""]) {
            return rect.size.height + rect1.size.height + 80;
        } else {
            return rect.size.height + rect1.size.height + 200;
        }
    } else if(indexPath.section == 1){
        return 0;
    } else {
        CGRect rect;
        if (self.num == 0) {
            zuopindetailModel *model = self.firstArray[indexPath.row];
            rect =  [TodayDate getstringheightfor:model.content];
             return 70 + rect.size.height;
        } else if (self.num == 1){
            zuopindetailModel *model = self.secondArray[indexPath.row];
            rect =  [TodayDate getstringheightfor:model.content] ;
            
             return 70 + rect.size.height;
        } else if (self.num == 2){
            zuopindetailModel *model = self.threeArray[indexPath.row];
            rect =  [TodayDate getstringheightfor:model.content];
            CGRect rectsub;
            if (model.submodelarr.count != 0) {
               rectsub = [TodayDate getstrheightfornew:[model.submodelarr[0] content]];
                return 70 + rect.size.height + model.submodelarr.count * (rectsub.size.height + 100);
            } else {
                return 70 + rect.size.height;
            }
            
            
        } else {
            zuopindetailModel *model = self.fourArray[indexPath.row];
            rect =  [TodayDate getstringheightfor:model.content];
             return 70 + rect.size.height;
        }
       

    }
}

- (nullable NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    UIFont *font = H15;
    UIColor *color = [UIColor blackColor];
    NSMutableDictionary *attribult = [NSMutableDictionary new];
    [attribult setObject:font forKey:NSFontAttributeName];
    [attribult setObject:color forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:@"没有更多了" attributes:attribult];
}

@end
