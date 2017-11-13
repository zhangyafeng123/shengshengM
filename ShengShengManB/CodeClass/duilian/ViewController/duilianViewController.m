//
//  duilianViewController.m
//  ShengShengManB
//
//  Created by mibo02 on 17/4/28.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "duilianViewController.h"
#import "duilianCell.h"
#import "duilianListViewController.h"
#import "duilianView.h"
#import "chuduilianViewController.h"
#import "duilianModel.h"
@interface duilianViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, assign)NSInteger pages;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)UIView *backV;
@property (nonatomic, strong)duilianView *duilianV;
@end

@implementation duilianViewController
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.dataArray removeAllObjects];
     self.pages = 1;
    [self request];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"出联应对";
   
    [self.tableview registerNib:[UINib nibWithNibName:@"duilianCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem initWithTitle:@"出对联" titleColor:[UIColor whiteColor] target:self action:@selector(action)];
   
}
- (void)action
{
    chuduilianViewController *chuangjian = [chuduilianViewController new];
    [self.navigationController pushViewController:chuangjian animated:YES];
}
- (void)request
{
    [self showProgressHUD];
    [NetWorkManager requestForGetWithUrl:[NSString stringWithFormat:@"%@?page_no=%ld",cupletinfoURL,self.pages] parameter:@{} success:^(id reponseObject) {
        if ([reponseObject[@"code"] integerValue] == 1) {
            for (NSDictionary *dic in reponseObject[@"result"][@"list"]) {
                duilianModel *model = [duilianModel new];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
            }
           
        }
        [self hideProgressHUD];
        [self.tableview reloadData];
        [self refreshfooternew:[reponseObject[@"result"][@"totalPage"] integerValue]];
    } failure:^(NSError *error) {
        [mdfivetool checkinternationInfomation:error];
        [self hideProgressHUD];
    }];
}
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    duilianCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    duilianModel *model = self.dataArray[indexPath.row];
    
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:model.user_head] placeholderImage:[UIImage imageNamed:@"wdl"]];

    NSString *str1 = [TodayDate getgradefor:model.grade];
    
    if (model.nick_name) {
        cell.nickLab.attributedText = [ZLabel attributedTextArray:@[model.nick_name,str1] textColors:@[[UIColor blueColor],[UIColor blackColor]] textfonts:@[H15,H11]];
    }
    NSString *str = [NSString stringWithFormat:@"%@\n注释：",model.shanglian];
    if (model.annotation.length == 0) {
        cell.contentLab.text = model.shanglian;
    } else {
        cell.contentLab.attributedText = [ZLabel attributedTextArray:@[str,model.annotation] textColors:@[[UIColor blackColor],[UIColor grayColor]] textfonts:@[H16,H14]];
    }
    NSString *timestr = [getTimes compareCurrentTime:model.create_time];
    cell.timeLab.text = timestr;
    cell.addbtn.layer.borderWidth = 0.5;
    cell.addbtn.layer.borderColor = [UIColor blueColor].CGColor;
    cell.addbtn.tag = indexPath.row + 160;
    [cell.addbtn addTarget:self action:@selector(btnaction:) forControlEvents:(UIControlEventTouchUpInside)];
    return cell;
}


- (void)btnaction:(UIButton *)sender
{
    
    UIWindow *window = [UIApplication sharedApplication].windows[0];
    _backV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _backV.backgroundColor =  RGBA(108, 108, 108,0.7);
    
    [window addSubview:_backV];
    _duilianV = [[[NSBundle mainBundle] loadNibNamed:@"duilianView" owner:nil options:nil] firstObject];
    [_duilianV.textV becomeFirstResponder];
    _duilianV.tag = sender.tag;
    [_backV addSubview:_duilianV];
    _duilianV.frame = CGRectMake((SCREEN_WIDTH - 300) / 2, 100, 300, 200);
    _duilianV.cancelbtn.layer.borderColor = [UIColor blueColor].CGColor;
    _duilianV.cancelbtn.layer.borderWidth = 0.5;
    _duilianV.okbtn.layer.borderColor = [UIColor redColor].CGColor;
    _duilianV.okbtn.layer.borderWidth = 0.5;
    [_duilianV.okbtn addTarget:self action:@selector(okbuttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [_duilianV.cancelbtn addTarget:self action:@selector(cancelbtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
   
}
- (void)okbuttonAction:(UIButton *)sender
{
    NSString *str;
    
    if (_duilianV.textF.text.length == 0) {
        str = @"";
    } else {
        str = _duilianV.textF.text;
    }
    if (_duilianV.textV.text.length == 0) {
        [MBProgressHUD showError:@"请输入下联"];
        return;
    }
    
     duilianModel *model = _dataArray[_duilianV.tag - 160];
    //点击事件
    [NetWorkManager requestForPostWithUrl:answerURL parameter:@{@"token":[UserInfoManager getUserInfo].token,@"shanglian_no":model.id,@"xialian":_duilianV.textV.text,@"annotation":str} success:^(id reponseObject) {
        [MBProgressHUD showError:reponseObject[@"msg"]];
        if ([reponseObject[@"code"] integerValue] == 1) {
             [_backV removeFromSuperview];
            [MBProgressHUD showError:reponseObject[@"msg"]];
            [self.tableview reloadData];
        }
    } failure:^(NSError *error) {
        [mdfivetool checkinternationInfomation:error];
        [self hideProgressHUD];
    }];
}
- (void)cancelbtnAction:(UIButton *)sender
{
     [_backV removeFromSuperview];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    duilianModel *model = self.dataArray[indexPath.row];
    NSDictionary*fontDt = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName,nil];
    
    NSString *str;
    if (model.annotation.length == 0) {
        str = model.shanglian;
    } else {
        str = [NSString stringWithFormat:@"%@\n注释：%@",model.shanglian,model.annotation];
    }
    CGRect rect = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, 0) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:fontDt context:nil];
    
    return 90 + rect.size.height;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    duilianListViewController *list = [duilianListViewController new];
    list.newid = [self.dataArray[indexPath.row] id];
    [self.navigationController pushViewController:list animated:YES];
}

- (nullable NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    UIFont *font = [UIFont systemFontOfSize:17];
    UIColor *color = [UIColor blackColor];
    NSMutableDictionary *attribult = [NSMutableDictionary new];
    [attribult setObject:font forKey:NSFontAttributeName];
    [attribult setObject:color forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:@"快去发布对联吧!" attributes:attribult];
}

@end
