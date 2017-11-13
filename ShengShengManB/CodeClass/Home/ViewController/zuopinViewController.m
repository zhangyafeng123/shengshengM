//
//  zuopinViewController.m
//  ShengShengManB
//
//  Created by mibo02 on 17/5/21.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "AndyDropDownList.h"
#import "zuopinViewController.h"
#import "tongyongCell.h"
#import "personinfoViewController.h"
#import "searchModel.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
// 弹出分享菜单需要导入的头文件
#import <ShareSDKUI/ShareSDK+SSUI.h>
// 自定义分享菜单栏需要导入的头文件
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import "zuopindetailViewController.h"
#import <ShareSDKUI/SSUIEditorViewStyle.h>
#import "LoginViewController.h"
#import "fatieViewController.h"
#import "autorViewController.h"
#import "zuopinModel.h"
#import "HJPhotoBrowserController.h"
@interface zuopinViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource,AndyDropDownDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *rightbtn;
@property (weak, nonatomic) IBOutlet UIButton *leftbtn;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)NSMutableArray *listArray;
@property (nonatomic, strong)AndyDropDownList *listleft;
@property (nonatomic, strong)NSArray *leftArr;
@property (nonatomic, strong)UITextField *textF;
@property (nonatomic, assign)NSInteger pages;
@property (nonatomic, strong)NSMutableArray *searchArray;
//
@property (nonatomic, copy)NSString *autorid;
@property (nonatomic, strong)UILabel *titlelab;
@property (nonatomic, copy)NSString *pagestr;
@end

