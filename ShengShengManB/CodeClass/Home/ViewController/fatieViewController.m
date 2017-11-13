//
//  fatieViewController.m
//  ShengShengManB
//
//  Created by mibo02 on 17/6/20.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "fatieViewController.h"

@interface fatieViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textv;
@property (weak, nonatomic) IBOutlet UIImageView *firstimg;
@property (weak, nonatomic) IBOutlet UIImageView *secondimg;
@property (weak, nonatomic) IBOutlet UIImageView *threeimg;
@property (nonatomic, strong)NSMutableArray *imgArray;
@end

@implementation fatieViewController
- (NSMutableArray *)imgArray
{
    if (!_imgArray) {
        self.imgArray = [NSMutableArray new];
    }
    return _imgArray;
}
- (IBAction)addimageaction:(UIButton *)sender {
    [[PhotoPickerManager sharedManager] getImagesInView:self maxCount:3 successBlock:^(NSMutableArray<UIImage *> *images) {
        
        self.firstimg.contentMode = UIViewContentModeScaleAspectFit;
        self.secondimg.contentMode = UIViewContentModeScaleAspectFit;
        self.threeimg.contentMode = UIViewContentModeScaleAspectFit;
        
        switch (images.count) {
            case 0:
            {
                [MBProgressHUD showError:@"并没有选择图片"];
            }
                break;
            case 1:
            {
                self.firstimg.image = images[0];
            }
                break;
            case 2:
            {
                self.firstimg.image = images[0];
                self.secondimg.image = images[1];
                
            }
                break;
            case 3:
            {
                self.firstimg.image = images[0];
                self.secondimg.image = images[1];
                self.threeimg.image = images[2];
                
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发帖";
    self.navigationController.navigationBar.translucent = NO;
    if (self.contentstr.length != 0) {
        self.textv.text = self.contentstr;
    }
    if (self.imagesnewstr.length != 0) {
        NSArray *subjectarr = [self.imagesnewstr componentsSeparatedByString:@"|"];
        if (subjectarr.count == 1) {
            [self.firstimg sd_setImageWithURL:[NSURL URLWithString:subjectarr[0]]];
        } else if (subjectarr.count == 2){
            [self.firstimg sd_setImageWithURL:[NSURL URLWithString:subjectarr[0]]];
            [self.secondimg sd_setImageWithURL:[NSURL URLWithString:subjectarr[1]]];
        } else if (subjectarr.count == 3){
            [self.firstimg sd_setImageWithURL:[NSURL URLWithString:subjectarr[0]]];
            [self.secondimg sd_setImageWithURL:[NSURL URLWithString:subjectarr[1]]];
            [self.threeimg sd_setImageWithURL:[NSURL URLWithString:subjectarr[2]]];
           
        }
    }
}

- (IBAction)completeaction:(UIButton *)sender {
    NSString *str;
    if (self.imgArray.count != 0) {
        str = [self.imgArray componentsJoinedByString:@"|"];
    }
    
    if (str.length == 0) {
        [MBProgressHUD showError:@"请上传至少一张图片"];
        return;
    }
    if (self.textv.text.length == 0) {
        [MBProgressHUD showError:@"内容不能为空"];
    }
    [NetWorkManager requestForPostWithUrl:bbsaddURL parameter:@{@"token":[UserInfoManager getUserInfo].token,@"poetry":@"fengfeng",@"rhythm":@"123",@"yunyun":@"456",@"type":@"ot",@"subject":self.textv.text,@"images":str,@"poetry_notes":@""} success:^(id reponseObject) {
        [MBProgressHUD showError:reponseObject[@"msg"]];
        
        if ([reponseObject[@"code"] integerValue] == 1) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
        [mdfivetool checkinternationInfomation:error];
        [self hideProgressHUD];
    }];
}

@end
