//
//  jiebancreateViewController.m
//  ShengShengManB
//
//  Created by mibo02 on 17/4/26.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "jiebancreateViewController.h"
#import "createCell.h"
#import "createtwoCell.h"
#import "createthreeCell.h"
#import "shengriView.h"
#import "DateTimePickerView.h"
@interface jiebancreateViewController ()<UITableViewDelegate,UITableViewDataSource,DateTimePickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong)NSMutableArray *ImgArray;

@property (nonatomic, strong) DateTimePickerView *datePickerView;
@end

@implementation jiebancreateViewController
- (NSMutableArray *)ImgArray
{
    if (!_ImgArray) {
        self.ImgArray = [NSMutableArray new];
    }
    return _ImgArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布活动";
    [self.tableview registerNib:[UINib nibWithNibName:@"createCell" bundle:nil] forCellReuseIdentifier:@"create"];
    [self.tableview registerNib:[UINib nibWithNibName:@"createtwoCell" bundle:nil] forCellReuseIdentifier:@"createtwo"];
    [self.tableview registerNib:[UINib nibWithNibName:@"createthreeCell" bundle:nil] forCellReuseIdentifier:@"threecreate"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem initWithTitle:@"发起" titleColor:[UIColor whiteColor] target:self action:@selector(action)];
   
}
- (void)action
{
     [self request];
}

- (void)request
{
    createCell *cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    createtwoCell *cell1 = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    createtwoCell *cell2 = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    createCell *cell3 = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    createCell *cell5 = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
     createCell *cell6 = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
    createCell *cell7 = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0]];
    UITableViewCell *cell8 = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0]];
    UITableViewCell *cell9 = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0]];
    UITableViewCell *cell10 = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:10 inSection:0]];
    
    
    if (cell.textF.text.length == 0) {
        [MBProgressHUD showError:@"请填写活动标题"];
        return;
    }
    if (cell1.textV.text.length == 0) {
        [MBProgressHUD showError:@"请填写活动内容"];
        return;
    }
    if (cell2.textV.text.length == 0) {
        [MBProgressHUD showError:@"请填写活动要求"];
        return;
    }
    if (cell3.textF.text.length == 0) {
        [MBProgressHUD showError:@"请填写活动地址"];
        return;
    }
    if (cell5.textF.text.length == 0) {
        [MBProgressHUD showError:@"请填写人数上限"];
        return;
    }
    if (cell6.textF.text.length == 0) {
        [MBProgressHUD showError:@"请填写手机号码"];
        return;
    }
    if (cell7.textF.text.length == 0) {
        [MBProgressHUD showError:@"请填写每人预算"];
        return;
    }
    if (cell8.detailTextLabel.text.length == 0) {
        [MBProgressHUD showError:@"请选择报名截止时间"];
        return;
    }
    if (cell9.detailTextLabel.text.length == 0) {
        [MBProgressHUD showError:@"请选择活动开始时间"];
        return;
    }
    if (cell10.detailTextLabel.text.length == 0) {
        [MBProgressHUD showError:@"请选择活动结束时间"];
        return;
    }
    if (self.ImgArray.count == 0) {
        [MBProgressHUD showError:@"请上传活动图片"];
        return;
    }
    NSString *imgstr = [self.ImgArray componentsJoinedByString:@"|"];
    
    NSString *newstr = [NSString stringWithFormat:@"|%@",imgstr];
    
    NSDictionary *dic = @{@"token":[UserInfoManager getUserInfo].token,@"title":cell.textF.text,@"content":cell1.textV.text,@"picture":newstr,@"demand":cell2.textV.text,@"address":cell3.textF.text,@"max_people_number":@(cell5.textF.text.integerValue),@"contact_phone":cell6.textF.text,@"budget_money":cell7.textF.text,@"signup_end_time":cell8.detailTextLabel.text,@"activity_sta_time":cell9.detailTextLabel.text,@"activity_end_time":cell10.detailTextLabel.text};
  
    [NetWorkManager requestForPostWithUrl:addURL parameter:dic success:^(id reponseObject) {
        
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
    return 11;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1 || indexPath.row == 2) {
        createtwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"createtwo" forIndexPath:indexPath];
        if (indexPath.row == 1) {
            cell.tleftlab.text = @"活动内容:";
        } else {
            cell.tleftlab.text = @"活动要求:";
        }
        cell.textV.tag = indexPath.row + 150;
        return cell;
    } else if (indexPath.row == 4){
        createthreeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"threecreate" forIndexPath:indexPath];
        [cell.btn addTarget:self action:@selector(btnactionforImg:) forControlEvents:(UIControlEventTouchUpInside)];
        return cell;
    } else if (indexPath.row == 8 || indexPath.row == 9 || indexPath.row == 10){
        static NSString *str = @"fengfeng";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:str];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = H15;
        if (indexPath.row == 8) {
            cell.textLabel.text = @"报名截止时间:";
            
        }else if (indexPath.row == 9){
            cell.textLabel.text = @"活动开始时间";
        } else {
            cell.textLabel.text = @"活动结束时间:";
        }
        return cell;
    } else {
        createCell *cell = [tableView dequeueReusableCellWithIdentifier:@"create" forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.leftlab.text =@"活动标题:";
            cell.textF.placeholder = @"请输入活动标题";
        } else if (indexPath.row == 3){
            cell.leftlab.text = @"活动地址:";
            cell.textF.placeholder = @"请输入活动地址";
        } else if (indexPath.row == 5){
            cell.leftlab.text = @"人数上限:";
            cell.textF.placeholder = @"请输入数字";
        } else if (indexPath.row == 6){
            cell.leftlab.text = @"联系号码:";
            cell.textF.placeholder = @"请输入手机号码";
        } else if (indexPath.row == 7){
            cell.leftlab.text = @"每人预算:";
            cell.textF.placeholder = @"请输入每人预算";
        }
        cell.textF.tag = indexPath.row + 120;
        return cell;
    }



}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > 7) {
        //创建生日视图
        self.datePickerView = [[DateTimePickerView alloc] init];
        
        self.datePickerView.delegate = self;
        self.datePickerView.pickerViewMode = DatePickerViewDateTimeMode;
        [self.view addSubview:self.datePickerView];
        [self.datePickerView showDateTimePickerView];
        if (indexPath.row == 8) {
            self.datePickerView.tag = 180;
        } else if(indexPath.row == 9){
            self.datePickerView.tag = 181;
        } else {
            self.datePickerView.tag  = 182;
        }
    }
   
}
/**
 * 确定按钮
 */