@implementation zuopinViewController
- (NSMutableArray *)searchArray
{
    if (!_searchArray) {
        self.searchArray = [NSMutableArray new];
    }
    return _searchArray;
}
- (NSMutableArray *)listArray
{
    if (!_listArray) {
        self.listArray = [NSMutableArray new];
    }
    return _listArray;
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authoraction:) name:@"author" object:nil];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)authoraction:(NSNotification *)not
{
    self.autorid = not.userInfo[@"newid"];
    [self.rightbtn setTitle:not.userInfo[@"nick"] forState:(UIControlStateNormal)];
    self.pages = 1;
    [self.listArray removeAllObjects];
    self.typestr = @"user";
    [self request:self.typestr category:self.autorid];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pages = 1;
    self.pagestr = @"1";
    self.navigationController.navigationBar.translucent = NO;
    [self.tableview registerNib:[UINib nibWithNibName:@"tongyongCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    
    self.leftArr = @[@"按体裁检索",@"诗",@"词",@"曲",@"其他"];
    
    _listleft = [[AndyDropDownList alloc]initWithListDataSource:self.leftArr rowHeight:44 view:self.leftbtn];
    _listleft.tag = 160;
    _listleft.hidden = YES;
    _listleft.delegate = self;
    [self.view addSubview:_listleft];
   
     [self.leftbtn addTarget:self action:@selector(leftBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.rightbtn addTarget:self action:@selector(rightbtnaction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self createtextfield];
    [self request:self.typestr category:self.typestr];
   
}
- (void)createtextfield
{
    self.textF = [[UITextField alloc] initWithFrame:CGRectMake(50, 20, SCREEN_WIDTH - 100, 30)];
    self.textF.borderStyle = UITextBorderStyleNone;
    self.textF.backgroundColor = [UIColor whiteColor];
    self.textF.placeholder = @"请输入关键词";
    self.textF.hidden = YES;
    self.textF.layer.cornerRadius = 4;
    self.textF.font = H15;
    self.textF.layer.masksToBounds = YES;
    self.textF.returnKeyType = UIReturnKeySearch;
    self.textF.delegate = self;
    
    self.titlelab  = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, SCREEN_WIDTH - 100, 30)];
    self.titlelab.font = H17;
    self.titlelab.textColor = [UIColor whiteColor];
    self.titlelab.textAlignment = NSTextAlignmentCenter;
    if (self.textF.hidden) {
        self.navigationItem.titleView = self.titlelab;
    } else {
        self.navigationItem.titleView = self.textF;
    }
    self.titlelab.text = @"作品欣赏";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem CreateItemWithTarget:self ForAction:@selector(searchaction) WithImage:@"search_icon_white-1" WithHighlightImage:nil];
    
    if ([self.typestr isEqualToString:@"shi"]) {
        self.leftbtn.enabled = NO;
        [self.leftbtn setTitle:@"诗" forState:(UIControlStateNormal)];
        self.titlelab.text  = @"步韵和诗";
    } else if([self.typestr isEqualToString:@"ot"]){
        [self.leftbtn setTitle:@"其他" forState:(UIControlStateNormal)];
         self.titlelab.text = @"百家争鸣";
        UIBarButtonItem *item1  = [UIBarButtonItem CreateItemWithTarget:self ForAction:@selector(searchaction) WithImage:@"search_icon_white-1" WithHighlightImage:nil];
        UIBarButtonItem *item2 = [UIBarButtonItem initWithTitle:@"发帖" titleColor:[UIColor whiteColor] target:self action:@selector(actionfatie)];
        self.navigationItem.rightBarButtonItems = @[item2,item1];
    } else {
        [self.leftbtn setTitle:@"按体裁检索" forState:(UIControlStateNormal)];
    }
}
//搜索
- (void)searchaction
{
    self.view.tag = !self.view.tag;
    if (!self.view.tag) {
        
        [UIView animateWithDuration:2 animations:^{
            self.textF.hidden = YES;
            if (self.textF.hidden) {
                self.navigationItem.titleView = self.titlelab;
            } else {
                self.navigationItem.titleView = self.textF;
            }
            self.textF.text = @"";
            [self.searchArray removeAllObjects];
            [self.listArray removeAllObjects];
            self.pages = 1;
            [self request:self.typestr category:self.typestr];
           
        }];
        
        
    } else {
        [UIView animateWithDuration:2 animations:^{
            self.textF.hidden = NO;
            if (self.textF.hidden) {
                self.navigationItem.titleView = self.titlelab;
            } else {
                self.navigationItem.titleView = self.textF;
            }
        }];
        
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField.text.length == 0) {
        [MBProgressHUD showError:@"搜索内容不能为空"];
    }
    
    [self.listArray removeAllObjects];
    [self requestsearch:textField];
    
    return YES;
}
//request（search）
- (void)requestsearch:(UITextField *)textf1
{
    NSString *url = [NSString stringWithFormat:@"%@?keyword=%@&page_no=%@",searchURL,textf1.text,self.pagestr];
    NSString *str1 = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self showProgressHUD];
    [NetWorkManager requestForGetWithUrl:str1 parameter:@{} success:^(id reponseObject) {
        if ([reponseObject[@"code"] integerValue] == 1) {
            for (NSDictionary *dic in reponseObject[@"result"][@"list"]) {
                searchModel *model = [searchModel new];
                [model setValuesForKeysWithDictionary:dic];
                [self.searchArray addObject:model];
            }
        }
        [self.tableview reloadData];
        [self hideProgressHUD];
        [self refreshfooternew:[reponseObject[@"result"][@"totalPage"] integerValue] textf:textf1];
    } failure:^(NSError *error) {
        [mdfivetool checkinternationInfomation:error];
    }];
}
- (void)refreshfooternew:(NSInteger)totalpages textf:(UITextField *)textf1;
{
    if (totalpages > self.pagestr.integerValue) {
        NSInteger page = self.pagestr.integerValue;
        page += 1;
        self.pagestr = [NSString stringWithFormat:@"%ld",page];
        self.tableview.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
            [self.tableview.mj_footer beginRefreshing];
            [self requestsearch:textf1];
            [self.tableview.mj_footer endRefreshing];
        }];
    } else {
        self.tableview.mj_footer.state = MJRefreshStateNoMoreData;
    }
}

- (void)actionfatie
{
    if ([UserInfoManager isLoading]) {
        fatieViewController *fatie = [fatieViewController new];
        [self.navigationController pushViewController:fatie animated:YES];
    } else {
        LoginViewController *login = [LoginViewController new];
        [self.navigationController pushViewController:login animated:YES];
    }
}

//按照自己检索
- (void)rightbtnaction:(UIButton *)sender
{
    if ([UserInfoManager isLoading]) {
        autorViewController *autor = [autorViewController new];
        [self.navigationController pushViewController:autor animated:YES];
    } else {
        LoginViewController *login = [LoginViewController new];
        [self.navigationController pushViewController:login animated:YES];
    }
    
}
- (void)leftBtnAction:(UIButton *)sender
{
    if ([UserInfoManager isLoading]) {
        _listleft.hidden = NO;
        [_listleft showList];
    } else {
        LoginViewController *login = [LoginViewController new];
        [self.navigationController pushViewController:login animated:YES];
    }
}

