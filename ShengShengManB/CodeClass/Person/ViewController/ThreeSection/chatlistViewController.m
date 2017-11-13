//
//  chatlistViewController.m
//  ShengShengManB
//
//  Created by mibo02 on 17/5/16.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "chatlistViewController.h"
#import "chatdetailViewController.h"
@interface chatlistViewController ()

@end

@implementation chatlistViewController
- (id)init
{
    self = [super init];
    if (self) {
        //设置需要显示哪些类型的会话
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE)
                                           ]];
        //设置需要将哪些类型的会话在会话列表中聚合显示
        [self setCollectionConversationType:@[@(ConversationType_DISCUSSION)
                                              ]];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会话列表";
  
     self.conversationListTableView.tableFooterView = [UIView new];
    
}

//重写RCConversationListViewController的onSelectedTableRow事件
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    
    chatdetailViewController *rcConversationVC = [[chatdetailViewController alloc] initWithConversationType:model.conversationType targetId:model.targetId];
    rcConversationVC.title = model.conversationTitle;
    NSLog(@"private-->%@", model.conversationTitle);
    [self.navigationController pushViewController:rcConversationVC animated:YES];
}


@end
