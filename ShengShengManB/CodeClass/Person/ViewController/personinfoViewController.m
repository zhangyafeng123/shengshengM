//
//  personinfoViewController.m
//  ShengShengManB
//
//  Created by mibo02 on 17/5/22.
//  Copyright © 2017年 mibo02. All rights reserved.
//
#import "zuopindetailViewController.h"
#import "personinfoViewController.h"
#import "tongyongCell.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
// 弹出分享菜单需要导入的头文件
#import <ShareSDKUI/ShareSDK+SSUI.h>
// 自定义分享菜单栏需要导入的头文件
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import "personHeadV.h"
#import <ShareSDKUI/SSUIEditorViewStyle.h>
#import "chatdetailViewController.h"
#import "LoginViewController.h"
#import "zuopinModel.h"
#import "HJPhotoBrowserController.h"
@interface personinfoViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UIButton *liaotianbtn;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)personHeadV *headV;
@property (nonatomic, strong)NSDictionary *newdic;
@property (nonatomic, assign)NSInteger pages;
@property (nonatomic, strong)NSMutableArray *listArray;
@property (weak, nonatomic) IBOutlet UIButton *guanzhubtn;



@end

@implementation personinfoViewController
- (NSMutableArray *)listArray
{
    if (!_listArray) {
        self.listArray = [NSMutableArray new];
    }
    return _listArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.nickname;
    self.navigationController.navigationBar.translucent = NO;
    [self.tableview registerNib:[UINib nibWithNibName:@"tongyongCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.pages = 1;
    [self request];
    [self.liaotianbtn addTarget:self action:@selector(liaotianbtnaction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.guanzhubtn addTarget:self action:@selector(guanzhubtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
   
}
//关注
- (void)guanzhubtnAction:(UIButton *)sender
{
     if ([self.userid isEqualToString:[UserInfoManager getUserInfo].id]) {
         [MBProgressHUD showError:@"无法关注自己"];
     } else {
         [NetWorkManager requestForPostWithUrl:accountaddfollowURL parameter:@{@"token":[UserInfoManager getUserInfo].token,@"user_id":self.userid} success:^(id reponseObject) {
             [MBProgressHUD showError:reponseObject[@"msg"]];
         } failure:^(NSError *error) {
             [mdfivetool checkinternationInfomation:error];
             [self hideProgressHUD];
         }];
     }
    
}
- (void)liaotianbtnaction:(UIButton *)sender
{
    if ([self.userid isEqualToString:[UserInfoManager getUserInfo].id]) {
        [MBProgressHUD showError:@"不能和自己聊天哦"];
    } else {
        chatdetailViewController *rcConversationVC = [[chatdetailViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:self.userid];
        rcConversationVC.title = self.newdic[@"nick_name"];
        [self.navigationController pushViewController:rcConversationVC animated:YES];
    }

}
- (void)request
{
    if ([UserInfoManager isLoading]) {
        [self showProgressHUD];
        [NetWorkManager requestForPostWithUrl:accountuserinfoUTL parameter:@{@"token":[UserInfoManager getUserInfo].token,@"user_id":self.userid,@"page_no":@(self.pages)} success:^(id reponseObject) {
            if ([reponseObject[@"code"] integerValue] == 1) {
                self.newdic = reponseObject[@"result"];
               
                self.dataArray = [zuopinModel mj_objectArrayWithKeyValuesArray:reponseObject[@"result"][@"list"][@"list"]];
                [self.listArray addObjectsFromArray:self.self.dataArray];
            
            }
            
            [self createhead];
            [self hideProgressHUD];
            [self.tableview reloadData];
            [self refreshfooternew:[reponseObject[@"result"][@"list"][@"totalPage"] integerValue]];
        } failure:^(NSError *error) {
            [mdfivetool checkinternationInfomation:error];
            [self hideProgressHUD];
        }];
    } else {
        LoginViewController *login = [LoginViewController new];
        [self.navigationController pushViewController:login animated:YES];
    }
   
}
//上拉刷新
- (void)refreshfooternew:(NSInteger)totalpages
{
    if (totalpages > self.pages) {
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
- (void)createhead
{
    self.headV = [[[NSBundle mainBundle] loadNibNamed:@"personHeadV" owner:nil options:nil] firstObject];
    self.headV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
    if (self.newdic[@"user_head"] == [NSNull null]) {
        self.headV.headimg.image = [UIImage imageNamed:@"wdl"];
    } else {
       [self.headV.headimg sd_setImageWithURL:[NSURL URLWithString:self.newdic[@"user_head"]] placeholderImage:nil];
    }
    self.headV.addbtn.layer.cornerRadius = 4;
    self.headV.addbtn.layer.masksToBounds = YES;
    self.headV.addbtn.layer.borderColor = [UIColor blackColor].CGColor;
    self.headV.addbtn.layer.borderWidth = 0.5;
    NSString *str = [TodayDate getgradefor:[self.newdic[@"grade"] integerValue]];
    if (self.nickname) {
        self.headV.nicklab.attributedText = [ZLabel attributedTextArray:@[self.nickname,str] textColors:@[[UIColor blueColor],[UIColor blackColor]] textfonts:@[H15,H11]];
    }
    
    self.headV.guanzhulab.text = [NSString stringWithFormat:@"%ld\n关注",[self.newdic[@"follow"] integerValue]];
    self.headV.fensilab.text = [NSString stringWithFormat:@"%ld\n粉丝",[self.newdic[@"fans"] integerValue]];
    self.headV.shijilab.text = [NSString stringWithFormat:@"%ld\n诗集",[self.newdic[@"works"] integerValue]];
    [self.headV.addbtn addTarget:self action:@selector(action) forControlEvents:(UIControlEventTouchUpInside)];
    self.tableview.tableHeaderView = self.headV;
}
- (void)action
{
    
    //添加好友
    [NetWorkManager requestForPostWithUrl:friendaddURL parameter:@{@"token":[UserInfoManager getUserInfo].token,@"friendId":self.userid} success:^(id reponseObject) {
        
        [MBProgressHUD showError:reponseObject[@"msg"]];
    } failure:^(NSError *error) {
        [mdfivetool checkinternationInfomation:error];
        [self hideProgressHUD];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tongyongCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    zuopinModel *model = self.listArray[indexPath.row];
    [cell.headimg sd_setBackgroundImageWithURL:[NSURL URLWithString:model.body.user_head] forState:(UIControlStateNormal)];
   
    NSString *str = [TodayDate getgradefor:model.body.grade];
    if (model.body.nick_name) {
        cell.nickname.attributedText = [ZLabel attributedTextArray:@[model.body.nick_name,str] textColors:@[[UIColor blueColor],[UIColor blackColor]] textfonts:@[H15,H11]];
    }
    
    if (self.iscenter == 1) {
        cell.contentlab.textAlignment = NSTextAlignmentCenter;
    } else {
        cell.contentlab.textAlignment = NSTextAlignmentLeft;
    }
    
    if (model.body.poetry_notes.length == 0)
    {
        cell.contentlab.text = model.body.subject;
    } else
    {
        cell.contentlab.text = [NSString stringWithFormat:@"%@\n注释:%@",model.body.subject, model.body.poetry_notes];
    }
  
    
    if (model.isCollect) {
        cell.shoucangbtn.selected = YES;
    } else {
        cell.shoucangbtn.selected = NO;
    }
    if (model.isPraise) {
        cell.dianzanbtn.selected = YES;
    } else {
        cell.dianzanbtn.selected = NO;
    }
    //收藏
    cell.shoucangbtn.tag = 100 + indexPath.row;
    [cell.shoucangbtn setTitle:[NSString stringWithFormat:@"%ld",model.body.collect_number] forState:(UIControlStateNormal)];
    [cell.shoucangbtn addTarget:self action:@selector(shoucangbtnaction:) forControlEvents:(UIControlEventTouchUpInside)];
    NSString *timestr = [getTimes compareCurrentTime:model.body.create_time];
    cell.liulanlab.text = [NSString stringWithFormat:@"%@ 浏览(%ld)",timestr,model.body.browse_number];
    cell.zhuanfabtn.tag = 900 + indexPath.row;
    //转发
    [cell.zhuanfabtn setTitle:[NSString stringWithFormat:@"%ld",model.body.relay_number] forState:(UIControlStateNormal)];
    //评论
    [cell.pinglunbtn setTitle:[NSString stringWithFormat:@"%ld",model.body.comments_number] forState:(UIControlStateNormal)];
    cell.dianzanbtn.tag =  500 + indexPath.row;
    //点赞
    [cell.dianzanbtn setTitle:[NSString stringWithFormat:@"%ld",model.body.riokin_number] forState:(UIControlStateNormal)];
    cell.pinglunbtn.tag = indexPath.row + 700;
    [cell.zhuanfabtn addTarget:self action:@selector(zhuanfabtnaction:) forControlEvents:(UIControlEventTouchUpInside)];
    [cell.pinglunbtn addTarget:self action:@selector(pinglunbtnaction:) forControlEvents:(UIControlEventTouchUpInside)];
    [cell.dianzanbtn addTarget:self action:@selector(dianzanbtnaction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    NSArray *arr;
     if (model.body.images.length == 0)  {
        
         cell.imgbackview.hidden = YES;
         cell.constraintview.constant = 5.0;
         cell.btnconstraint.constant = 5.0;
        
    } else {
       
        cell.imgbackview.hidden = NO;
        cell.constraintview.constant = 100.0;
        cell.btnconstraint.constant = 150.0;
        NSString *str = model.body.images;
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
    cell.leftimglab.tag = 160 + indexPath.row;
    cell.centerlab.tag = 160 + indexPath.row;
    cell.rightlab.tag = 160 + indexPath.row;
    cell.leftimglab.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.centerlab.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.rightlab.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [cell.leftimglab addTarget:self action:@selector(imagebtnnewaction:) forControlEvents:(UIControlEventTouchUpInside)];
    [cell.centerlab addTarget:self action:@selector(imagebtnnewaction:) forControlEvents:(UIControlEventTouchUpInside)];
    [cell.rightlab addTarget:self action:@selector(imagebtnnewaction:) forControlEvents:(UIControlEventTouchUpInside)];
    return cell;
}
//图片放大
- (void)imagebtnnewaction:(UIButton *)sender
{
    zuopinModel *model = self.listArray[sender.tag - 160];
    if (model.body.images.length != 0) {
        NSString *str = model.body.images;
        NSArray *arr = [str componentsSeparatedByString:@"|"];
        NSMutableArray *arrnew = [NSMutableArray new];
        for (int i = 0; i < arr.count; i++) {
            if ([arr[i] length] != 0) {
                [arrnew addObject:arr[i]];
            }
        }
        HJPhotoBrowserController *photoVC = [[HJPhotoBrowserController alloc] initWithPhotos:arrnew];
        [self.navigationController pushViewController:photoVC animated:YES];
    }
}

- (void)shoucangbtnaction:(UIButton *)sender
{
    zuopinModel *model = self.listArray[sender.tag - 100];
    if (model.isCollect) {
        //取消收藏
        [NetWorkManager requestForGetWithUrl:[NSString stringWithFormat:@"%@?token=%@&bbsid=%@",bbscancelCollectURL,[UserInfoManager getUserInfo].token,model.body.id] parameter:@{} success:^(id reponseObject) {
            [MBProgressHUD showError:reponseObject[@"msg"]];
            NSInteger i = model.body.collect_number;
            i-=1;
            model.body.collect_number = i;
            BOOL j = !model.isCollect;
            model.isCollect = j;
            [self.listArray replaceObjectAtIndex:sender.tag-100 withObject:model];
            [self.tableview reloadData];
            
        } failure:^(NSError *error) {
            [mdfivetool checkinternationInfomation:error];
            [self hideProgressHUD];
        }];
        
        
    } else {
        [NetWorkManager requestForGetWithUrl:[NSString stringWithFormat:@"%@?token=%@&bbsid=%@",bbsaddCollectURL,[UserInfoManager getUserInfo].token,model.body.id] parameter:@{} success:^(id reponseObject) {
            NSInteger i = model.body.collect_number;
            i+=1;
            model.body.collect_number = i;
            BOOL j = !model.isCollect;
            model.isCollect = j;
            [self.listArray replaceObjectAtIndex:sender.tag-100 withObject:model];
            [self.tableview reloadData];
            [MBProgressHUD showError:reponseObject[@"msg"]];
        } failure:^(NSError *error) {
            [mdfivetool checkinternationInfomation:error];
            [self hideProgressHUD];
        }];
    }
}
//转发
- (void)zhuanfabtnaction:(UIButton *)sender
{
     zuopinModel *model = self.listArray[sender.tag - 900];
    NSString *subjectstr;
    if (model.body.poetry_notes.length != 0) {
        subjectstr =  [NSString stringWithFormat:@"%@\n%@",model.body.subject,model.body.poetry_notes];
    } else {
        subjectstr = model.body.subject;
    }
    
    [self fenxiang:model.body.id subjectstr:subjectstr model:model index:sender.tag - 900];
}
- (void)fenxiang:(NSString *)newid subjectstr:(NSString *)subjectstr model:(zuopinModel *)model index:(NSInteger)index
{
    NSString *wechaturl = [NSString stringWithFormat:@"http://share.shengshengman.net/?id=%@",newid];
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    [shareParams SSDKSetupShareParamsByText:subjectstr
                                     images:@[@"http://app.shengshengman.net/ssmcms/userfiles/20170317141631707000857331759957/images/icon/show_img.png"]
                                        url:[NSURL URLWithString:wechaturl]
                                      title:@"享受慢生活"
                                       type:SSDKContentTypeAuto];
  
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
                           
                           
                           
                           [NetWorkManager requestForPostWithUrl:bbsaddRelayURL parameter:@{@"token":[UserInfoManager getUserInfo].token,@"type":typestr,@"bbsid":newid} success:^(id reponseObject) {
                               [MBProgressHUD showError:reponseObject[@"msg"]];
                               NSInteger num = model.body.relay_number;
                               num+=1;
                               model.body.relay_number = num;
                               [self.listArray replaceObjectAtIndex:index withObject:model];
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
//评论
- (void)pinglunbtnaction:(UIButton *)sender
{
    zuopinModel *model = self.listArray[sender.tag - 700];
    zuopindetailViewController *detail = [zuopindetailViewController new];
    detail.newid = model.body.id;
    detail.titlestr = model.body.nick_name;
    detail.headImg = model.body.user_head;
    [self.navigationController pushViewController:detail animated:YES];
}
//点赞
- (void)dianzanbtnaction:(UIButton *)sender
{
    zuopinModel *model = self.listArray[sender.tag - 500];
    if (sender.isSelected) {
        
        [NetWorkManager requestForGetWithUrl:[NSString stringWithFormat:@"%@?token=%@&bbsid=%@",bbscancelRiokinURL,[UserInfoManager getUserInfo].token,model.body.id] parameter:@{} success:^(id reponseObject) {
           
            NSInteger i = model.body.riokin_number;
            i-=1;
            model.body.riokin_number = i;
            BOOL j = !model.isPraise;
            model.isPraise = j;
            [self.listArray replaceObjectAtIndex:sender.tag - 500 withObject:model];
            [self.tableview reloadData];
            
            [MBProgressHUD showError:reponseObject[@"msg"]];
            
        } failure:^(NSError *error) {
            [mdfivetool checkinternationInfomation:error];
            [self hideProgressHUD];
        }];
    } else {
    
        [NetWorkManager requestForGetWithUrl:[NSString stringWithFormat:@"%@?token=%@&bbsid=%@",bbsaddRiokinURL,[UserInfoManager getUserInfo].token,model.body.id] parameter:@{} success:^(id reponseObject) {
           
            [MBProgressHUD showError:reponseObject[@"msg"]];
            NSInteger i = model.body.riokin_number;
            i+=1;
            model.body.riokin_number = i;
            BOOL j = !model.isPraise;
            model.isPraise = j;
            [self.listArray replaceObjectAtIndex:sender.tag - 500 withObject:model];
            [self.tableview reloadData];
            
        } failure:^(NSError *error) {
            [mdfivetool checkinternationInfomation:error];
            [self hideProgressHUD];
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    zuopinModel *model = self.listArray[indexPath.row];
   
    CGRect rect = [TodayDate getstringheightfor:model.body.subject];
    
    CGRect rect1;
    if (model.body.poetry_notes.length != 0) {
        rect1 = [TodayDate getstringheightfor:model.body.poetry_notes];
    } else {
        rect1 = CGRectZero;
    }
     if (model.body.images.length == 0)  {
        return rect.size.height + rect1.size.height + 130;
    } else {
        return rect.size.height + rect1.size.height + 280;
    }
    
}

- (nullable NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    UIFont *font = [UIFont systemFontOfSize:15];
    UIColor *color = [UIColor blackColor];
    NSMutableDictionary *attribult = [NSMutableDictionary new];
    [attribult setObject:font forKey:NSFontAttributeName];
    [attribult setObject:color forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:@"暂无个人信息" attributes:attribult];
}

@end
