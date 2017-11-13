//
//  shijiViewController.m
//  ShengShengManB
//
//  Created by mibo02 on 17/5/16.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "shijiViewController.h"
#import "tongyongCell.h"
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
#import "shidetailViewController.h"
#import "cidetailViewController.h"
#import "qudetailViewController.h"
#import "fatieViewController.h"
@interface shijiViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, assign)NSInteger pages;
@end

@implementation shijiViewController


- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"我的诗集";
    [self.tableview registerNib:[UINib nibWithNibName:@"tongyongCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.pages = 1;
    [self request];
}
- (void)request
{
    [self showProgressHUD];
    [NetWorkManager requestForPostWithUrl:accountshisURL parameter:@{@"token":[UserInfoManager getUserInfo].token,@"page_no":@(self.pages)} success:^(id reponseObject) {
        if ([reponseObject[@"code"] integerValue] == 1) {
            for (NSDictionary *dic in reponseObject[@"result"][@"list"]) {
                shiModel *model = [shiModel new];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
            }
        }
        [self.tableview reloadData];
        [self hideProgressHUD];
        [self refrestForpages:[reponseObject[@"result"][@"totalPage"] integerValue]];
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
    cell.headimg.tag = indexPath.row + 300;
    
    [cell.headimg sd_setBackgroundImageWithURL:[NSURL URLWithString:model.user_head] forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:@"wdl"]];
    
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
    
    [cell.editbutton setTitle:@"编辑" forState:(UIControlStateNormal)];
    [cell.editbutton setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
    cell.editbutton.layer.borderColor = [UIColor blueColor].CGColor;
    cell.editbutton.layer.borderWidth = 0.5;
    cell.editbutton.titleLabel.font = H14;
    cell.editbutton.tag = 660 + indexPath.row;
    [cell.editbutton addTarget:self action:@selector(editbuttonaction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    cell.shoucangbtn.layer.borderWidth =  0.5;
    cell.shoucangbtn.layer.borderColor = [UIColor blueColor].CGColor;
    cell.shoucangbtn.titleLabel.font = H14;
    [cell.shoucangbtn setTitle:@"删除" forState:(UIControlStateNormal)];
    [cell.shoucangbtn setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
    [cell.shoucangbtn setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
    //收藏
    cell.shoucangbtn.tag = 100 + indexPath.row;

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
    if (model.images.length != 0) {
        
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
        } else if (arr.count == 3){
            [cell.leftimglab sd_setImageWithURL:[NSURL URLWithString:arr[0]] forState:(UIControlStateNormal)];
            [cell.centerlab sd_setImageWithURL:[NSURL URLWithString:arr[1]] forState:(UIControlStateNormal)];
            [cell.rightlab sd_setImageWithURL:[NSURL URLWithString:arr[2]] forState:(UIControlStateNormal)];
        }
        cell.leftimglab.tag = 160 + indexPath.row;
        cell.centerlab.tag = 160 + indexPath.row;
        cell.rightlab.tag = 160 + indexPath.row;
    } else {
        cell.imgbackview.hidden = YES;
        cell.constraintview.constant = 5.0;
        cell.btnconstraint.constant = 5.0;
    }
    cell.leftimglab.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.centerlab.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.rightlab.imageView.contentMode = UIViewContentModeScaleAspectFit;
    return cell;
}
- (void)editbuttonaction:(UIButton *)sender
{
    
    shiModel *model = self.dataArray[sender.tag - 660];
    
    if ([model.type isEqualToString:@"shi"]) {
       [self shidic:model];
    } else if ([model.type isEqualToString:@"ci"]){
        [self cidic:model];
    } else if ([model.type isEqualToString:@"ot"]){
        [self otherdic:model];
    } else {
        [self qudic:model];
    }
    
}
//
- (void)otherdic:(shiModel *)model
{
    fatieViewController *fatie = [fatieViewController new];
    
    fatie.imagesnewstr = model.images;
    fatie.contentstr = model.subject;
    [self.navigationController pushViewController:fatie animated:YES];
}

- (void)shidic:(shiModel *)editdic
{
    
    NSMutableArray *shiarr = [NSMutableArray new];
    [NetWorkManager requestForGetWithUrl:poetryinfoURL parameter:@{} success:^(id reponseObject) {
        NSString *titlestr;
        if ([reponseObject[@"code"] integerValue] == 1) {
            
            for (NSDictionary *dic in reponseObject[@"result"]) {
                if ([dic[@"id"] isEqualToString:editdic.poetry_id]) {
                    
                    titlestr = dic[@"name"];
                    
                    for (NSDictionary *newdic in dic[@"rhythmList"]) {
                        
                        if ([newdic[@"id"] isEqualToString:editdic.rhythm_id]) {
                            
                            [shiarr addObject:newdic[@"subjectList"]];
                            
                        }
                    }
                }
            }
        }
        if (shiarr.count != 0) {
            
            shidetailViewController *three =[shidetailViewController new];
            three.newarr = shiarr[0];
            three.headid = editdic.poetry_id;
            three.rhythmid = editdic.rhythm_id;
            three.edittitle = titlestr;
            three.body = editdic.subject;
            three.yunid = editdic.yunyun_id;
            three.yunshustr = @"平水韵";
            [self.navigationController pushViewController:three animated:YES];
        }
        
    } failure:^(NSError *error) {
        [mdfivetool checkinternationInfomation:error];
        [self hideProgressHUD];
    }];
    
}

- (void)cidic:(shiModel *)editdic
{
    NSMutableArray *shiarr = [NSMutableArray new];
    [NetWorkManager requestForGetWithUrl:wordinfoURL parameter:@{} success:^(id reponseObject) {
        NSString *str;
        if ([reponseObject[@"code"] integerValue] == 1) {
            
            for (NSDictionary *dic in reponseObject[@"result"]) {
                if ([dic[@"id"] isEqualToString:editdic.poetry_id]) {
                    str = dic[@"name"];
                    for (NSDictionary *newdic in dic[@"tuneRhymes"]) {
                        
                        if ([newdic[@"id"] isEqualToString:editdic.rhythm_id]) {
                            
                            [shiarr addObject:newdic[@"subjects"]];
                            
                        }
                    }
                }
            }
        }
        if (shiarr.count != 0) {
            cidetailViewController *three =[cidetailViewController new];
            three.newarr = shiarr[0];
            three.headid = editdic.poetry_id;
            three.rhythmid = editdic.rhythm_id;
            three.edittitle = str;
            three.body = editdic.subject;
            three.yunid = editdic.yunyun_id;
            three.yunshustr = @"词林正韵";
            [self.navigationController pushViewController:three animated:YES];
        }
        
    } failure:^(NSError *error) {
        [mdfivetool checkinternationInfomation:error];
        [self hideProgressHUD];
    }];
}

- (void)qudic:(shiModel *)editdic {
    NSMutableArray *shiarr = [NSMutableArray new];
    [NetWorkManager requestForGetWithUrl:songinfoURL parameter:@{} success:^(id reponseObject) {
        NSString *str;
        if ([reponseObject[@"code"] integerValue] == 1) {
            
            for (NSDictionary *dic in reponseObject[@"result"]) {
                if ([dic[@"id"] isEqualToString:editdic.poetry_id]) {
                    str = dic[@"name"];
                    for (NSDictionary *newdic in dic[@"qupais"]) {
                        
                        if ([newdic[@"id"] isEqualToString:editdic.rhythm_id]) {
                            
                            [shiarr addObject:newdic[@"subjects"]];
                            
                        }
                    }
                }
            }
        }
        if (shiarr.count != 0) {
            qudetailViewController *three =[qudetailViewController new];
            three.newarr = shiarr[0];
            three.headid = editdic.poetry_id;
            three.rhythmid = editdic.rhythm_id;
            three.edittitle = str;
            three.body = editdic.subject;
            three.yunid = editdic.yunyun_id;
            three.yunshustr = @"中华新韵";
            [self.navigationController pushViewController:three animated:YES];
        }
    } failure:^(NSError *error) {
        [mdfivetool checkinternationInfomation:error];
        [self hideProgressHUD];
    }];
}


- (void)shoucangbtnaction:(UIButton *)sender
{
    [NetWorkManager requestForGetWithUrl:[NSString stringWithFormat:@"%@?token=%@&bbsid=%@",deletepersonURL,[UserInfoManager getUserInfo].token,[self.dataArray[sender.tag - 100] id]] parameter:@{} success:^(id reponseObject) {
        if ([reponseObject[@"code"] integerValue] == 1) {
            [self.dataArray removeAllObjects];
            [self request];
        }
        [MBProgressHUD showError:reponseObject[@"msg"]];
    } failure:^(NSError *error) {
        [mdfivetool checkinternationInfomation:error];
        [self hideProgressHUD];
    }];
}
//头像点击事件
- (void)headimgAction:(UIButton *)sender
{
    shiModel *model = self.dataArray[sender.tag - 300];
    personinfoViewController *person = [personinfoViewController new];
    person.userid = model.user_id;
    if (model.nick_name.length == 0) {
        person.nickname = @"未设置";
    } else {
      person.nickname = model.nick_name;
    }
    [self.navigationController pushViewController:person animated:YES];
}
//转发
- (void)zhuanfabtnaction:(UIButton *)sender
{
    
    NSString *newid = [self.dataArray[sender.tag - 900] id];
    
    [self fenxiang:newid];
}
- (void)fenxiang:(NSString *)newid
{
    NSString *wechaturl = @"https://www.baidu.com";
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    [shareParams SSDKSetupShareParamsByText:@"声声慢"
                                     images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]
                                        url:[NSURL URLWithString:wechaturl]
                                      title:@"享受慢生活"
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
                           
                           [NetWorkManager requestForPostWithUrl:bbsaddRelayURL parameter:@{@"token":[UserInfoManager getUserInfo].token,@"type":typestr,@"bbsid":newid} success:^(id reponseObject) {
                               [MBProgressHUD showError:reponseObject[@"msg"]];
                               [self.dataArray removeAllObjects];
                          
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
//评论
- (void)pinglunbtnaction:(UIButton *)sender
{
    shiModel *model = self.dataArray[sender.tag - 700];
    zuopindetailViewController *detail = [zuopindetailViewController new];
    detail.newid = model.id;
    detail.titlestr = model.nick_name;
    detail.headImg = model.user_head;
    [self.navigationController pushViewController:detail animated:YES];
}
//删除
- (void)dianzanbtnaction:(UIButton *)sender
{
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary*fontDt = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName,nil];
    CGRect rect = [[self.dataArray[indexPath.row] subject]  boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, 0) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:fontDt context:nil];
    
    CGRect rect1;
    if ([[self.dataArray[indexPath.row] poetry_notes] length] != 0) {
        rect1 = [[self.dataArray[indexPath.row] poetry_notes] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, 0) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:fontDt context:nil];
    } else {
        rect1 = CGRectZero;
    }
    shiModel *model = self.dataArray[indexPath.row];
    if (model.images.length == 0) {
        return rect.size.height + rect1.size.height + 130;
    } else {
        return rect.size.height + rect1.size.height + 280;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    shiModel *model = self.dataArray[indexPath.row];
    zuopindetailViewController *detail = [zuopindetailViewController new];
    detail.newid = model.id;
    detail.titlestr = model.nick_name;
    detail.headImg = model.user_head;
    
    
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
