//
//  shidetailViewController.m
//  ShengShengManB
//
//  Created by mibo02 on 17/5/9.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "shidetailViewController.h"
#import "CiTableViewCell.h"
#import "TodayDate.h"
#import "TopView.h"
#import "BottomView.h"
#import "webViewController.h"
#import "pingshuiViewController.h"
#import "cilinViewController.h"
#import "zhonghuaViewController.h"

@interface shidetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong)BottomView *bottomView;
@property (nonatomic, strong)TopView *topView;
@property (nonatomic, strong)UIButton *btn;
//对应韵书中的字体
@property (nonatomic, strong)NSMutableArray *fontArray;
//输入的字体数组
@property (nonatomic, strong)NSMutableArray *textfArray;
//每一句符号的数组
@property (nonatomic, strong)NSMutableArray *fuhaoArray;
//图片数组
@property (nonatomic, strong)NSMutableArray *imgArray;

@property (nonatomic, strong)NSMutableArray *allfuhaoArr;

//textFieldArr
@property (nonatomic, strong)NSMutableArray *textFieldArray;

@property (nonatomic, strong)NSMutableArray *errorArray;

//创建一个textfield中的text
@property (nonatomic, strong)NSMutableArray *textFarray;

@end

@implementation shidetailViewController
- (NSMutableArray *)textFarray
{
    if (!_textFarray) {
        self.textFarray = [NSMutableArray new];
    }
    return _textFarray;
}
- (NSMutableArray *)errorArray
{
    if (!_errorArray) {
        self.errorArray = [NSMutableArray new];
    }
    return _errorArray;
}
- (NSMutableArray *)textFieldArray
{
    if (!_textFieldArray) {
        self.textFieldArray = [NSMutableArray new];
    }
    return _textFieldArray;
}
- (NSMutableArray *)allfuhaoArr
{
    if (!_allfuhaoArr) {
        self.allfuhaoArr = [NSMutableArray new];
    }
    return _allfuhaoArr;
}
- (NSMutableArray *)fuhaoArray
{
    if (!_fuhaoArray) {
        self.fuhaoArray = [NSMutableArray new];
    }
    return _fuhaoArray;
}
- (NSMutableArray *)imgArray
{
    if (!_imgArray) {
        self.imgArray = [NSMutableArray new];
    }
    return _imgArray;
}
- (NSMutableArray *)textfArray
{
    if (!_textfArray) {
        self.textfArray = [NSMutableArray new];
    }
    return _textfArray;
}
- (NSMutableArray *)fontArray
{
    if (!_fontArray) {
        self.fontArray = [NSMutableArray new];
    }
    return _fontArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.yunshustr;
    self.navigationController.navigationBar.translucent = NO;
    
    [self.tableview registerNib:[UINib nibWithNibName:@"CiTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem CreateItemWithTarget:self ForAction:@selector(rightBarButtonItemaction) WithImage:@"三个点" WithHighlightImage:@""];
    [self requestshengdiao];
    [self createheaderV];
    //将韵书中的放到数组中
    NSMutableArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"search"];
    
    for (NSDictionary *dic in arr) {
        if ([dic[@"name"] isEqualToString:self.yunshustr]) {
            self.yunid = dic[@"id"];
            for (NSDictionary *newdic in dic[@"parts"]) {
                for (NSDictionary *fontdic in newdic[@"tones"]) {
                    //韵书中的——id
                    [self.fontArray addObject:fontdic];
                    
                }
            }
        }
    }
    //进行编辑是所显示的文字
    if (self.body.length != 0) {
     NSArray *bodyarr = [self.body componentsSeparatedByString:@"\n"];
        
        for (int i = 3; i < self.newarr.count + 3; i++) {
            if (i < bodyarr.count) {
                [self.textFarray addObject:bodyarr[i]];
            } else {
                [self.textFarray addObject:@""];
            }
        }
    } else {
        for (int i = 0; i < self.newarr.count; i++) {
            [self.textFarray addObject:@""];
        }
    }
    
}
- (void)requestshengdiao
{
    [NetWorkManager requestForGetWithUrl:toneinfoURL parameter:@{} success:^(id reponseObject) {
        
        for (NSDictionary *dic in reponseObject[@"result"]) {
            [self.allfuhaoArr addObject:dic];
        }
        
    } failure:^(NSError *error) {
        [mdfivetool checkinternationInfomation:error];
        [self hideProgressHUD];
    }];
}
- (void)rightBarButtonItemaction
{
    
    NSArray *items = @[
                       [YCXMenuItem menuItem:@"选韵书"
                                       image:[UIImage imageNamed:@"书"]
                                         tag:98
                                    userInfo:@{@"title":@"Menu"}],
                       [YCXMenuItem menuItem:@"查韵书"
                                       image:[UIImage imageNamed:@"查"]
                                         tag:99
                                    userInfo:@{@"title":@"Menu"}],
                       [YCXMenuItem menuItem:@"汉典"
                                       image:[UIImage imageNamed:@"字典"]
                                         tag:99
                                    userInfo:@{@"title":@"Menu"}],
                       [YCXMenuItem menuItem:@"保存"
                                       image:[UIImage imageNamed:@"保存"]
                                         tag:99
                                    userInfo:@{@"title":@"Menu"}],
                       [YCXMenuItem menuItem:@"检查"
                                       image:[UIImage imageNamed:@"检查"]
                                         tag:100
                                    userInfo:@{@"title":@"Menu"}],
                       [YCXMenuItem menuItem:@"发表"
                                       image:[UIImage imageNamed:@"发布"]
                                         tag:102
                                    userInfo:@{@"title":@"Menu"}]
                       ];
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(SCREEN_WIDTH -  50, 0, 20, 2);
    [self.view addSubview:btn];
    [YCXMenu showMenuInView:self.view fromRect:btn.frame menuItems:items selected:^(NSInteger index, YCXMenuItem *item) {
        //进行请求http://www.zdic.net
        if (index == 0) {
            [self selectyunshu];
        } else if (index == 1) {
            [self searchyun];
        } else if(index == 2){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://m.zdic.net"]];
        } else if(index == 3){
           //保存
            [self save];
        } else if(index == 4){
             [self jianchaMethod];
            
        } else {
            [self faburequest];
        }
        
    }];
}
- (void)save
{
    NSMutableArray *editarr =[NSMutableArray new];
    if (self.topView.titleLab.text.length == 0) {
        self.topView.titleLab.text = @"";
    }
    if (self.topView.timeLab.text.length == 0) {
        self.topView.timeLab.text = @"";
    }
    if (self.topView.AuthorLab.text.length == 0) {
        self.topView.AuthorLab.text = @"";
    }
    
    [editarr addObject:self.topView.titleLab.text];
    [editarr addObject:[NSString stringWithFormat:@"%@/%@",self.topView.timeLab.text,self.topView.AuthorLab.text]];
    
    for (int i = 0; i < self.newarr.count; i++) {
        CiTableViewCell *cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (cell.textField.text.length != 0) {
           [editarr addObject:cell.textField.text];
        }
    }
    NSString *textvtext;
    if (self.bottomView.textView.text.length == 0) {
        textvtext =  @"";
    } else {
        textvtext = self.bottomView.textView.text;
    }
    NSString *imgstr;
    if (self.imgArray.count != 0) {
        imgstr = [self.imgArray componentsJoinedByString:@"|"];
    } else {
        imgstr = @"";
    }
    
    NSString *str = [editarr componentsJoinedByString:@"\n"];
    
    NSDictionary *editdic = @{@"token":[UserInfoManager getUserInfo].token,@"type":@"shi",@"head":self.headid,@"rhythm":self.rhythmid,@"yunyun":self.yunid,@"body":str,@"notes":textvtext,@"images":imgstr};
    
    [NetWorkManager requestForPostWithUrl:draftaddURL parameter:editdic success:^(id reponseObject) {
        
        if ([reponseObject[@"code"] integerValue] == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        [MBProgressHUD showError:reponseObject[@"msg"]];
        
    } failure:^(NSError *error) {
        [mdfivetool checkinternationInfomation:error];
        [self hideProgressHUD];
    }];
}
//查韵书
- (void)searchyun
{
    //将韵书中的放到数组中
    NSMutableArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"search"];
            if ([self.title isEqualToString:@"平水韵"]) {
                pingshuiViewController *pingshui =[pingshuiViewController new];
                pingshui.newdic  = arr[0];
                [self.navigationController pushViewController:pingshui animated:YES];
                
            } else if ([self.title isEqualToString:@"词林正韵"]){
                cilinViewController *ci = [cilinViewController new];
                ci.newdic = arr[1];
                [self.navigationController pushViewController:ci animated:YES];
                
            } else {
                zhonghuaViewController *zhong = [zhonghuaViewController new];
                zhong.newdic = arr[2];
                [self.navigationController pushViewController:zhong animated:YES];
            }
}
//选韵书
- (void)selectyunshu
{
    _btn.hidden = YES;
    //将韵书中的放到数组中
    NSMutableArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"search"];
    
    WeChatActionSheet *sheetv = [WeChatActionSheet showActionSheet:@"选韵书" buttonTitles:@[@"平水韵",@"词林正韵",@"中华新韵"]];
    [sheetv setFunction:^(WeChatActionSheet *actionSheet,NSInteger index)
     {
         _btn.hidden = NO;
         if (index == WECHATCANCELINDEX)
         {
         }
         else
         {
             if (index == 0) {
                 [self.fontArray removeAllObjects];
                 for (NSDictionary *dic in arr) {
                     if ([dic[@"name"] isEqualToString:@"平水韵"]) {
                         self.yunid = dic[@"id"];
                         for (NSDictionary *newdic in dic[@"parts"]) {
                             for (NSDictionary *fontdic in newdic[@"tones"]) {
                                 //韵书中的——id
                                 [self.fontArray addObject:fontdic];
                                 
                             }
                         }
                     }
                 }
                 self.title = @"平水韵";
                 
             } else if (index == 1){
                 [self.fontArray removeAllObjects];
                 for (NSDictionary *dic in arr) {
                     if ([dic[@"name"] isEqualToString:@"词林正韵"]) {
                         self.yunid = dic[@"id"];
                         for (NSDictionary *newdic in dic[@"parts"]) {
                             for (NSDictionary *fontdic in newdic[@"tones"]) {
                                 //韵书中的——id
                                 [self.fontArray addObject:fontdic];
                                 
                             }
                         }
                     }
                 }
                 self.title = @"词林正韵";
             } else {
                 [self.fontArray removeAllObjects];
                 for (NSDictionary *dic in arr) {
                     if ([dic[@"name"] isEqualToString:@"中华新韵"]) {
                         self.yunid = dic[@"id"];
                         for (NSDictionary *newdic in dic[@"parts"]) {
                             for (NSDictionary *fontdic in newdic[@"tones"]) {
                                 //韵书中的——id
                                 [self.fontArray addObject:fontdic];
                                 
                             }
                         }
                     }
                 }
                 self.title = @"中华新韵";
             }
         }
     }];
}
//检查
- (void)jianchaMethod
{
    [self.textFieldArray removeAllObjects];
    for (int i = 0; i < self.newarr.count; i++) {
        CiTableViewCell *cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
       
        if (cell.textField.text.length != 0) {
           [self.textFieldArray addObject:[NSString stringWithFormat:@"%@",cell.textField.text]];
        }
    }
    if (self.textFieldArray.count == self.newarr.count) {
        [MBProgressHUD showError:@"快去发布吧！"];
    } else {
        [MBProgressHUD showError:@"存在错误，请检查"];
    }
}
//发布请求
- (void)faburequest
{
    //每次点击发布要删除数组中的数据
    [self.textFieldArray removeAllObjects];
    
    NSString *str;
    if (self.imgArray.count != 0) {
        str = [self.imgArray componentsJoinedByString:@"|"];
    }
    
    for (int i = 0; i < self.newarr.count; i++) {
         CiTableViewCell *cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];

        [self.textFieldArray addObject:cell.textField.text];
        
        if (cell.textField.text.length == 0) {
            [MBProgressHUD showError:@"请修改错误"];
            return;
        }
    }
    NSString *textfstr = [self.textFieldArray componentsJoinedByString:@"\n"];
    NSString *contents;
    if (self.subjectstr.length != 0) {
        contents = [NSString stringWithFormat:@"%@\n%@\n%@/%@\n\n%@",self.subjectstr,self.topView.titleLab.text,self.topView.timeLab.text,self.topView.AuthorLab.text,textfstr];
    } else if (self.edittitle.length != 0){
        contents = [NSString stringWithFormat:@"【%@】%@\n%@/%@\n\n%@",self.edittitle,self.topView.titleLab.text,self.topView.timeLab.text,self.topView.AuthorLab.text,textfstr];
    }else {
        contents = [NSString stringWithFormat:@"【%@】%@\n%@/%@\n\n%@",self.titlestr,self.topView.titleLab.text,self.topView.timeLab.text,self.topView.AuthorLab.text,textfstr];
    }
    
    if (contents.length == 0) {
        [MBProgressHUD showError:@"请填写内容"];
        return;
    }
    NSString *poetrynoteStr;
    if (self.bottomView.textView.text.length == 0) {
        poetrynoteStr = @"未填写";
    } else {
        poetrynoteStr = self.bottomView.textView.text;
    }
    if (str.length == 0) {
        str = @"";
    }
    [NetWorkManager requestForPostWithUrl:bbsaddURL parameter:@{@"token":[UserInfoManager getUserInfo].token,@"poetry":self.headid,@"rhythm":self.rhythmid,@"yunyun":self.yunid,@"type":@"shi",@"subject":contents,@"images":str,@"poetry_notes":poetrynoteStr} success:^(id reponseObject) {
        [MBProgressHUD showError:reponseObject[@"msg"]];
        if ([reponseObject[@"code"] integerValue] == 1) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        [mdfivetool checkinternationInfomation:error];
        [self hideProgressHUD];
    }];
}


