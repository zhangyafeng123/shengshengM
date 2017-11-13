//
//  ShouCangViewController.m
//  ShengShengManA
//
//  Created by mibo02 on 16/12/15.
//  Copyright © 2016年 mibo02. All rights reserved.
//
#import "zuopindetailViewController.h"
#import "tongyongCell.h"
#import "ShouCangViewController.h"
#import "personinfoViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
// 弹出分享菜单需要导入的头文件
#import <ShareSDKUI/ShareSDK+SSUI.h>
// 自定义分享菜单栏需要导入的头文件
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import "zuopindetailViewController.h"
#import <ShareSDKUI/SSUIEditorViewStyle.h>
#import "shiModel.h"
@interface ShouCangViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, assign)NSInteger pages;
@end

@implementation ShouCangViewController
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    self.navigationController.navigationBar.translucent  = NO;
    [self.tableview registerNib:[UINib nibWithNibName:@"tongyongCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.pages = 1;
    [self request];
}
- (void)request
{
    [self showProgressHUD];
    [NetWorkManager requestForGetWithUrl:[NSString stringWithFormat:@"%@?token=%@",collectURL,[UserInfoManager getUserInfo].token] parameter:@{} success:^(id reponseObject) {
        if ([reponseObject[@"code"] integerValue] == 1) {
            for (NSDictionary *dic in reponseObject[@"result"][@"list"]) {
                shiModel *model = [shiModel new];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
            }
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
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tongyongCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    shiModel *model = self.dataArray[indexPath.row];
    [cell.headimg sd_setBackgroundImageWithURL:[NSURL URLWithString:model.user_head] forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:@"wdl"]];
    
    cell.headimg.tag = indexPath.row + 300;
    [cell.headimg addTarget:self action:@selector(headimgAction:) forControlEvents:(UIControlEventTouchUpInside)];
    NSString *str = [TodayDate getgradefor:model.grade];
    
    if (model.nick_name) {
        cell.nickname.attributedText = [ZLabel attributedTextArray:@[model.nick_name,str] textColors:@[[UIColor blueColor],[UIColor blackColor]] textfonts:@[H15,H11]];
    }
    
    if (model.poetry_notes.length == 0)
    {
        cell.contentlab.text = model.subject;
    } else
    {
        cell.contentlab.text = [NSString stringWithFormat:@"%@\n注释:%@",model.subject, model.poetry_notes];
    }
    
    
    NSString *timestr = [getTimes compareCurrentTime:model.create_time];
    cell.liulanlab.text = [NSString stringWithFormat:@"%@ 浏览(%ld)",timestr,model.browse_number];
    cell.shoucangbtn.selected = YES;
    //收藏
    cell.shoucangbtn.tag = 100 + indexPath.row;
    [cell.shoucangbtn setTitle:[NSString stringWithFormat:@"%ld",model.collect_number] forState:(UIControlStateNormal)];
    [cell.shoucangbtn addTarget:self action:@selector(shoucangbtnaction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    cell.zhuanfabtn.tag = 900 + indexPath.row;
    cell.pinglunbtn.tag = 700 + indexPath.row;
    //转发
    [cell.zhuanfabtn setTitle:[NSString stringWithFormat:@"%ld",model.relay_number] forState:(UIControlStateNormal)];
    //评论
    [cell.pinglunbtn setTitle:[NSString stringWithFormat:@"%ld",model.comments_number] forState:(UIControlStateNormal)];
    cell.dianzanbtn.tag =  500 + indexPath.row;
    //点赞
    [cell.dianzanbtn setTitle:[NSString stringWithFormat:@"%ld",model.riokin_number] forState:(UIControlStateNormal)];
    [cell.zhuanfabtn addTarget:self action:@selector(zhuanfabtnaction:) forControlEvents:(UIControlEventTouchUpInside)];
    [cell.pinglunbtn addTarget:self action:@selector(pinglunbtnaction:) forControlEvents:(UIControlEventTouchUpInside)];
    [cell.dianzanbtn addTarget:self action:@selector(dianzanbtnaction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    NSArray *arr;
     if (model.images.length == 0)  {
        
         cell.imgbackview.hidden = YES;
         cell.constraintview.constant = 5.0;
         cell.btnconstraint.constant = 5.0;
    } else {
       
        cell.imgbackview.hidden = NO;
        cell.constraintview.constant = 100.0;
        cell.btnconstraint.constant = 150.0;
        NSString *str = model.images;
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
        cell.leftimglab.tag = 160 + indexPath.row;
        cell.centerlab.tag = 160 + indexPath.row;
        cell.rightlab.tag = 160 + indexPath.row;
    }
    cell.leftimglab.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.centerlab.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.rightlab.imageView.contentMode = UIViewContentModeScaleAspectFit;
    return cell;
}

- (void)shoucangbtnaction:(UIButton *)sender
{
    shiModel *model = self.dataArray[sender.tag - 100];
    
        //取消收藏
        [NetWorkManager requestForGetWithUrl:[NSString stringWithFormat:@"%@?token=%@&bbsid=%@",bbscancelCollectURL,[UserInfoManager getUserInfo].token,model.id] parameter:@{} success:^(id reponseObject) {
            [self.dataArray removeAllObjects];
            self.pages = 1;
            [self request];
            [MBProgressHUD showError:reponseObject[@"msg"]];
        } failure:^(NSError *error) {
            [mdfivetool checkinternationInfomation:error];
            [self hideProgressHUD];
        }];
    
}
//头像点击事件
- (void)headimgAction:(UIButton *)sender
{
    personinfoViewController *person = [personinfoViewController new];
    person.userid = [self.dataArray[sender.tag - 300] user_id];
    if ([[self.dataArray[sender.tag - 300] nick_name] length] == 0) {
       person.nickname = @"未设置";
    } else {
       person.nickname = [self.dataArray[sender.tag - 300] nick_name];
    }
    
    [self.navigationController pushViewController:person animated:YES];
}
//转发
- (void)zhuanfabtnaction:(UIButton *)sender
{
    shiModel *model = self.dataArray[sender.tag - 900];
   
    [self fenxiang:model index:sender.tag-900];
}
- (void)fenxiang:(shiModel *)model index:(NSInteger)index
{
    NSString *wechaturl = [NSString stringWithFormat:@"http://share.shengshengman.net/?id=%@",model.id];
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    [shareParams SSDKSetupShareParamsByText:model.subject
                                     images:@[@"http://app.shengshengman.net:9009/ssmcms/userfiles/20170317141631707000857331759957/images/icon/show_img.png"]
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
                             items:@[@(SSDKPlatformTypeWechat)]
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
                           }
                           
                           [NetWorkManager requestForPostWithUrl:bbsaddRelayURL parameter:@{@"token":[UserInfoManager getUserInfo].token,@"type":typestr,@"bbsid":model.id} success:^(id reponseObject) {
                               [MBProgressHUD showError:reponseObject[@"msg"]];
                               NSInteger num = model.relay_number;
                               num+=1;
                               model.relay_number = num;
                               [self.dataArray replaceObjectAtIndex:index withObject:model];
                               [self.tableview reloadData];
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
    shiModel *model = self.dataArray[sender.tag - 7000];
    zuopindetailViewController *detail = [zuopindetailViewController new];
    detail.newid = model.id;
    if (model.nick_name.length == 0) {
       detail.titlestr = @"未设置";
    } else {
        detail.titlestr = model.nick_name;
    }
    if (model.user_head.length == 0) {
     detail.headImg = @"wdl";
    } else {
        detail.headImg = model.user_head;
    }
    
    [self.navigationController pushViewController:detail animated:YES];
}
//点赞
- (void)dianzanbtnaction:(UIButton *)sender
{
    shiModel *model = self.dataArray[sender.tag - 500];
    
    [NetWorkManager requestForGetWithUrl:[NSString stringWithFormat:@"%@?token=%@&bbsid=%@",bbsaddRiokinURL,[UserInfoManager getUserInfo].token,model.id] parameter:@{} success:^(id reponseObject) {
        if ([reponseObject[@"code"] integerValue] == 1) {
            NSInteger i = model.riokin_number;
            i+=1;
            model.riokin_number = i;
            [self.dataArray replaceObjectAtIndex:sender.tag - 500 withObject:model];
            [self.tableview reloadData];
        }
        
        [MBProgressHUD showError:reponseObject[@"msg"]];
        
    } failure:^(NSError *error) {
        [mdfivetool checkinternationInfomation:error];
        [self hideProgressHUD];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    shiModel *model = self.dataArray[indexPath.row];
    
    NSDictionary*fontDt = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName,nil];
    CGRect rect = [model.subject  boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, 0) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:fontDt context:nil];
    
    CGRect rect1;
    if (model.poetry_notes.length != 0) {
        rect1 = [model.poetry_notes  boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, 0) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:fontDt context:nil];
    } else {
        rect1 = CGRectZero;
    }
    
    if (model.images.length == 0)   {
        return rect.size.height + rect1.size.height + 130;
    } else {
        return rect.size.height + rect1.size.height + 250;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    shiModel *model = self.dataArray[indexPath.row];
    zuopindetailViewController *detail = [zuopindetailViewController new];
    detail.newid = model.id;
    if (model.nick_name.length == 0) {
        detail.titlestr = @"未设置";
    } else {
        detail.titlestr = model.nick_name;
    }
    if (model.user_head.length == 0) {
        detail.headImg = @"wdl";
    } else {
        detail.headImg = model.user_head;
    }
    
    [self.navigationController pushViewController:detail animated:YES];
}
- (nullable NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    UIFont *font = [UIFont systemFontOfSize:15];
    UIColor *color = [UIColor blackColor];
    NSMutableDictionary *attribult = [NSMutableDictionary new];
    [attribult setObject:font forKey:NSFontAttributeName];
    [attribult setObject:color forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:@"快去发布作品吧!" attributes:attribult];
}

@end
