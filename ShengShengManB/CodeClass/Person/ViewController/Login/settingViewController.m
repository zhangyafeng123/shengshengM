//
//  settingViewController.m
//  ShengShengManB
//
//  Created by mibo02 on 17/4/28.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "settingViewController.h"
#import "nickImageCell.h"
#import "shengriView.h"
#import "AddressPickerView.h"
#import "textfieldCell.h"
#import "DateTimePickerView.h"

@interface settingViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,AddressPickerViewDelegate>
@property (nonatomic ,strong) AddressPickerView * pickerView;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, copy)NSString *headstr;
@property (nonatomic, strong)shengriView *shengriV;
@end

@implementation settingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    
    [self.tableview registerNib:[UINib nibWithNibName:@"nickImageCell" bundle:nil] forCellReuseIdentifier:@"images"];
    [self.tableview registerNib:[UINib nibWithNibName:@"textfieldCell" bundle:nil] forCellReuseIdentifier:@"textfield"];
    self.shengriV = [[[NSBundle mainBundle] loadNibNamed:@"shengriView" owner:nil options:nil] firstObject];
    self.shengriV.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250);
    [self.view addSubview:self.shengriV];
    [self.shengriV.okbtn addTarget:self action:@selector(okbtnaction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.shengriV.cancelbtn addTarget:self action:@selector(cancelbtnaction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self setfooterview];
}
- (void)okbtnaction:(UIButton *)sender
{
    self.shengriV.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250);
    UITableViewCell *cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    dateFormatter.dateFormat=@"yyyy-MM-dd";
    cell.detailTextLabel.text = [dateFormatter stringFromDate:self.shengriV.datepicker.date];
}
- (void)cancelbtnaction:(UIButton *)sender
{
    self.shengriV.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250);
}
- (void)setfooterview
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(30, 30, SCREEN_WIDTH - 60, 40);
    [btn setTitle:@"完成" forState:(UIControlStateNormal)];
    btn.layer.cornerRadius = 4;
    btn.layer.masksToBounds  = YES;
    btn.backgroundColor = [UIColor blueColor];
    [btn addTarget:self action:@selector(footerbtnaction) forControlEvents:(UIControlEventTouchUpInside)];
    [view addSubview:btn];
    self.tableview.tableFooterView = view;
}
- (void)footerbtnaction
{
    [self request];
}
- (void)request
{
    if (self.headstr.length == 0) {
        self.headstr = self.setmodel.user_head;
    }
    textfieldCell *cellnick = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    if (cellnick.textf.text.length == 0) {
        [MBProgressHUD showError:@"请填写昵称"];
        return;
    }
    NSString *sexstr;
    UITableViewCell *cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    if ([cell.detailTextLabel.text isEqualToString:@"男"]) {
        sexstr = @"1";
    } else if ([cell.detailTextLabel.text isEqualToString:@"女"]){
        sexstr = @"0";
    } else {
//        [MBProgressHUD showError:@"请填写性别"];
//        return;
        sexstr = @"1";
    }
    //
     UITableViewCell *cell1 = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    if (cell1.detailTextLabel.text.length == 0) {
        cell1.detailTextLabel.text = @"";
    }
    //
    textfieldCell *cell4 = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    if (cell4.textf.text.length == 0) {
//        [MBProgressHUD showError:@"请填写邮箱"];
//        return;
        cell4.textf.text = @"";
    }
    //
    UITableViewCell *cell5 = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    if (cell5.detailTextLabel.text.length == 0) {
//        [MBProgressHUD showError:@"请选择地区"];
//        return;
        cell5.detailTextLabel.text = @"";
    }
    //
    textfieldCell *cell6 = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
    if (cell6.textf.text.length == 0) {
//        [MBProgressHUD showError:@"请填写签名"];
//        return;
        cell6.textf.text = @"";
    }
    NSLog(@"%@-----fengfeng",cell6.textf.text);
    
    [NetWorkManager requestForPostWithUrl:accountinfoURL parameter:@{@"token":[UserInfoManager getUserInfo].token,@"sex":sexstr,@"nick_name":cellnick.textf.text,@"email":cell4.textf.text,@"region":cell5.detailTextLabel.text,@"birthday":cell1.detailTextLabel.text,@"autograph":cell6.textf.text,@"portrait":self.headstr} success:^(id reponseObject) {
        [MBProgressHUD showError:reponseObject[@"msg"]];
        if ([reponseObject[@"code"] integerValue] == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        [mdfivetool checkinternationInfomation:error];
        [self hideProgressHUD];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}
- (void)updatebtnimageaction
{
   
    [[PhotoPickerManager sharedManager] getImageInView:self successBlock:^(UIImage *image) {
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setObject:[@"image" dataUsingEncoding:NSUTF8StringEncoding] forKey:@"files"];
        
        [NetWorkManager uploadPOST:updateImagesURL parameters:dic consImage:image success:^(id responObject) {
            [MBProgressHUD showError:responObject[@"msg"]];
            if ([responObject[@"code"] integerValue] == 1) {
                nickImageCell *cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                [cell.topimgV sd_setImageWithURL:[NSURL URLWithString:responObject[@"result"][@"successFiles"][0][@"url"]] forState:(UIControlStateNormal)];
                self.headstr = responObject[@"result"][@"successFiles"][0][@"url"];
                
            }
            
        } failure:^(NSError *error) {
            [mdfivetool checkinternationInfomation:error];
            [self hideProgressHUD];
        } progress:^(NSProgress *progress) {
            
        }];
    }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (indexPath.row == 0) {
        nickImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"images" forIndexPath:indexPath];
        if (self.setmodel.user_head.length != 0) {
            [cell.topimgV sd_setImageWithURL:[NSURL URLWithString:self.setmodel.user_head] forState:(UIControlStateNormal)];
        }
        [cell.topimgV addTarget:self action:@selector(updatebtnimageaction) forControlEvents:(UIControlEventTouchUpInside)];
        return cell;
    } else if (indexPath.row == 1){
        textfieldCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"textfield" forIndexPath:indexPath];
        cell.leftlab.text = @"昵称";
        if (self.setmodel.nick_name.length != 0) {
            cell.textf.text = self.setmodel.nick_name;
        }
        return cell;
    } else if (indexPath.row == 2 || indexPath.row == 3){
        static NSString *str = @"fengfeng";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:str];
        }
        if (indexPath.row == 2) {
           cell.textLabel.text = @"性别";
            if ([self.setmodel.sex isEqualToString:@"1"]) {
                cell.detailTextLabel.text = @"男";
            } else if ([self.setmodel.sex isEqualToString:@"0"]){
                cell.detailTextLabel.text = @"女";
            } else {
                cell.detailTextLabel.text = @"未设置";
            }
        } else {
            cell.textLabel.text = @"生日";
            if (self.setmodel.birthday.length != 0) {
                cell.detailTextLabel.text = self.setmodel.birthday;
            } else {
                cell.detailTextLabel.text = @"未设置";
            }
        }
        
        return cell;
    } else if (indexPath.row == 4) {
       textfieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textfield" forIndexPath:indexPath];
            cell.leftlab.text = @"邮箱";
            if (self.setmodel.email.length != 0) {
                cell.textf.text = self.setmodel.email;
            }
            return cell;
        
    } else if (indexPath.row == 5){
        static NSString *str = @"fengfeng";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:str];
        }
        cell.textLabel.text = @"地区";
        if (self.setmodel.region.length != 0) {
            cell.detailTextLabel.text = self.setmodel.region;
        }
        return cell;
    } else {
        textfieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textfield" forIndexPath:indexPath];
        cell.leftlab.text = @"签名";
        if (self.setmodel.autograph.length != 0) {
            cell.textf.text = self.setmodel.autograph;
        }
        return cell;
    }
    
 
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 100;
    }else {
        return 45;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"选择" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"男",@"女", nil];
        [alert show];
    } else if (indexPath.row == 3){
        self.shengriV.frame = CGRectMake(0, SCREEN_HEIGHT - 250, SCREEN_WIDTH, 250);
    } else if (indexPath.row == 5){
        [self.pickerView show];
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITableViewCell *cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    if (buttonIndex == 1) {
        cell.detailTextLabel.text = @"男";
    } else if (buttonIndex == 2){
        cell.detailTextLabel.text = @"女";
    }
    
}
- (AddressPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[AddressPickerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, SCREEN_WIDTH, 300)];
        _pickerView.delegate = self;
        [self.view addSubview:self.pickerView];
    }
    return _pickerView;
}
#pragma mark - AddressPickerViewDelegate
- (void)cancelBtnClick{
   
   [self.pickerView hide];
}
- (void)sureBtnClickReturnProvince:(NSString *)province City:(NSString *)city Area:(NSString *)area{
    UITableViewCell *cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@%@",province,city,area];
    [self.pickerView hide];
}
@end