-(void)didClickFinishDateTimePickerView:(NSString*)date datepick:(UIView *)selfview
{
    UITableViewCell *cell8 = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0]];
    UITableViewCell *cell9 = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0]];
    UITableViewCell *cell10 = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:10 inSection:0]];
    if (selfview.tag == 180) {
        cell8.detailTextLabel.text = [NSString stringWithFormat:@"%@:00",date];
    } else if (selfview.tag == 181){
        cell9.detailTextLabel.text = [NSString stringWithFormat:@"%@:00",date];
    } else {
        cell10.detailTextLabel.text = [NSString stringWithFormat:@"%@:00",date];
    }
    
}
- (void)btnactionforImg:(UIButton *)sender
{
    //调用相册
    [[PhotoPickerManager sharedManager] getImagesInView:self maxCount:3 successBlock:^(NSMutableArray<UIImage *> *images) {
       //上传图片请求
        __weak __typeof__(self) weakSelf = self;
        [weakSelf requestForArr:images];
        
    }];
   
}
- (void)requestForArr:(NSMutableArray *)arr
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    for (int i = 0; i < arr.count; i++) {
        
        [dic setObject:[[NSString stringWithFormat:@"image%d",i] dataUsingEncoding:NSUTF8StringEncoding] forKey:[NSString stringWithFormat:@"files%d",i]];
        
    }
    
    createthreeCell *cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    
    [self.ImgArray removeAllObjects];
    [NetWorkManager uploadPOST:updateImagesURL parameters:dic consImages:arr success:^(id responObject) {
        
        if ([responObject[@"code"] integerValue] == 1) {
            NSArray *arr = responObject[@"result"][@"successFiles"];
            
            if ([arr count] == 1) {
            NSString *str1  =  [arr[0][@"url"] stringByReplacingOccurrencesOfString:@"\\" withString:@""];
               
                [cell.firstImg sd_setImageWithURL:[NSURL URLWithString:str1]];
            } else if (arr.count == 2){
                NSString *str1  =  [arr[0][@"url"] stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                NSString *str2  =  [arr[1][@"url"] stringByReplacingOccurrencesOfString:@"\\" withString:@""];
               
                [cell.firstImg sd_setImageWithURL:[NSURL URLWithString:str1]];
                [cell.centerImg sd_setImageWithURL:[NSURL URLWithString:str2]];
                
            } else {
                NSString *str1  =  [arr[0][@"url"] stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                NSString *str2  =  [arr[1][@"url"] stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                NSString *str3  =  [arr[2][@"url"] stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                NSLog(@"--------%@",str1);
                [cell.firstImg sd_setImageWithURL:[NSURL URLWithString:str1]];
                [cell.centerImg sd_setImageWithURL:[NSURL URLWithString:str2]];
                 [cell.rightImg sd_setImageWithURL:[NSURL URLWithString:str3]];
            }
            
            for (NSDictionary *newdic in responObject[@"result"][@"successFiles"]) {
                 NSString *str1  =  [newdic[@"url"] stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                [self.ImgArray addObject:str1];
            }
            
        }
        
    } failure:^(NSError *error) {
        [mdfivetool checkinternationInfomation:error];
        [self hideProgressHUD];
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1 || indexPath.row == 2) {
        return 80;
    } else if (indexPath.row == 4){
        return 120;
    } else {
        return 44;
    }
}



@end
