//
//  TableViewCell.h
//  TableView--test
//
//  Created by kaizuomac2 on 16/8/3.
//  Copyright © 2016年 kaizuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyModel.h"

typedef void (^publishReiseOrPraise)(NSString*);

//图片点击
@protocol ImageDelegate <NSObject>

-(void)checkImage:(NSString*)imgname;

@end

//评论--点赞
@protocol ReviseDelegate <NSObject>

-(void)publishReiseOrPraise:(NSString*)method cellTag:(NSInteger)tag;

@end

@interface TableViewCell : UITableViewCell

{
    __weak IBOutlet UIImageView *headImg;

    __weak IBOutlet UILabel *username;
 
    __weak IBOutlet UILabel *contentText;
    
    __weak IBOutlet UIView *newImage;
    
    __weak IBOutlet UILabel *review;
}

@property (copy ,nonatomic) publishReiseOrPraise myBlock;

@property (weak, nonatomic) id<ImageDelegate>myDelegate;

@property (weak, nonatomic) id<ReviseDelegate> delegate;

@property (strong, nonatomic) MyModel *myModel;

@end