-(void)dropDownListParame:(NSString *)aStr dropdownlist:(AndyDropDownList *)list index:(NSInteger)index
{
    self.pages = 1;
    [self.listArray removeAllObjects];
    if (list.tag == 160) {
        [self.leftbtn setTitle:aStr forState:(UIControlStateNormal)];
        if ([aStr isEqualToString:@"按体裁检索"]) {
            self.typestr = @"mr";
        } else if ([aStr isEqualToString:@"诗"]){
            self.typestr = @"shi";
        } else if ([aStr isEqualToString:@"词"]){
            self.typestr = @"ci";
        } else if ([aStr isEqualToString:@"曲"]){
            self.typestr = @"qu";
        } else {
            self.typestr = @"ot";
        }
         [self request:self.typestr category:self.typestr];
    }
}
- (void)request:(NSString *)str category:(NSString *)newstr
{
   
    [NetWorkManager requestForGetWithUrl:[NSString stringWithFormat:@"%@?token=%@&type=%@&category=%@&page_no=%ld",bbslistURL,[UserInfoManager getUserInfo].token,str,newstr,self.pages] parameter:@{} success:^(id reponseObject) {
        if ([reponseObject[@"code"] integerValue] == 1) {
           
            self.dataArray = [zuopinModel mj_objectArrayWithKeyValuesArray:reponseObject[@"result"][@"result"][@"list"]];
            [self.listArray addObjectsFromArray:self.dataArray];
        }
        [self.tableview reloadData];
        [self refreshfooternew:[reponseObject[@"result"][@"result"][@"totalPage"] integerValue]typestr:str category:newstr];
        
    } failure:^(NSError *error) {
        [mdfivetool checkinternationInfomation:error];
    }];
}
//上拉刷新
- (void)refreshfooternew:(NSInteger)totalpages typestr:(NSString *)str category:(NSString *)categorystr
{
    if (totalpages > self.pages) {
        self.pages += 1;
        self.tableview.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
            [self.tableview.mj_footer beginRefreshing];
            [self request:str category:categorystr];
            [self.tableview.mj_footer endRefreshing];
        }];
    } else {
        self.tableview.mj_footer.state = MJRefreshStateNoMoreData;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.textF.text.length != 0) {
        return self.searchArray.count;
    } else {
        return self.listArray.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tongyongCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (self.textF.text.length != 0) {
        searchModel *model = self.searchArray[indexPath.row];
        [cell.headimg sd_setBackgroundImageWithURL:[NSURL URLWithString:model.user_head] forState:(UIControlStateNormal)];
        
        NSString *str = [TodayDate getgradefor:model.grade];
        
        if (model.nick_name) {
            cell.nickname.attributedText = [ZLabel attributedTextArray:@[model.nick_name,str] textColors:@[[UIColor blueColor],[UIColor blackColor]] textfonts:@[H15,H11]];
        }
        
        if (model.poetry_notes) {
            cell.contentlab.text = [NSString stringWithFormat:@"%@\n注释:%@",model.subject, model.poetry_notes];
        } else {
            cell.contentlab.text = model.subject;
        }
        
        cell.headimg.tag = indexPath.row + 300;
        
        [cell.headimg addTarget:self action:@selector(headimgAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        NSString *timestr = [getTimes compareCurrentTime:model.create_time];
        
        if ([self.typestr isEqualToString:@"shi"]) {
            cell.contentlab.textAlignment = NSTextAlignmentCenter;
        } else {
            cell.contentlab.textAlignment = NSTextAlignmentLeft;
        }
        cell.shoucangbtn.enabled = NO;
        cell.dianzanbtn.enabled = NO;
        cell.liulanlab.text = [NSString stringWithFormat:@"%@ 浏览(%ld)",timestr,model.browse_number];
        cell.zhuanfabtn.tag = 900 + indexPath.row;
        cell.pinglunbtn.tag = 700 + indexPath.row;
        //转发
        [cell.zhuanfabtn setTitle:[NSString stringWithFormat:@"%ld",model.relay_number] forState:(UIControlStateNormal)];
        //评论
        [cell.pinglunbtn setTitle:[NSString stringWithFormat:@"%ld",model.comments_number] forState:(UIControlStateNormal)];
        NSArray *arr;
        
        if (model.images.length != 0) {
            cell.imgbackview.hidden = NO;
            cell.constraintview.constant = 120;
            cell.btnconstraint.constant = 130;
            NSString *str = model.images;
            if (![str containsString:@"|"]) {
                [cell.leftimglab sd_setImageWithURL:[NSURL URLWithString:str] forState:(UIControlStateNormal)];
                [cell.centerlab sd_setImageWithURL:[NSURL URLWithString:@""] forState:(UIControlStateNormal)];
                [cell.rightlab sd_setImageWithURL:[NSURL URLWithString:@""] forState:(UIControlStateNormal)];
            } else {
                arr = [str componentsSeparatedByString:@"|"];
                if (arr.count == 1) {
                    [cell.leftimglab sd_setImageWithURL:[NSURL URLWithString:str] forState:(UIControlStateNormal)];
                    [cell.centerlab sd_setImageWithURL:[NSURL URLWithString:@""] forState:(UIControlStateNormal)];
                    [cell.rightlab sd_setImageWithURL:[NSURL URLWithString:@""] forState:(UIControlStateNormal)];
                } else if (arr.count == 2){
                    [cell.leftimglab sd_setImageWithURL:[NSURL URLWithString:arr[0]] forState:(UIControlStateNormal)];
                    [cell.centerlab sd_setImageWithURL:[NSURL URLWithString:arr[1]] forState:(UIControlStateNormal)];
                    [cell.rightlab sd_setImageWithURL:[NSURL URLWithString:@""] forState:(UIControlStateNormal)];
                }  else {
                    [cell.leftimglab sd_setImageWithURL:[NSURL URLWithString:arr[0]] forState:(UIControlStateNormal)];
                    [cell.centerlab sd_setImageWithURL:[NSURL URLWithString:arr[1]] forState:(UIControlStateNormal)];
                    [cell.rightlab sd_setImageWithURL:[NSURL URLWithString:arr[2]] forState:(UIControlStateNormal)];
                }
            }
            
            cell.leftimglab.tag = 900 + indexPath.row;
            cell.centerlab.tag = 900 + indexPath.row;
            cell.rightlab.tag = 900 + indexPath.row;
            
        } else {
            cell.imgbackview.hidden = YES;
            cell.constraintview.constant = 5.0;
            cell.btnconstraint.constant = 5.0;
        }
        
        cell.leftimglab.imageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.centerlab.imageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.rightlab.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [cell.leftimglab addTarget:self action:@selector(imagebtnnewaction:) forControlEvents:(UIControlEventTouchUpInside)];
        [cell.centerlab addTarget:self action:@selector(imagebtnnewaction:) forControlEvents:(UIControlEventTouchUpInside)];
        [cell.rightlab addTarget:self action:@selector(imagebtnnewaction:) forControlEvents:(UIControlEventTouchUpInside)];

    } else {
        zuopinModel *model = self.listArray[indexPath.row];
        
        [cell.headimg sd_setBackgroundImageWithURL:[NSURL URLWithString:model.body.user_head] forState:(UIControlStateNormal)];
        
        NSString *str = [TodayDate getgradefor:model.body.grade];
        
        if (model.body.nick_name) {
            cell.nickname.attributedText = [ZLabel attributedTextArray:@[model.body.nick_name,str] textColors:@[[UIColor blueColor],[UIColor blackColor]] textfonts:@[H15,H11]];
        }
        cell.contentlab.userInteractionEnabled = YES;
        if (model.body.poetry_notes) {
            NSString *str1 = [NSString stringWithFormat:@"%@\n",model.body.subject];
            NSString *str2 = [NSString stringWithFormat:@"注释:%@",model.body.poetry_notes];
            cell.contentlab.attributedText = [ZLabel attributedTextArray:@[str1,str2] textColors:@[[UIColor blackColor],[UIColor grayColor]] textfonts:@[H14,H14]];
        } else {
            cell.contentlab.text = model.body.subject;
        }
        
        cell.headimg.tag = indexPath.row + 300;
        
        [cell.headimg addTarget:self action:@selector(headimgAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        NSString *timestr = [getTimes compareCurrentTime:model.body.create_time];
        
        if ([self.typestr isEqualToString:@"shi"]) {
            cell.contentlab.textAlignment = NSTextAlignmentCenter;
        } else {
            cell.contentlab.textAlignment = NSTextAlignmentLeft;
        }
        UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        longPressGr.minimumPressDuration = 1.0;
        [cell.contentlab addGestureRecognizer:longPressGr];
        
        
        cell.liulanlab.text = [NSString stringWithFormat:@"%@ 浏览(%ld)",timestr,model.body.browse_number];
        
        if (model.isCollect == 1) {
            cell.shoucangbtn.selected = YES;
        } else {
            cell.shoucangbtn.selected = NO;
        }
        if (model.isPraise == 1) {
            cell.dianzanbtn.selected = YES;
        } else {
            cell.dianzanbtn.selected = NO;
        }
        cell.shoucangbtn.enabled = YES;
        cell.dianzanbtn.enabled = YES;
        //收藏
        cell.shoucangbtn.tag = 100 + indexPath.row;
        
        [cell.shoucangbtn setTitle:[NSString stringWithFormat:@"%ld",model.body.collect_number] forState:(UIControlStateNormal)];
        
        [cell.shoucangbtn addTarget:self action:@selector(shoucangbtnaction:) forControlEvents:(UIControlEventTouchUpInside)];
        cell.zhuanfabtn.tag = 900 + indexPath.row;
        cell.pinglunbtn.tag = 700 + indexPath.row;
        //转发
        [cell.zhuanfabtn setTitle:[NSString stringWithFormat:@"%ld",model.body.relay_number] forState:(UIControlStateNormal)];
        //评论
        [cell.pinglunbtn setTitle:[NSString stringWithFormat:@"%ld",model.body.comments_number] forState:(UIControlStateNormal)];
        cell.dianzanbtn.tag =  500 + indexPath.row;
        //点赞
        [cell.dianzanbtn setTitle:[NSString stringWithFormat:@"%ld",model.body.riokin_number] forState:(UIControlStateNormal)];
        [cell.zhuanfabtn addTarget:self action:@selector(zhuanfabtnaction:) forControlEvents:(UIControlEventTouchUpInside)];
        [cell.pinglunbtn addTarget:self action:@selector(pinglunbtnaction:) forControlEvents:(UIControlEventTouchUpInside)];
        [cell.dianzanbtn addTarget:self action:@selector(dianzanbtnaction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        NSArray *arr;
        
        if (model.body.images.length != 0) {
            cell.imgbackview.hidden = NO;
            cell.constraintview.constant = 120;
            cell.btnconstraint.constant = 130;
            NSString *str = model.body.images;
            if (![str containsString:@"|"]) {
                [cell.leftimglab sd_setImageWithURL:[NSURL URLWithString:str] forState:(UIControlStateNormal)];
                [cell.centerlab sd_setImageWithURL:[NSURL URLWithString:@""] forState:(UIControlStateNormal)];
                [cell.rightlab sd_setImageWithURL:[NSURL URLWithString:@""] forState:(UIControlStateNormal)];
            } else {
                arr = [str componentsSeparatedByString:@"|"];
                if (arr.count == 1) {
                    [cell.leftimglab sd_setImageWithURL:[NSURL URLWithString:str] forState:(UIControlStateNormal)];
                    [cell.centerlab sd_setImageWithURL:[NSURL URLWithString:@""] forState:(UIControlStateNormal)];
                    [cell.rightlab sd_setImageWithURL:[NSURL URLWithString:@""] forState:(UIControlStateNormal)];
                } else if (arr.count == 2){
                    [cell.leftimglab sd_setImageWithURL:[NSURL URLWithString:arr[0]] forState:(UIControlStateNormal)];
                    [cell.centerlab sd_setImageWithURL:[NSURL URLWithString:arr[1]] forState:(UIControlStateNormal)];
                    [cell.rightlab sd_setImageWithURL:[NSURL URLWithString:@""] forState:(UIControlStateNormal)];
                }  else {
                    [cell.leftimglab sd_setImageWithURL:[NSURL URLWithString:arr[0]] forState:(UIControlStateNormal)];
                    [cell.centerlab sd_setImageWithURL:[NSURL URLWithString:arr[1]] forState:(UIControlStateNormal)];
                    [cell.rightlab sd_setImageWithURL:[NSURL URLWithString:arr[2]] forState:(UIControlStateNormal)];
                }
            }
            
            cell.leftimglab.tag = 900 + indexPath.row;
            cell.centerlab.tag = 900 + indexPath.row;
            cell.rightlab.tag = 900 + indexPath.row;
            
        } else {
            cell.imgbackview.hidden = YES;
            cell.constraintview.constant = 5.0;
            cell.btnconstraint.constant = 5.0;
        }
        
        cell.leftimglab.imageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.centerlab.imageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.rightlab.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [cell.leftimglab addTarget:self action:@selector(imagebtnnewaction:) forControlEvents:(UIControlEventTouchUpInside)];
        [cell.centerlab addTarget:self action:@selector(imagebtnnewaction:) forControlEvents:(UIControlEventTouchUpInside)];
        [cell.rightlab addTarget:self action:@selector(imagebtnnewaction:) forControlEvents:(UIControlEventTouchUpInside)];

    }
    return cell;
}
- (void)handleTap:(UILongPressGestureRecognizer *)gest
{
    UILabel *lab = (UILabel *)gest.view;
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = lab.text;
    [MBProgressHUD showError:@"内容已复制到剪切板"];
}
//图片放大
- (void)imagebtnnewaction:(UIButton *)sender
{
    if (self.textF.text.length != 0) {
        searchModel *model = self.searchArray[sender.tag - 900];
       
        if (model.images.length != 0) {
            NSString *str = model.images;
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
    } else {
        zuopinModel *model = self.listArray[sender.tag - 900];
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
    
}
//收藏按钮
- (void)shoucangbtnaction:(UIButton *)sender
{

    zuopinModel *model = self.listArray[sender.tag - 100];
    if (model.isCollect == 1) {
    
        //取消收藏
        [NetWorkManager requestForGetWithUrl:[NSString stringWithFormat:@"%@?token=%@&bbsid=%@",bbscancelCollectURL,[UserInfoManager getUserInfo].token,model.body.id] parameter:@{} success:^(id reponseObject) {
            if ([reponseObject[@"code"] integerValue] == 422) {
                LoginViewController *login = [LoginViewController new];
                [self.navigationController pushViewController:login animated:YES];
            } else {
               
                NSInteger i = model.body.collect_number;
                i-=1;
                model.body.collect_number = i;
                BOOL j = !model.isCollect;
                model.isCollect = j;
                [self.listArray replaceObjectAtIndex:sender.tag-100 withObject:model];
                [self.tableview reloadData];
                
            }
            [MBProgressHUD showError:reponseObject[@"msg"]];
        } failure:^(NSError *error) {
            [mdfivetool checkinternationInfomation:error];
            [self hideProgressHUD];
        }];
        
        
    } else {
        
        [NetWorkManager requestForGetWithUrl:[NSString stringWithFormat:@"%@?token=%@&bbsid=%@",bbsaddCollectURL,[UserInfoManager getUserInfo].token,model.body.id] parameter:@{} success:^(id reponseObject) {
            if ([reponseObject[@"code"] integerValue] == 422) {
                LoginViewController *login = [LoginViewController new];
                [self.navigationController pushViewController:login animated:YES];
            } else {
                NSInteger i = model.body.collect_number;
                i+=1;
                model.body.collect_number = i;
                BOOL j = !model.isCollect;
                model.isCollect = j;
                [self.listArray replaceObjectAtIndex:sender.tag-100 withObject:model];
                [self.tableview reloadData];
                
            }
           
            [MBProgressHUD showError:reponseObject[@"msg"]];
        } failure:^(NSError *error) {
            [mdfivetool checkinternationInfomation:error];
            [self hideProgressHUD];
        }];
    }
    
   
}
//头像点击事件
- (void)headimgAction:(UIButton *)sender
{
    if ([UserInfoManager isLoading]) {
        if (self.textF.text.length != 0) {
            searchModel *model = self.searchArray[sender.tag - 300];
            personinfoViewController *person = [personinfoViewController new];
            person.userid = model.user_id;
            if (model.nick_name) {
                person.nickname = model.nick_name;
            } else {
                person.nickname = @"未设置";
            }
            
            if ([self.typestr isEqualToString:@"shi"]) {
                person.iscenter = 1;
            } else {
                person.iscenter = 0;
            }
            [self.navigationController pushViewController:person animated:YES];
        } else {
            zuopinModel *model = self.listArray[sender.tag - 300];
            personinfoViewController *person = [personinfoViewController new];
            person.userid = model.body.user_id;
            if (model.body.nick_name) {
                person.nickname = model.body.nick_name;
            } else {
                person.nickname = @"未设置";
            }
            
            if ([self.typestr isEqualToString:@"shi"]) {
                person.iscenter = 1;
            } else {
                person.iscenter = 0;
            }
            [self.navigationController pushViewController:person animated:YES];
        }
       
    } else {
        LoginViewController *login = [LoginViewController new];
        [self.navigationController pushViewController:login animated:YES];
    }
   
}
//转发
- (void)zhuanfabtnaction:(UIButton *)sender
{
    
    if ([UserInfoManager isLoading]) {
        if (self.textF.text.length != 0) {
            searchModel *model = self.searchArray[sender.tag - 900];
            NSString *newid = model.id;
            NSString *subjectstr;
            if (model.poetry_notes.length != 0) {
                subjectstr =  [NSString stringWithFormat:@"%@\n%@",model.subject,model.poetry_notes];
            } else {
                subjectstr = model.subject;
            }
            [self fenxiang:newid subject:subjectstr];
        } else {
            zuopinModel *model = self.listArray[sender.tag - 900];
            NSString *newid = model.body.id;
            NSString *subjectstr;
            if (model.body.poetry_notes.length != 0) {
                subjectstr =  [NSString stringWithFormat:@"%@\n%@",model.body.subject,model.body.poetry_notes];
            } else {
                subjectstr = model.body.subject;
            }
            [self fenxiang:newid subject:subjectstr];
        }
        
    } else {
        LoginViewController *login = [LoginViewController new];
        [self.navigationController pushViewController:login animated:YES];
    }
    
}
- (void)fenxiang:(NSString *)newid subject:(NSString *)subjectstr
{
    NSString *wechaturl = [NSString stringWithFormat:@"http://share.shengshengman.net/?id=%@",newid];
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    [shareParams SSDKSetupShareParamsByText:subjectstr
                                     images:@[@"http://app.shengshengman.net/ssmcms/userfiles/20170317141631707000857331759957/images/icon/show_img.png"]
                                        url:[NSURL URLWithString:wechaturl]
                                      title:@"声声慢"
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
                       {
                           NSString *typestr;
                           
                           if (platformType == SSDKPlatformSubTypeWechatTimeline) {
                               
                               typestr = @"wcc";
                           } else if (platformType == SSDKPlatformSubTypeWechatSession){
                               
                               typestr = @"wcg";
                           } else if (platformType == SSDKPlatformSubTypeQZone){
                               typestr = @"qqz";
                           } else if (platformType == SSDKPlatformSubTypeQQFriend){
                               typestr = @"qq";
                           }
                           
                           [NetWorkManager requestForPostWithUrl:bbsaddRelayURL parameter:@{@"token":[UserInfoManager getUserInfo].token,@"type":typestr,@"bbsid":newid} success:^(id reponseObject) {
                               [MBProgressHUD showError:reponseObject[@"msg"]];
                               
                               if (self.textF.text.length != 0) {
                                   [self.searchArray removeAllObjects];
                                   self.pagestr = @"1";
                                   [self requestsearch:self.textF];
                               } else {
                                   [self.listArray removeAllObjects];
                                   self.pages = 1;
                                   [self request:self.typestr category:self.typestr];
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
    if ([UserInfoManager isLoading]) {
        if (self.textF.text.length != 0) {
            searchModel *model = self.searchArray[sender.tag - 700];
            zuopindetailViewController *detail = [zuopindetailViewController new];
            detail.newid = model.id;
            
            if (model.nick_name) {
                detail.titlestr = model.nick_name;
            } else {
                detail.titlestr = @"未设置";
            }
            if (model.user_head) {
                detail.headImg = model.user_head;
            } else {
                detail.headImg = @"wdl";
            }
            
            detail.isshoucangnum = NO;
            detail.islike = NO;
            [self.navigationController pushViewController:detail animated:YES];

        } else {
            zuopinModel *model = self.listArray[sender.tag - 700];
            zuopindetailViewController *detail = [zuopindetailViewController new];
            detail.newid = model.body.id;
            
            if (model.body.nick_name) {
                detail.titlestr = model.body.nick_name;
            } else {
                detail.titlestr = @"未设置";
            }
            if (model.body.user_head) {
                detail.headImg = model.body.user_head;
            } else {
                detail.headImg = @"wdl";
            }
            
            detail.isshoucangnum = model.isCollect;
            detail.islike = model.isPraise;
            [self.navigationController pushViewController:detail animated:YES];

        }
        } else {
        LoginViewController *login = [LoginViewController new];
        [self.navigationController pushViewController:login animated:YES];
    }
    
}
//点赞
- (void)dianzanbtnaction:(UIButton *)sender
{
    zuopinModel *model = self.listArray[sender.tag - 500];
    NSString *newid = model.body.id;
   
    if (sender.isSelected) {
        NSString *url = [NSString stringWithFormat:@"%@?token=%@&bbsid=%@",bbscancelRiokinURL,[UserInfoManager getUserInfo].token,newid];
        [NetWorkManager requestForGetWithUrl:url parameter:@{} success:^(id reponseObject) {
            if ([reponseObject[@"code"] integerValue] == 422) {
                LoginViewController *login = [LoginViewController new];
                [self.navigationController pushViewController:login animated:YES];
            } else {
                NSInteger i = model.body.riokin_number;
                i-=1;
                model.body.riokin_number = i;
                BOOL j = !model.isPraise;
                model.isPraise = j;
                [self.listArray replaceObjectAtIndex:sender.tag - 500 withObject:model];
                [self.tableview reloadData];
            }
            
            [MBProgressHUD showError:reponseObject[@"msg"]];
            
        } failure:^(NSError *error) {
            [mdfivetool checkinternationInfomation:error];
            [self hideProgressHUD];
        }];
    } else {
        NSString *url = [NSString stringWithFormat:@"%@?token=%@&bbsid=%@",bbsaddRiokinURL,[UserInfoManager getUserInfo].token,newid];
        
        [NetWorkManager requestForGetWithUrl:url parameter:@{} success:^(id reponseObject) {
            if ([reponseObject[@"code"] integerValue] == 422) {
                LoginViewController *login = [LoginViewController new];
                [self.navigationController pushViewController:login animated:YES];
            } else {
                NSInteger i = model.body.riokin_number;
                i+=1;
                model.body.riokin_number = i;
                BOOL j = !model.isPraise;
                model.isPraise = j;
                [self.listArray replaceObjectAtIndex:sender.tag - 500 withObject:model];
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
    if (self.textF.text.length != 0) {
        searchModel *model = self.searchArray[indexPath.row];
        NSString *contentstr;
        if (model.poetry_notes.length != 0) {
            contentstr = [NSString stringWithFormat:@"%@\n%@",model.subject,model.poetry_notes];
        } else {
            contentstr  = model.subject;
        }
        CGRect rect = [TodayDate getstringheightfor:contentstr];
        
        if (model.images.length != 0)  {
            return rect.size.height  + 240;
        } else {
            return rect.size.height  + 120;
        }

    } else {
        zuopinModel *model = self.listArray[indexPath.row];
        NSString *contentstr;
        if (model.body.poetry_notes.length != 0) {
            contentstr = [NSString stringWithFormat:@"%@\n%@",model.body.subject,model.body.poetry_notes];
        } else {
            contentstr  = model.body.subject;
        }
        CGRect rect = [TodayDate getstringheightfor:contentstr];
        
        if (model.body.images.length != 0)  {
            return rect.size.height  + 240;
        } else {
            return rect.size.height  + 120;
        }
    }
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.textF.text.length != 0) {
        searchModel *model = self.searchArray[indexPath.row];
        zuopindetailViewController *detail = [zuopindetailViewController new];
        
        detail.newid = model.id;
        if (model.nick_name) {
            
            detail.titlestr =model.nick_name;
        } else {
            detail.titlestr = @"未设置";
        }
        if (model.user_head) {
            detail.headImg = model.user_head;
        } else {
            detail.headImg = @"wdl";
        }
        
        detail.isshoucangnum = NO;
        detail.islike = NO;
        if ([self.typestr isEqualToString:@"shi"]) {
            detail.iscenter = 1;
        } else {
            detail.iscenter = 0;
        }
        [self.navigationController pushViewController:detail animated:YES];

    } else {
        zuopindetailViewController *detail = [zuopindetailViewController new];
        zuopinModel *model = self.listArray[indexPath.row];
        detail.newid = model.body.id;
        if (model.body.nick_name) {
            
            detail.titlestr =model.body.nick_name;
        } else {
            detail.titlestr = @"未设置";
        }
        if (model.body.user_head) {
            detail.headImg = model.body.user_head;
        } else {
            detail.headImg = @"wdl";
        }
        
        detail.isshoucangnum = model.isCollect;
        detail.islike = model.isPraise;
        if ([self.typestr isEqualToString:@"shi"]) {
            detail.iscenter = 1;
        } else {
            detail.iscenter = 0;
        }
        [self.navigationController pushViewController:detail animated:YES];
    }
   
}
- (nullable NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    UIFont *font = H15;
    UIColor *color = [UIColor blackColor];
    NSMutableDictionary *attribult = [NSMutableDictionary new];
    [attribult setObject:font forKey:NSFontAttributeName];
    [attribult setObject:color forKey:NSForegroundColorAttributeName];
    if (self.textF.text.length != 0) {
       return [[NSAttributedString alloc] initWithString:@"什么都没搜索到呢" attributes:attribult];
    } else {
        return [[NSAttributedString alloc] initWithString:@"快去发布作品吧" attributes:attribult];
    }
    
}




@end
