//
//  dashangViewController.m
//  ShengShengManB
//
//  Created by mibo02 on 17/4/27.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "dashangViewController.h"
#import "dashangmodel.h"
#import "dashangCell.h"
#import "WXApi.h"
#import "XMLDictionary.h"
#import "mdfivetool.h"
@interface dashangViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, assign)NSInteger pages;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)NSMutableArray *items;
@end

@implementation dashangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"打赏本软件";
    [self.tableview registerNib:[UINib nibWithNibName:@"dashangCell" bundle:nil] forCellReuseIdentifier:@"dashang"];
    self.pages = 1;
    [self request];
}
- (void)request
{
    [NetWorkManager requestForGetWithUrl:[NSString stringWithFormat:@"%@?page_no=%ld",danationURL,(long)self.pages] parameter:@{} success:^(id reponseObject) {
        if ([reponseObject[@"code"] integerValue] == 1) {
            self.dataArray = [dashangmodel mj_objectArrayWithKeyValuesArray:reponseObject[@"result"]];
        }
        [self.tableview reloadData];
    } failure:^(NSError *error) {
        [mdfivetool checkinternationInfomation:error];
        [self hideProgressHUD];
    }];
}

- (IBAction)dashangbtn:(UIButton *)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"打赏本软件" message:@"" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertaction1 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *alertaction2 = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textf = alert.textFields.firstObject;
        //[weakSelf payaction:textf.text];
        
        [weakSelf loadData:textf.text];
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
       textField.placeholder = @"请输入数字金额";
    }];
    [alert addAction:alertaction2];
    [alert addAction:alertaction1];
    [self presentViewController:alert animated:YES completion:nil];
    
   
}
//判断是不是数字
- (BOOL)isNum:(NSString *)checkedNumString {
    checkedNumString = [checkedNumString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(checkedNumString.length > 0) {
        return NO;
    }
    return YES;
}

- (void)loadData:(NSString *)text
{
    BOOL isnum = [self isNum:text];
    if (isnum) {
    [NetWorkManager requestForPostWithUrl:stationdonateURL parameter:@{@"token":[UserInfoManager getUserInfo].token,@"money":text} success:^(id reponseObject) {
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
        [MBProgressHUD showError:@"请输入数字金额"];
    }
   
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    dashangCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dashang" forIndexPath:indexPath];
    dashangmodel *model = self.dataArray[indexPath.row];
    if ([model.userHead hasPrefix:@"http"]) {
         [cell.img sd_setImageWithURL:[NSURL URLWithString:model.userHead]];
    } else {
         [cell.img sd_setImageWithURL:[NSURL URLWithString:ImageViewURL(model.userHead)]];
    }
    cell.nicklab.text = model.nickName;
    cell.moneylab.text = [NSString stringWithFormat:@"已打赏%.2f元",model.money];
    cell.timelab.text = model.time;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (nullable NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    UIFont *font = [UIFont systemFontOfSize:15];
    UIColor *color = [UIColor blackColor];
    NSMutableDictionary *attribult = [NSMutableDictionary new];
    [attribult setObject:font forKey:NSFontAttributeName];
    [attribult setObject:color forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:@"快来打赏吧!" attributes:attribult];
}
@end
