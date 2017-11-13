//
//  ciViewController.m
//  ShengShengManB
//
//  Created by mibo02 on 17/5/9.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "ciViewController.h"
#import "cisecondViewController.h"

#import "ChineseString.h"
@interface ciViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
//排序后的出现过的拼音首字母数组
@property(nonatomic,strong)NSMutableArray *indexArray;
//排序好的结果数组
@property(nonatomic,strong)NSMutableArray *LetterResultArr;
@end

@implementation ciViewController
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray =[NSMutableArray new];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"词";
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem initWithnewTitle:@"钦定词谱" titleColor:[UIColor whiteColor] target:self action:@selector(action)];
    [self request];
}
- (void)action
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.wrjh.net/qdcp/index.htm"]];
}
-(void)request
{
    NSMutableArray *newarr = [NSMutableArray new];
    [NetWorkManager requestForGetWithUrl:wordinfoURL parameter:@{} success:^(id reponseObject) {
        if ([reponseObject[@"code"] integerValue] == 1) {
            for (NSDictionary *dic in reponseObject[@"result"]) {
                [self.dataArray addObject:dic];
                [newarr addObject:dic[@"name"]];
            }
        }
        self.indexArray = [ChineseString IndexArray:newarr];
        self.LetterResultArr = [ChineseString LetterSortArray:newarr];
        [self.tableview reloadData];
    } failure:^(NSError *error) {
        [mdfivetool checkinternationInfomation:error];
        [self hideProgressHUD];
    }];
}
#pragma mark -Section的Header的值
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *key = [self.indexArray objectAtIndex:section];
    return key;
}
#pragma mark - Section header view
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 20)];
    lab.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    lab.text = [self.indexArray objectAtIndex:section];
    lab.textColor = [UIColor grayColor];
    return lab;
}
#pragma mark - row height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.indexArray;
}
#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.indexArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.LetterResultArr objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [[self.LetterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *names = [[self.LetterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    NSDictionary *dic = [self completeforarr:names];
    cisecondViewController *ci = [cisecondViewController new];
    ci.arr = dic[@"tuneRhymes"];
    ci.str = dic[@"name"];
    ci.headid = dic[@"id"];
    [self.navigationController pushViewController:ci animated:YES];
}

- (NSDictionary *)completeforarr:(NSString *)str
{
    NSDictionary *newdic;
    for (NSDictionary *dic in self.dataArray) {
        if ([dic[@"name"] isEqualToString:str]) {
            newdic = dic;
        }
    }
    return newdic;
}

@end
