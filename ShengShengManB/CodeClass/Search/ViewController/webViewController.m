//
//  webViewController.m
//  ShengShengManB
//
//  Created by mibo02 on 17/6/5.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "webViewController.h"

@interface webViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webview;

@end

@implementation webViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.title = self.titlestr;
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlstr]]];
}



@end