- (void)createheaderV
{
    self.topView = [[TopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 105)];
    //编辑的时候
    NSArray *bodyarr = [self.body componentsSeparatedByString:@"\n"];
    if (self.body.length != 0) {
        
        self.topView.titleLab.text = bodyarr.firstObject;
        self.topView.timeLab.text = [bodyarr[1] componentsSeparatedByString:@"/"][0];
        self.topView.AuthorLab.text = [bodyarr[1] componentsSeparatedByString:@"/"][1];
    }
    //和诗的时候
    if (self.namestr.length != 0) {
        self.topView.titleLab.text = [NSString stringWithFormat:@"和《%@》一首",self.namestr];
    }
    //发表之后编辑
    if (self.edittitle.length != 0) {
        self.topView.titleLab.text = self.edittitle;
    }
    
    [self.topView.tap addTarget:self action:@selector(TapAction)];
    self.tableview.tableHeaderView = self.topView;
    //创建悬浮按钮
    self.btn = [TodayDate createButton];
    [self.btn addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];
}
- (void)TapAction
{
    [TodayDate AlertZYFController:^(NSString *title, NSString *dates, NSString *authorStr) {
        self.topView.titleLab.text = title;
        self.topView.timeLab.text = dates;
        self.topView.AuthorLab.text = authorStr;
    } UIViewController:self];
}
- (void)btnAction:(UIButton *)sender
{
    self.bottomView = [[[NSBundle mainBundle] loadNibNamed:@"BottomView" owner:nil options:nil] firstObject];
    self.bottomView.frame  = CGRectMake(0, self.view.frame.size.height - 250, SCREEN_WIDTH, 250);
    [self.bottomView.leftButton addTarget:self action:@selector(leftAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bottomView.rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bottomView.AddButton addTarget:self action:@selector(AddButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.bottomView];
    self.bottomView.firstImage.contentMode = UIViewContentModeScaleAspectFit;
    self.bottomView.secondImage.contentMode = UIViewContentModeScaleAspectFit;
    self.bottomView.threeImage.contentMode = UIViewContentModeScaleAspectFit;
    //图片处理
    if (self.images.length != 0) {
       NSArray *imagesArredit = [self.images componentsSeparatedByString:@"|"];
        
        if (imagesArredit.count == 1) {
            [self.bottomView.firstImage sd_setImageWithURL:[NSURL URLWithString:imagesArredit[0]]];
        } else if (imagesArredit.count == 2){
             [self.bottomView.firstImage sd_setImageWithURL:[NSURL URLWithString:imagesArredit[0]]];
             [self.bottomView.secondImage sd_setImageWithURL:[NSURL URLWithString:imagesArredit[1]]];
            
        } else {
                [self.bottomView.firstImage sd_setImageWithURL:[NSURL URLWithString:imagesArredit[0]]];
                [self.bottomView.secondImage sd_setImageWithURL:[NSURL URLWithString:imagesArredit[1]]];
                [self.bottomView.threeImage sd_setImageWithURL:[NSURL URLWithString:imagesArredit[2]]];
        }
        [self.imgArray addObjectsFromArray:imagesArredit];
    }
    if (self.poetry_notes.length != 0) {
        self.bottomView.textView.text = self.poetry_notes;
    }
   
    _btn.hidden = YES;
    
}
- (void)AddButtonAction:(UIButton *)sender
{
    [[PhotoPickerManager sharedManager] getImagesInView:self maxCount:3 successBlock:^(NSMutableArray<UIImage *> *images) {
        switch (images.count) {
            case 0:
            {
                [MBProgressHUD showError:@"并没有选择图片"];
            }
                break;
            case 1:
            {
                self.bottomView.firstImage.image = images[0];
            }
                break;
            case 2:
            {
                self.bottomView.firstImage.image = images[0];
                self.bottomView.secondImage.image = images[1];
            }
                break;
            case 3:
            {
                self.bottomView.firstImage.image = images[0];
                self.bottomView.secondImage.image = images[1];
                self.bottomView.threeImage.image = images[2];
                
            }
                break;
                
            default:
                break;
        }
        
        NSMutableDictionary *dic = [NSMutableDictionary new];
        for (int i = 0; i < images.count; i++) {
            
            [dic setObject:[[NSString stringWithFormat:@"image%d",i] dataUsingEncoding:NSUTF8StringEncoding] forKey:[NSString stringWithFormat:@"files%d",i]];
            
        }
        [self.imgArray removeAllObjects];
        
        [NetWorkManager uploadPOST:updateImagesURL parameters:dic consImages:images success:^(id responObject) {
            
            if ([responObject[@"code"] integerValue] == 1) {
                for (NSDictionary *dic in responObject[@"result"][@"successFiles"]) {
                    [self.imgArray addObject:dic[@"url"]];
                }
            }
            
        } failure:^(NSError *error) {
            [mdfivetool checkinternationInfomation:error];
            [self hideProgressHUD];
        }];
    }];
    
    
}
- (void)leftAction:(UIButton *)sender
{
    _btn.hidden = NO;
    [UIView animateWithDuration:2.0 animations:^{
        self.bottomView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250);
        [self.bottomView removeFromSuperview];
    }];
}
- (void)rightButtonAction:(UIButton *)sender
{
    _btn.hidden = NO;
    [UIView animateWithDuration:2.0 animations:^{
        
        self.bottomView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250);
        [self.bottomView removeFromSuperview];
        [MBProgressHUD showError:@"添加成功"];
        
    }];
}
//当这个界面将要消失的时候删除按钮
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.btn.hidden = YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.newarr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
     if (indexPath.row < 4 && indexPath.row > 1){
        cell.textField.backgroundColor = [UIColor colorWithRed:0 green:238 blue:255 alpha:1.0];
    } else if(indexPath.row < 6 && indexPath.row > 3){
        cell.textField.backgroundColor  = [UIColor yellowColor];
    } else if(indexPath.row < 8 && indexPath.row > 5){
        cell.textField.backgroundColor = [UIColor colorWithRed:0 green:238 blue:255 alpha:1.0];
    }
    
    cell.textField.text = self.textFarray[indexPath.row];
    cell.textField.placeholder = self.newarr[indexPath.row][@"content"];
    cell.textField.delegate = self;
    cell.textField.tag = indexPath.row  + 150;
    cell.fuhaolab.text = self.newarr[indexPath.row][@"symbol"];
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
  
    [self.fuhaoArray removeAllObjects];
    [self.textfArray removeAllObjects];
    [self.errorArray removeAllObjects];
    
    CiTableViewCell *cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag - 150 inSection:0]];
    NSLog(@"%@",cell.fuhaolab.text);
    if (cell.textField.text.length != cell.fuhaolab.text.length + 1) {
        [MBProgressHUD showError:@"请检查字数是否对应或者符号是否添加"];
    } else {
        
        //每次填写完一行就进行检测
        [self showProgressHUD];
       
        NSString *fohaostr;
        NSString *pingstr;
        NSString *zestr;
        
        for (NSDictionary *dic1 in self.allfuhaoArr) {
            
            if ([dic1[@"symbol"] isEqualToString:@"○"]) {
                pingstr = dic1[@"id"];
            }
            if ([dic1[@"symbol"] isEqualToString:@"●"]) {
                zestr = dic1[@"id"];
            }
            
        }
        //符号进行遍历
        for (int j = 0; j < cell.fuhaolab.text.length; j++) {
            
            fohaostr = [cell.fuhaolab.text substringWithRange:NSMakeRange(j, 1)];
            
           
            for (NSDictionary *dic in self.allfuhaoArr) {
                if ([dic[@"symbol"] isEqualToString:fohaostr]) {
                    
                    if ([dic[@"symbol"] isEqualToString:@"⊙"]) {
                        [self.fuhaoArray addObject:@"first"];
                    } else if([dic[@"symbol"] isEqualToString:@"△"]){
                        [self.fuhaoArray addObject:pingstr];
                    } else if ([dic[@"symbol"] isEqualToString:@"▲"]){
                        [self.fuhaoArray addObject:zestr];
                    } else {
                        [self.fuhaoArray addObject:dic[@"id"]];
                    }
                    
                }
            }
        }
        
        
        //遍历输入的字体
        NSString *textstr;
        for (int i = 0; i < textField.text.length - 1; i++) {
            textstr = [textField.text substringWithRange:NSMakeRange(i, 1)];
          
            [self.textfArray addObject:textstr];
            
        }
        
        //判断是否押韵
        [self isyunmethod:cell];
        
        //将id和字进行结合
        NSMutableArray *newarr = [[NSMutableArray alloc] init];
            
        for (int k = 0; k < self.fuhaoArray.count; k++) {
            [newarr addObject:[NSString stringWithFormat:@"%@-%@",self.fuhaoArray[k],self.textfArray[k]]];
            
        }
        
        for (NSString *newstr in newarr) {
        
            NSString *fontstr= [self compelestr:newstr];
          
            NSArray *otherarr = [newstr componentsSeparatedByString:@"-"];
                           
                            if ([fontstr containsString:otherarr[1]]) {
                               [MBProgressHUD showSuccess:@"正确"];
                            } else {
                                [self.errorArray addObject:[NSString stringWithFormat:@"%@未找到",otherarr[1]]];
                            }
        }
        if (self.errorArray.count != 0) {
            cell.newlab.text = [self.errorArray componentsJoinedByString:@"/"];
        } else {
            cell.newlab.text = @"正确";
        }
        
        [self hideProgressHUD];

    }
    
}

