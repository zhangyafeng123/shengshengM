//
//  guanzhuViewController.m
//  ShengShengManB
//
//  Created by mibo02 on 17/5/9.
//  Copyright © 2017年 mibo02. All rights reserved.
//
#import "zuopindetailViewController.h"
#import "guanzhuViewController.h"
#import "tongyongCell.h"
#import "personinfoViewController.h"
#import "LoginViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
// 弹出分享菜单需要导入的头文件
#import <ShareSDKUI/ShareSDK+SSUI.h>
// 自定义分享菜单栏需要导入的头文件
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import "zuopindetailViewController.h"
#import <ShareSDKUI/SSUIEditorViewStyle.h>
#import "guanzhuModel.h"
@interface guanzhuViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, assign)NSInteger pages;
@property (nonatomic, strong)NSMutableArray *newdataArray;
@end

@implementation guanzhuViewController
- (NSMutableArray *)newdataArray
{
    if (!_newdataArray) {
        self.newdataArray = [NSMutableArray new];
    }
    return _newdataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的关注";
    self.navigationController.navigationBar.translucent = NO;
    [self.tableview registerNib:[UINib nibWithNibName:@"tongyongCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.pages = 1;
    [self request];
}
- (void)request
{
    [self showProgressHUD];
    [NetWorkManager requestForGetWithUrl:[NSString stringWithFormat:@"%@?token=%@",myfollowURL,[UserInfoManager  getUserInfo].token] parameter:@{} success:^(id reponseObject) {
        if ([reponseObject[@"code"] integerValue] == 1) {
            self.dataArray  = [guanzhuModel mj_objectArrayWithKeyValuesArray:reponseObject[@"result"][@"list"]];
            [self.newdataArray addObjectsFromArray:self.dataArray];
        }
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.newdataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tongyongCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    guanzhuModel *model = self.newdataArray[indexPath.row];
    [cell.headimg sd_setBackgroundImageWithURL:[NSURL URLWithString:model.bbsbody.user_head] forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:@"wdl"]];
    NSString *str = [TodayDate getgradefor:model.bbsbody.grade];
    
    if (model.bbsbody.nick_name) {
        cell.nickname.attributedText = [ZLabel attributedTextArray:@[model.bbsbody.nick_name,str] textColors:@[[UIColor blueColor],[UIColor blackColor]] textfonts:@[H15,H11]];
    }
    if (model.bbsbody.poetry_notes.length != 0) {
        cell.contentlab.text = [NSString stringWithFormat:@"%@\n注释:%@",model.bbsbody.subject, model.bbsbody.poetry_notes];
    } else {
        cell.contentlab.text = model.bbsbody.subject;
    }
    
    
    NSString *timestr = [getTimes compareCurrentTime:model.bbsbody.create_time];
    
    cell.liulanlab.text = [NSString stringWithFormat:@"%@ 浏览(%ld)",timestr,model.bbsbody.browse_number];
    
    if (model.isCollect) {
        cell.shoucangbtn.selected = YES;
    } else {
        cell.shoucangbtn.selected = NO;
    }
    if (model.isRiokin) {
        cell.dianzanbtn.selected = YES;
    } else {
        cell.dianzanbtn.selected = NO;
    }
    [cell.shoucangbtn setTitle:[NSString stringWithFormat:@"%ld",model.bbsbody.collect_number] forState:(UIControlStateNormal)];
    cell.shoucangbtn.tag = 900 + indexPath.row;
    [cell.shoucangbtn addTarget:self action:@selector(shoucangbtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    cell.headimg.tag = 190 + indexPath.row;
    [cell.headimg addTarget:self action:@selector(headimgAction:) forControlEvents:(UIControlEventTouchUpInside)];
    cell.zhuanfabtn.tag = 160 + indexPath.row;
    cell.pinglunbtn.tag = 250 + indexPath.row;
    cell.dianzanbtn.tag = 500 + indexPath.row;
    //转发
    [cell.zhuanfabtn setTitle:[NSString stringWithFormat:@"%ld",model.bbsbody.relay_number] forState:(UIControlStateNormal)];
    //评论
    [cell.pinglunbtn setTitle:[NSString stringWithFormat:@"%ld",model.bbsbody.comments_number] forState:(UIControlStateNormal)];
    //点赞
    [cell.dianzanbtn setTitle:[NSString stringWithFormat:@"%ld",model.bbsbody.riokin_number] forState:(UIControlStateNormal)];
    [cell.zhuanfabtn addTarget:self action:@selector(zhuanfabtnaction:) forControlEvents:(UIControlEventTouchUpInside)];
    [cell.pinglunbtn addTarget:self action:@selector(pinglunbtnaction:) forControlEvents:(UIControlEventTouchUpInside)];
    [cell.dianzanbtn addTarget:self action:@selector(dianzanbtnaction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    NSArray *arr;
   if (model.bbsbody.images.length == 0) {
       cell.imgbackview.hidden = YES;
       cell.constraintview.constant = 5.0;
       cell.btnconstraint.constant = 5.0;
    } else {
        cell.imgbackview.hidden = NO;
        cell.constraintview.constant = 100.0;
        cell.btnconstraint.constant = 150.0;
        NSString *str = model.bbsbody.images;
        arr = [str componentsSeparatedByString:@"|"];
        if (arr.count == 1) {
            [cell.leftimglab sd_setImageWithURL:[NSURL URLWithString:str] forState:(UIControlStateNormal)];
        } else if (arr.count == 2){
            [cell.leftimglab sd_setImageWithURL:[NSURL URLWithString:arr[0]] forState:(UIControlStateNormal)];
            [cell.centerlab sd_setImageWithURL:[NSURL URLWithString:arr[1]] forState:(UIControlStateNormal)];
        } else {
            [cell.leftimglab sd_setImageWithURL:[NSURL URLWithString:arr[0]] forState:(UIControlStateNormal)];
            [cell.centerlab sd_setImageWithURL:[NSURL URLWithString:arr[1]] forState:(UIControlStateNormal)];
            [cell.rightlab sd_setImageWithURL:[NSURL URLWithString:arr[2]] forState:(UIControlStateNormal)];
        }

        
    }
    
    return cell;
}
- (void)shoucangbtnAction:(UIButton *)sender
{
    guanzhuModel *model = self.newdataArray[sender.tag - 900];
    if (model.isCollect) {
        //取消收藏
        [NetWorkManager requestForGetWithUrl:[NSString stringWithFormat:@"%@?token=%@&bbsid=%@",bbscancelCollectURL,[UserInfoManager getUserInfo].token,model.bbsbody.id] parameter:@{} success:^(id reponseObject) {
            if ([reponseObject[@"code"] integerValue] == 422) {
                LoginViewController *login = [LoginViewController new];
                [self.navigationController pushViewController:login animated:YES];
            } else {
                NSInteger i = model.bbsbody.collect_number;
                i-=1;
                model.bbsbody.collect_number = i;
                BOOL j = !model.isCollect;
                model.isCollect = j;
                [self.newdataArray replaceObjectAtIndex:sender.tag - 900 withObject:model];
                [self.tableview reloadData];
            }
            [MBProgressHUD showError:reponseObject[@"msg"]];
        } failure:^(NSError *error) {
            [mdfivetool checkinternationInfomation:error];
            [self hideProgressHUD];
        }];
        
        
    } else {
        [NetWorkManager requestForGetWithUrl:[NSString stringWithFormat:@"%@?token=%@&bbsid=%@",bbsaddCollectURL,[UserInfoManager getUserInfo].token,model.bbsbody.id] parameter:@{} success:^(id reponseObject) {
            if ([reponseObject[@"code"] integerValue] == 422) {
                LoginViewController *login = [LoginViewController new];
                [self.navigationController pushViewController:login animated:YES];
            } else {
                NSInteger i = model.bbsbody.collect_number;
                i+=1;
                model.bbsbody.collect_number = i;
                BOOL j = !model.isCollect;
                model.isCollect = j;
                [self.newdataArray replaceObjectAtIndex:sender.tag - 900 withObject:model];
                [self.tableview reloadData];
            }
            
            [MBProgressHUD showError:reponseObject[@"msg"]];
        } failure:^(NSError *error) {
            [mdfivetool checkinternationInfomation:error];
            [self hideProgressHUD];
        }];
    }

}
- (void)headimgAction:(UIButton *)sender
{
    guanzhuModel *model = self.newdataArray[sender.tag - 190];
    if ([UserInfoManager isLoading]) {
        personinfoViewController *person = [personinfoViewController new];
        person.userid = model.bbsbody.user_id;
        person.nickname = model.bbsbody.nick_name;
        [self.navigationController pushViewController:person animated:YES];
    } else {
        LoginViewController *login = [LoginViewController new];
        [self.navigationController pushViewController:login animated:YES];
    }
}
//转发
- (void)zhuanfabtnaction:(UIButton *)sender
{
    guanzhuModel *model = self.newdataArray[sender.tag - 160];
    if ([UserInfoManager isLoading]) {
       
        [self fenxiang:model index:sender.tag - 160];
    } else {
        LoginViewController *login = [LoginViewController new];
        [self.navigationController pushViewController:login animated:YES];
    }
}
- (void)fenxiang:(guanzhuModel *)model index:(NSInteger)index
{
    NSString *wechaturl = [NSString stringWithFormat:@"http://share.shengshengman.net/?id=%@",model.bbsbody.id];
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    [shareParams SSDKSetupShareParamsByText:model.bbsbody.subject
                                     images:@[@"http://app.shengshengman.net:9009/ssmcms/userfiles/20170317141631707000857331759957/images/icon/show_img.png"]
                                        url:[NSURL URLWithString:wechaturl]
                                      title:@"声声慢"
                                       type:SSDKContentTypeAuto];

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
                       {
                           NSString *typestr;
                          
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
                           
                           [NetWorkManager requestForPostWithUrl:bbsaddRelayURL parameter:@{@"token":[UserInfoManager getUserInfo].token,@"type":typestr,@"bbsid":model.bbsbody.id} success:^(id reponseObject) {
                               [MBProgressHUD showError:reponseObject[@"msg"]];
                               if ([reponseObject[@"code"] integerValue] == 1) {
                                   NSInteger num = model.bbsbody.relay_number;
                                   num+=1;
                                   model.bbsbody.relay_number = num;
                                   [self.newdataArray replaceObjectAtIndex:index withObject:model];
                                   [self.tableview reloadData];
                               }
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
                           [MBProgressHUD showError:@"已取消"];
                           break;
                       case SSDKResponseStateFail:
                           [MBProgressHUD showError:@"转发失败"];
                           break;
                       default:
                           break;
                   }
               }];
}
//评论
- (void)pinglunbtnaction:(UIButton *)sender
{
    guanzhuModel *model = self.newdataArray[sender.tag - 250];
    if ([UserInfoManager isLoading]) {
        zuopindetailViewController *detail = [zuopindetailViewController new];
        detail.newid = model.bbsbody.id;
        detail.titlestr = model.bbsbody.nick_name;
        detail.headImg = model.bbsbody.user_head;
        detail.isshoucangnum = model.isCollect;
       // detail.islike = [self.islikeArr[sender.tag - 700] integerValue];
        [self.navigationController pushViewController:detail animated:YES];
    } else {
        LoginViewController *login = [LoginViewController new];
        [self.navigationController pushViewController:login animated:YES];
    }
}
//点赞
- (void)dianzanbtnaction:(UIButton *)sender
{
    guanzhuModel *model = self.newdataArray[sender.tag - 500];
     NSString *newid = model.bbsbody.id;
    if (sender.isSelected) {
        [NetWorkManager requestForGetWithUrl:[NSString stringWithFormat:@"%@?token=%@&bbsid=%@",bbscancelRiokinURL,[UserInfoManager getUserInfo].token,newid] parameter:@{} success:^(id reponseObject) {
            if ([reponseObject[@"code"] integerValue] == 422) {
                LoginViewController *login = [LoginViewController new];
                [self.navigationController pushViewController:login animated:YES];
            } else {
                NSInteger i = model.bbsbody.riokin_number;
                i-=1;
                model.bbsbody.riokin_number = i;
                BOOL j = !model.isRiokin;
                model.isRiokin = j;
                [self.newdataArray replaceObjectAtIndex:sender.tag - 500 withObject:model];
                [self.tableview reloadData];
            }
            
            [MBProgressHUD showError:reponseObject[@"msg"]];
            
        } failure:^(NSError *error) {
            [mdfivetool checkinternationInfomation:error];
            [self hideProgressHUD];
        }];
    } else {
       
        [NetWorkManager requestForGetWithUrl:[NSString stringWithFormat:@"%@?token=%@&bbsid=%@",bbsaddRiokinURL,[UserInfoManager getUserInfo].token,newid] parameter:@{} success:^(id reponseObject) {
            if ([reponseObject[@"code"] integerValue] == 422) {
                LoginViewController *login = [LoginViewController new];
                [self.navigationController pushViewController:login animated:YES];
            } else {
                NSInteger i = model.bbsbody.riokin_number;
                i+=1;
                model.bbsbody.riokin_number = i;
                BOOL j = !model.isRiokin;
                model.isRiokin = j;
                [self.newdataArray replaceObjectAtIndex:sender.tag - 500 withObject:model];
                [self.tableview reloadData];
            }
            
            [MBProgressHUD showError:reponseObject[@"msg"]];
            
        } failure:^(NSError *error) {
            [mdfivetool checkinternationInfomation:error];
            [self hideProgressHUD];
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     guanzhuModel *model = self.newdataArray[indexPath.row];
    NSDictionary*fontDt = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName,nil];
    CGRect rect = [model.bbsbody.subject  boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, 0) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:fontDt context:nil];
    
    CGRect rect1;
    if (model.bbsbody.poetry_notes.length != 0) {
        rect1 = [model.bbsbody.poetry_notes  boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, 0) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:fontDt context:nil];
        
    } else {
        rect1 = CGRectZero;
    }
    if (model.bbsbody.images.length == 0)  {
        return rect.size.height + rect1.size.height + 130;
    } else {
        return rect.size.height + rect1.size.height + 280;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     guanzhuModel *model = self.newdataArray[indexPath.row];
    zuopindetailViewController *detail = [zuopindetailViewController new];
    detail.newid = model.bbsbody.id;
    detail.titlestr = model.bbsbody.nick_name;
    detail.headImg = model.bbsbody.user_head;
    detail.isshoucangnum =model.isCollect;
    detail.islike = model.isRiokin;
    
    [self.navigationController pushViewController:detail animated:YES];
}
- (nullable NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    UIFont *font = [UIFont systemFontOfSize:15];
    UIColor *color = [UIColor blackColor];
    NSMutableDictionary *attribult = [NSMutableDictionary new];
    [attribult setObject:font forKey:NSFontAttributeName];
    [attribult setObject:color forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:@"您还没有关注任何人哦" attributes:attribult];
}


@end
