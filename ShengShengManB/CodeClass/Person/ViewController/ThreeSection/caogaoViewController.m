//
//  caogaoViewController.m
//  ShengShengManB
//
//  Created by mibo02 on 17/6/26.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "caogaoViewController.h"
#import "tongyongCell.h"
#import "shidetailViewController.h"
#import "qudetailViewController.h"
#import "cidetailViewController.h"
@interface caogaoViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong)NSDictionary *editdic;
@end

@implementation caogaoViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"草稿";
    [self request];
}
- (void)request
{
    [self showProgressHUD];
    [NetWorkManager requestForGetWithUrl:[NSString stringWithFormat:@"%@?token=%@&pageNo=%d",draftpageURL,[UserInfoManager getUserInfo].token,1] parameter:@{} success:^(id reponseObject) {
        
        for (NSDictionary *dic in reponseObject[@"result"][@"list"]) {
            [self.dataArray addObject:dic];
        }
        [self.tableview reloadData];
        [self hideProgressHUD];
    } failure:^(NSError *error) {
        [mdfivetool checkinternationInfomation:error];
        [self hideProgressHUD];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"fengfeng";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:str];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"[%@]%@",self.dataArray[indexPath.row][@"head"],self.dataArray[indexPath.row][@"rhythm"]];
    cell.detailTextLabel.text =  [getTimes compareCurrentTime:self.dataArray[indexPath.row][@"time"]];
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
//进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self showProgressHUD];
        [NetWorkManager requestForGetWithUrl:[NSString stringWithFormat:@"%@?token=%@&id=%@",draftdeleteURL,[UserInfoManager getUserInfo].token,self.dataArray[indexPath.row][@"id"]] parameter:@{} success:^(id reponseObject) {
            [MBProgressHUD showError:reponseObject[@"msg"]];
            if ([reponseObject[@"code"] integerValue] == 1) {
                [self.dataArray removeObjectAtIndex:indexPath.row];
                [self.tableview deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
           
            [self hideProgressHUD];
        } failure:^(NSError *error) {
            [mdfivetool checkinternationInfomation:error];
            [self hideProgressHUD];
        }];
      
    }
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    [NetWorkManager requestForGetWithUrl:[NSString stringWithFormat:@"%@?token=%@&id=%@",draftinfoURL,[UserInfoManager getUserInfo].token,self.dataArray[indexPath.row][@"id"]] parameter:@{} success:^(id reponseObject) {
        
        
        if ([reponseObject[@"code"] integerValue] == 1) {
            
            self.editdic = reponseObject[@"result"];
            
            if ([self.editdic[@"type"] isEqualToString:@"shi"]) {
                [self shidic:self.editdic];
                
            } else if ([self.editdic[@"type"] isEqualToString:@"ci"]){
                
                [self cidic:self.editdic];
            } else {
                [self qudic:self.editdic];
            }
            
        }
        
    } failure:^(NSError *error) {
        [mdfivetool checkinternationInfomation:error];
        [self hideProgressHUD];
    }];
   
}

- (void)shidic:(NSDictionary *)editdic
{
   
    NSMutableArray *shiarr = [NSMutableArray new];
    [NetWorkManager requestForGetWithUrl:poetryinfoURL parameter:@{} success:^(id reponseObject) {
        
        if ([reponseObject[@"code"] integerValue] == 1) {
            
            for (NSDictionary *dic in reponseObject[@"result"]) {
                if ([dic[@"id"] isEqualToString:editdic[@"head_id"]]) {
                    
                    for (NSDictionary *newdic in dic[@"rhythmList"]) {
                        
                        if ([newdic[@"id"] isEqualToString:editdic[@"rhythm_id"]]) {
                    
                            [shiarr addObject:newdic[@"subjectList"]];
                            
                        }
                    }
                }
            }
        }
        if (shiarr.count != 0) {
            shidetailViewController *three =[shidetailViewController new];
            three.newarr = shiarr[0];
            three.yunshustr = editdic[@"yunyun"];
            three.yunid = editdic[@"yunyun_id"];
            three.headid = editdic[@"head_id"];
            three.rhythmid = editdic[@"rhythm_id"];
            if (editdic[@"poetry_notes"] == [NSNull null]) {
                three.poetry_notes = @"";
            } else {
                three.poetry_notes = editdic[@"poetry_notes"];
            }
            
            three.body = editdic[@"body"];
            if (editdic[@"images"] == [NSNull null]) {
                three.images = @"";
            } else {
                three.images = editdic[@"images"];
            }
            
            [self.navigationController pushViewController:three animated:YES];
        }
        
    } failure:^(NSError *error) {
        [mdfivetool checkinternationInfomation:error];
        [self hideProgressHUD];
    }];
   
}
- (void)cidic:(NSDictionary *)editdic
{
     NSMutableArray *shiarr = [NSMutableArray new];
    [NetWorkManager requestForGetWithUrl:wordinfoURL parameter:@{} success:^(id reponseObject) {
        if ([reponseObject[@"code"] integerValue] == 1) {
            
            for (NSDictionary *dic in reponseObject[@"result"]) {
                if ([dic[@"id"] isEqualToString:editdic[@"head_id"]]) {
                    
                    for (NSDictionary *newdic in dic[@"tuneRhymes"]) {
                        
                        if ([newdic[@"id"] isEqualToString:editdic[@"rhythm_id"]]) {
                            
                            [shiarr addObject:newdic[@"subjects"]];
                            
                        }
                    }
                }
            }
        }
        if (shiarr.count != 0) {
            cidetailViewController *three =[cidetailViewController new];
            three.newarr = shiarr[0];
            three.yunshustr = editdic[@"yunyun"];
            three.headid = editdic[@"head_id"];
            three.rhythmid = editdic[@"rhythm_id"];
            if (editdic[@"poetry_notes"] == [NSNull null]) {
                three.poetry_notes = @"";
            } else {
                three.poetry_notes = editdic[@"poetry_notes"];
            }
            three.body = editdic[@"body"];
            if (editdic[@"images"] == [NSNull null]) {
                three.images = @"";
            } else {
                three.images = editdic[@"images"];
            }
            
             three.yunid = editdic[@"yunyun_id"];
            [self.navigationController pushViewController:three animated:YES];
        }

    } failure:^(NSError *error) {
        [mdfivetool checkinternationInfomation:error];
        [self hideProgressHUD];
    }];
}

- (void)qudic:(NSDictionary *)editdic {
     NSMutableArray *shiarr = [NSMutableArray new];
    [NetWorkManager requestForGetWithUrl:songinfoURL parameter:@{} success:^(id reponseObject) {
        if ([reponseObject[@"code"] integerValue] == 1) {
            
            for (NSDictionary *dic in reponseObject[@"result"]) {
                if ([dic[@"id"] isEqualToString:editdic[@"head_id"]]) {
                    
                    for (NSDictionary *newdic in dic[@"qupais"]) {
                        
                        if ([newdic[@"id"] isEqualToString:editdic[@"rhythm_id"]]) {
                            
                            [shiarr addObject:newdic[@"subjects"]];
                            
                        }
                    }
                }
            }
        }
        if (shiarr.count != 0) {
            qudetailViewController *three =[qudetailViewController new];
            three.newarr = shiarr[0];
            three.name = editdic[@"yunyun"];
            three.yunshustr = editdic[@"yunyun"];
            three.headid = editdic[@"head_id"];
            three.rhythmid = editdic[@"rhythm_id"];
            if (editdic[@"poetry_notes"] == [NSNull null]) {
                three.poetry_notes = @"";
            } else {
                three.poetry_notes = editdic[@"poetry_notes"];
            }
            three.body = editdic[@"body"];
            if (editdic[@"images"] == [NSNull null]) {
                three.images = @"";
            } else {
                three.images = editdic[@"images"];
            }
            three.yunid = editdic[@"yunyun_id"];
            [self.navigationController pushViewController:three animated:YES];
        }
    } failure:^(NSError *error) {
        [mdfivetool checkinternationInfomation:error];
        [self hideProgressHUD];
    }];
}

- (nullable NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    UIFont *font = [UIFont systemFontOfSize:15];
    UIColor *color = [UIColor blackColor];
    NSMutableDictionary *attribult = [NSMutableDictionary new];
    [attribult setObject:font forKey:NSFontAttributeName];
    [attribult setObject:color forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:@"暂无草稿" attributes:attribult];
}




@end
