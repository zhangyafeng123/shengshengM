//
//  zhishibaoViewController.m
//  ShengShengManB
//
//  Created by mibo02 on 17/4/27.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "zhishibaoViewController.h"
#import "dashangnewmodel.h"
#import "dashangnewCell.h"
#import "WXApi.h"
@interface zhishibaoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong)NSMutableArray *dataArray;
@end

@implementation zhishibaoViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray= [NSMutableArray new];
    }
    return _dataArray;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
     [self request];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"知识包列表";
    [self.tableview registerNib:[UINib nibWithNibName:@"dashangnewCell" bundle:nil] forCellReuseIdentifier:@"dashangnew"];
   
}
- (void)request
{
    [self showProgressHUD];
    [NetWorkManager requestForPostWithUrl:[NSString stringWithFormat:@"%@?token=%@",knowledgesURL,[UserInfoManager getUserInfo].token] parameter:@{} success:^(id reponseObject) {
        if ([reponseObject[@"code"] integerValue] == 1) {
            self.dataArray = [dashangnewmodel mj_objectArrayWithKeyValuesArray:reponseObject[@"result"]];
        }
        
        [self.tableview reloadData];
        [self hideProgressHUD];
    } failure:^(NSError *error) {
        [mdfivetool checkinternationInfomation:error];
        [self hideProgressHUD];
    }];
    
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
    dashangnewCell *cell  =[tableView dequeueReusableCellWithIdentifier:@"dashangnew" forIndexPath:indexPath];
    dashangnewmodel *model = self.dataArray[indexPath.row];
    cell.dashangtitle.text = model.title;
    cell.moneylab.text = [NSString stringWithFormat:@"%.2f",model.money];
    cell.contentlab.text = model.outline;
    cell.downloadbtn.tag = 150 + indexPath.row;
    
    if (model.possess) {
        [cell.downloadbtn setTitle:@"下载" forState:(UIControlStateNormal)];
    } else {
        [cell.downloadbtn setTitle:@"支付" forState:(UIControlStateNormal)];
    }
    
    [cell.downloadbtn addTarget:self action:@selector(action:) forControlEvents:(UIControlEventTouchUpInside)];
    return cell;
}
- (void)action:(UIButton *)sender
{
     dashangnewmodel *model = self.dataArray[sender.tag - 150];
    if ([sender.titleLabel.text isEqualToString:@"支付"]) {
        [NetWorkManager requestForPostWithUrl:buypackageURL parameter:@{@"token":[UserInfoManager getUserInfo].token,@"kpid":model.id} success:^(id reponseObject) {
            
            [MBProgressHUD showError:reponseObject[@"msg"]];
            
            if ([reponseObject[@"code"] integerValue] == 1) {
                PayReq *req = [[PayReq alloc] init];
                req.openID = reponseObject[@"result"][@"appid"];
                // 商家id，在注册的时候给的
                req.partnerId = reponseObject[@"result"][@"partnerid"];
                // 预支付订单这个是后台跟微信服务器交互后，微信服务器传给你们服务器的，你们服务器再传给你
                req.prepayId  = reponseObject[@"result"][@"prepayid"];
                // 根据财付通文档填写的数据和签名
                //这个比较特殊，是固定的，只能是即req.package = Sign=WXPay
                req.package =reponseObject[@"result"][@"package"];
                // 随机编码，为了防止重复的，在后台生成
                req.nonceStr = reponseObject[@"result"][@"noncestr"];
                // 这个是时间戳，也是在后台生成的，为了验证支付的
                
                UInt32 timeStamp =[reponseObject[@"result"][@"timestamp"] intValue];
                req.timeStamp= timeStamp;
                
                req.sign = [reponseObject[@"result"][@"sign"] lowercaseString];
                
                //发送请求到微信，等待微信返回onResp
                [WXApi sendReq:req];
            }
            
        } failure:^(NSError *error) {
            [mdfivetool checkinternationInfomation:error];
            [self hideProgressHUD];
        }];
    } else {
       
        //请求知识包下载
        [NetWorkManager requestForPostWithUrl:downloadkpURL parameter:@{@"token":[UserInfoManager getUserInfo].token,@"kpid":model.id} success:^(id reponseObject) {
            if ([reponseObject[@"code"] integerValue] == 1) {
                
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
    return 100;
}
- (nullable NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    UIFont *font = [UIFont systemFontOfSize:15];
    UIColor *color = [UIColor blackColor];
    NSMutableDictionary *attribult = [NSMutableDictionary new];
    [attribult setObject:font forKey:NSFontAttributeName];
    [attribult setObject:color forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:@"没有可下载的知识包" attributes:attribult];
}

@end
