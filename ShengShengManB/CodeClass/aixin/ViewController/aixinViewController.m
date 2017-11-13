//
//  aixinViewController.m
//  ShengShengManB
//
//  Created by mibo02 on 17/4/27.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "aixinViewController.h"
#import "dashangViewController.h"
#import "zhishibaoViewController.h"
@interface aixinViewController ()


@end

@implementation aixinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"爱心驿站";
    
    
//    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"txt"];
//    NSString *str = [[NSString alloc] initWithContentsOfFile:filepath];
//    NSLog(@"%@",str);
//    NSData *imageData = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
//    self.img.image = [UIImage imageWithData:imageData];
}

//- (IBAction)firstbtn:(UIButton *)sender
//{
//    dashangViewController *dashang = [dashangViewController new];
//    [self.navigationController pushViewController:dashang animated:YES];
//}
//- (IBAction)secondbtn:(UIButton *)sender
//{
//    zhishibaoViewController *zhishi = [zhishibaoViewController new];
//    [self.navigationController pushViewController:zhishi animated:YES];
//}

- (IBAction)guanzhu:(UIButton *)sender {
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.shengshengman.net"]];
}

@end
