//
//  cilinViewController.m
//  ShengShengManB
//
//  Created by mibo02 on 17/5/9.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "cilinViewController.h"
#import "newshiciCell.h"
#import "toneModel.h"
@interface cilinViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong)NSMutableArray *arr;
@property (nonatomic, strong)UITextField *textF;
@property (nonatomic, strong)UILabel *titlelab;
@end

@implementation cilinViewController
- (NSMutableArray *)arr
{
    if (!_arr) {
        self.arr = [NSMutableArray new];
    }
    return _arr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
   
    
    for (NSDictionary *dic in self.newdic[@"parts"]) {
        toneModel *model = [toneModel new];
        [model setValuesForKeysWithDictionary:dic];
        [self.arr addObject:model];
    }
    self.navigationItem.rightBarButtonItem  = [UIBarButtonItem CreateItemWithTarget:self ForAction:@selector(searchaction) WithImage:@"search_icon_white-1" WithHighlightImage:nil];
    [self.tableview registerNib:[UINib nibWithNibName:@"newshiciCell" bundle:nil] forCellReuseIdentifier:@"newcell"];
    
    self.navigationItem.rightBarButtonItem  = [UIBarButtonItem CreateItemWithTarget:self ForAction:@selector(searchaction) WithImage:@"search_icon_white-1" WithHighlightImage:nil];
    
    
    [self createfield];
    
}
- (void)createfield
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
    self.titlelab.text = @"词林正韵";
}
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
    NSString *str;
    for (toneModel *model in self.arr) {
        for (subtoneModel *newmodel in model.tonesarr) {
            if ([newmodel.font containsString:textField.text]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:model.name message:[NSString stringWithFormat:@"你所找的字'%@',在'%@'中的'%@'内",textField.text,model.name,newmodel.name] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                str = [str stringByAppendingString:newmodel.font];
            }
        }
    }
    if (![str containsString:textField.text]) {
        [MBProgressHUD showError:@"未查找到相关内容"];
    }
    return YES;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *bewarr = [self.arr[section] tonesarr];
    return bewarr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    newshiciCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newcell" forIndexPath:indexPath];
    NSArray *subarr = [self.arr[indexPath.section] tonesarr];
    subtoneModel *submodel = subarr[indexPath.row];
    cell.firstLab.text = submodel.name;
    
    if (submodel.isopen) {
       cell.detailLab.text = submodel.font;
    } else {
        cell.detailLab.text = @"";
    }
    
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.arr[section] name];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *subarr = [self.arr[indexPath.section] tonesarr];
    subtoneModel *submodel = subarr[indexPath.row];
    
    if (submodel.font.length != 0) {
        NSDictionary*fontDt = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName,nil];
        CGRect rect = [submodel.font boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 40, 0) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:fontDt context:nil];
        if (submodel.isopen) {
            return 45 + rect.size.height + 25;
        } else {
            return 45;
        }
    } else {
        return 45;
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *subarr = [self.arr[indexPath.section] tonesarr];
    subtoneModel *submodel = subarr[indexPath.row];
    submodel.isopen = !submodel.isopen;
    [self.tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:(UITableViewRowAnimationFade)];
}
@end