- (NSString *)compelestr:(NSString *)str
{
    
    NSString *firststr;
    NSString *secondstr;
    NSMutableArray *firstarr = [NSMutableArray new];
    NSMutableArray *secondarr = [NSMutableArray new];
     for (NSDictionary *dic in self.fontArray) {
         
         if ([str containsString:dic[@"toneId"]] ) {
             [firstarr addObject:dic[@"font"]];
             firststr = [firstarr componentsJoinedByString:@" "];
             
            
         } else if ([str containsString:@"first"]){
             [secondarr addObject:dic[@"font"]];
             secondstr = [secondarr componentsJoinedByString:@" "];
             
         }
     }
    
    if (firststr.length != 0) {
        return firststr;
    } else {
        return secondstr;
    }
    
}


- (void)isyunmethod:(CiTableViewCell *)cell
{
    
    
    NSMutableArray *newarrstr = [NSMutableArray new];
    //符号进行遍历
    NSString *fohaostr;
    for (int j = 0; j < cell.fuhaolab.text.length; j++) {
        fohaostr = [cell.fuhaolab.text substringWithRange:NSMakeRange(j, 1)];
        NSLog(@"%@",fohaostr);
        if ([fohaostr isEqualToString:@"☆"] || [fohaostr isEqualToString:@"△"] || [fohaostr isEqualToString:@"▲"]) {
            NSString *str = self.textfArray[j];
            [newarrstr addObject:str];
        }
        
    }
    
    if (newarrstr.count != 0) {
        
        //将韵书中的放到数组中
        NSMutableArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"search"];
        
        if ([self.title isEqualToString:@"平水韵"]) {
            for (NSDictionary *dic in arr) {
                if ([dic[@"name"] isEqualToString:@"平水韵"]) {
                    for (NSDictionary *newdic in dic[@"parts"]) {
                        for (NSDictionary *fontdic in newdic[@"tones"]) {
                            if ([fontdic[@"font"] containsString:newarrstr[0]]) {
                                [[NSUserDefaults standardUserDefaults] setObject:fontdic[@"font"] forKey:@"fontstrnew"];
                                
                            } else {
                              
                                return;
                            }
                            
                        }
                    }
                }
            }
        } else if ([self.title isEqualToString:@"词林正韵"]){
            for (NSDictionary *dic in arr) {
                if ([dic[@"name"] isEqualToString:@"词林正韵"]) {
                    for (NSDictionary *newdic in dic[@"parts"]) {
                        for (NSDictionary *fontdic in newdic[@"tones"]) {
                            if ([fontdic[@"font"] containsString:newarrstr[0]]) {
                                [[NSUserDefaults standardUserDefaults] setObject:fontdic[@"font"] forKey:@"fontstrnew"];
                                
                            } else {
                                
                                return;
                            }
                            
                        }
                    }
                }
            }
        } else if ([self.title isEqualToString:@"中华新韵"]){
            for (NSDictionary *dic in arr) {
                if ([dic[@"name"] isEqualToString:@"中华新韵"]) {
                    for (NSDictionary *newdic in dic[@"parts"]) {
                        for (NSDictionary *fontdic in newdic[@"tones"]) {
                            
                            if ([fontdic[@"font"] containsString:newarrstr[0]]) {
                                [[NSUserDefaults standardUserDefaults] setObject:fontdic[@"font"] forKey:@"fontstrnew"];
                                
                            } else {
                                
                                return;
                            }
                        }
                    }
                }
            }
        }
        
        
        for (NSString *onestr in newarrstr) {
            NSString *fontstrlogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"fontstrnew"];
            if ([fontstrlogin containsString:onestr]) {
                return;
            } else {
                [MBProgressHUD showError:@"存在不押韵字体"];
            }
        }
        
    }
    
    
}

@end
