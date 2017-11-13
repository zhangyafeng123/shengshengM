//
//  Header.h
//  ShengShengManA
//
//  Created by mibo02 on 16/12/14.
//  Copyright © 2016年 mibo02. All rights reserved.
//

#ifndef Header_h
#define Header_h
//self
#define WS(weakSelf) __weak  __typeof(&*self)weakSelf = self;


/**随机颜色*/
#define RandomColor [UIColor colorWithRed:arc4random() % 256 / 255.0 green:arc4random() % 256 / 255.0 blue:arc4random() % 256 / 255.0 alpha:1.0]
//NavBarColor
#define NavColor  [UIColor colorWithRed:68/256.0 green:88/256.0 blue:188/256.0 alpha:1.0]
#define kSpace 10
#define imgWidth ([UIScreen mainScreen].bounds.size.width-20-75)/3//高宽相等

//尺寸
#define SCREEN_WIDTH     [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT    [UIScreen mainScreen].bounds.size.height
#define TabBarHeight 49
///正常字体
#define H30 [UIFont systemFontOfSize:30]
#define H29 [UIFont systemFontOfSize:29]
#define H28 [UIFont systemFontOfSize:28]
#define H27 [UIFont systemFontOfSize:27]
#define H26 [UIFont systemFontOfSize:26]
#define H25 [UIFont systemFontOfSize:25]
#define H24 [UIFont systemFontOfSize:24]
#define H23 [UIFont systemFontOfSize:23]
#define H22 [UIFont systemFontOfSize:22]
#define H20 [UIFont systemFontOfSize:20]
#define H19 [UIFont systemFontOfSize:19]
#define H18 [UIFont systemFontOfSize:18]
#define H17 [UIFont systemFontOfSize:17]
#define H16 [UIFont systemFontOfSize:16]
#define H15 [UIFont systemFontOfSize:15]
#define H14 [UIFont systemFontOfSize:14]
#define H13 [UIFont systemFontOfSize:13]
#define H12 [UIFont systemFontOfSize:12]
#define H11 [UIFont systemFontOfSize:11]
#define H10 [UIFont systemFontOfSize:10]
#define H8 [UIFont systemFontOfSize:8]

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
//拼接接口http://shengshengman.net:9000/ssmis
//http://192.168.1.151:8080
#define ALLURL  @"http://app.shengshengman.net"
//图片拼接地址
#define ImageAllURL @"http://app.shengshengman.net"
//作者列表
#define accountfriendURL [NSString stringWithFormat:@"%@/ssmis/api/account/friend",ALLURL]
//获取融云token
#define gettokenURL  [NSString stringWithFormat:@"%@/ssmis/api/account/rongtoken",ALLURL]
//图片拼接接口
#define ImageViewURL(url)  [NSString stringWithFormat:@"%@%@",ImageAllURL,url]
//上传多张图片

#define updateImagesURL [NSString stringWithFormat:@"%@/ssmis/api/file/upload",ALLURL]
//登录
#define loginURL [NSString stringWithFormat:@"%@/ssmis/api/account/login",ALLURL]
//注册接口
#define registerURL  [NSString stringWithFormat:@"%@/ssmis/api/account/register",ALLURL]
//获取验证码接口
#define senderMessageURL [NSString stringWithFormat:@"%@/ssmis/api/account/code",ALLURL]
//完善个人信息接口(post)//获取个人信息接口(get)
#define accountinfoURL  [NSString stringWithFormat:@"%@/ssmis/api/account/info",ALLURL]
//修改密码
#define passwordURL  [NSString stringWithFormat:@"%@/ssmis/api/account/password",ALLURL]
//退出登录
#define logoutURL  [NSString stringWithFormat:@"%@/ssmis/api/account/logout",ALLURL]
//帖子收藏信息接口
#define collectURL [NSString stringWithFormat:@"%@/ssmis/api/account/collect",ALLURL]
//查看其它用户信息及帖子接口
#define accountuserinfoUTL [NSString stringWithFormat:@"%@/ssmis/api/account/userinfo",ALLURL]
//获取融云用户标识接口
//取消关注接口
#define accountcancelfollowURL  [NSString stringWithFormat:@"%@/ssmis/api/account/cancelfollow",ALLURL]
//添加关注接口
#define accountaddfollowURL   [NSString stringWithFormat:@"%@/ssmis/api/account/addfollow",ALLURL]
//我的粉丝接口
#define accountfansURL [NSString stringWithFormat:@"%@/ssmis/api/account/fans",ALLURL]
//我的偶像接口
#define accountidolURL [NSString stringWithFormat:@"%@/ssmis/api/account/idol",ALLURL]
//活动信息列表
#define infoListURL [NSString stringWithFormat:@"%@/ssmis/api/activity/infoList",ALLURL]
//我的诗集接口
#define accountshisURL [NSString stringWithFormat:@"%@/ssmis/api/account/shis",ALLURL]
//获取系统消息接口
#define accountmessageURL [NSString stringWithFormat:@"%@/ssmis/api/account/message",ALLURL]
//好友列表
#define friendlistURL [NSString stringWithFormat:@"%@/ssmis/api/friends/lists",ALLURL]
//添加黑名单接口
#define blacklistaddURL [NSString stringWithFormat:@"%@/ssmis/api/blacklist/add",ALLURL]
//黑名单列表
#define friendsdefriendsURL [NSString stringWithFormat:@"%@/ssmis/api/friends/defriends",ALLURL]
//添加好友
#define friendaddURL [NSString stringWithFormat:@"%@/ssmis/api/friends/add",ALLURL]
//移除黑名单好友接口
#define blacklistremoveURL [NSString stringWithFormat:@"%@/ssmis/api/blacklist/remove",ALLURL]
//我的评论
#define mycommentURL  [NSString stringWithFormat:@"%@/ssmis/api/account/mycomment",ALLURL]
//评论我的接口
#define commentonmeURL  [NSString stringWithFormat:@"%@/ssmis/api/account/commentonme",ALLURL]
//我的关注用户的帖子接口
#define myfollowURL  [NSString stringWithFormat:@"%@/ssmis/api/account/myfollow",ALLURL]


//发布活动接口
#define addURL [NSString stringWithFormat:@"%@/ssmis/api/activity/add",ALLURL]
//报名活动接口
#define signupURL [NSString stringWithFormat:@"%@/ssmis/api/activity/signup",ALLURL]
//报名活动信息接口
#define signupInfoURL  [NSString stringWithFormat:@"%@/ssmis/api/activity/signupInfo",ALLURL]
//我发布的活动接口
#define myListURL [NSString stringWithFormat:@"%@/ssmis/api/activity/myList",ALLURL]


//爱心驿站
//打赏列表接口
#define danationURL [NSString stringWithFormat:@"%@/ssmis/api/station/donation",ALLURL]
//知识包列表接口
#define knowledgesURL [NSString stringWithFormat:@"%@/ssmis/api/station/knowledges",ALLURL]
//打赏接口
#define stationdonateURL [NSString stringWithFormat:@"%@/ssmis/api/station/donate",ALLURL]
//知识包下载接口
#define downloadkpURL  [NSString stringWithFormat:@"%@/ssmis/api/station/downloadkp",ALLURL]
//购买知识包接口
#define buypackageURL  [NSString stringWithFormat:@"%@/ssmis/api/station/buypackage",ALLURL]
//谱曲成歌
//音乐欣赏列表
#define appreciateURL [NSString stringWithFormat:@"%@/ssmis/api/music/appreciate",ALLURL]
//唱片公司列表接口
#define cianInfoURL  [NSString stringWithFormat:@"%@/ssmis/api/music/cianInfo",ALLURL]
//我的谱曲成歌需求列表接口
#define cianDemandURL [NSString stringWithFormat:@"%@/ssmis/api/music/cianDemand",ALLURL]
//提交谱曲需求接口
#define musicaddURL [NSString stringWithFormat:@"%@/ssmis/api/music/add",ALLURL]


//论坛接口
//论坛列表接口
#define bbslistURL [NSString stringWithFormat:@"%@/ssmis/api/bbs/list",ALLURL]
//帖子转发接口
#define bbsaddRelayURL [NSString stringWithFormat:@"%@/ssmis/api/bbs/addRelay",ALLURL]
//帖子评论回复接口
#define bbsaddReplyURL  [NSString stringWithFormat:@"%@/ssmis/api/bbs/addReply",ALLURL]
//添加帖子评论接口
#define bbsaddCommentsURL [NSString stringWithFormat:@"%@/ssmis/api/bbs/addComments",ALLURL]
//取消帖子点赞接口
#define bbscancelRiokinURL  [NSString stringWithFormat:@"%@/ssmis/api/bbs/cancelRiokin",ALLURL]
//添加帖子点赞接口
#define bbsaddRiokinURL  [NSString stringWithFormat:@"%@/ssmis/api/bbs/addRiokin",ALLURL]
//删除帖子收藏接口
#define bbscancelCollectURL [NSString stringWithFormat:@"%@/ssmis/api/bbs/cancelCollect",ALLURL]
//收藏帖子接口
#define bbsaddCollectURL  [NSString stringWithFormat:@"%@/ssmis/api/bbs/addCollect",ALLURL]
//发布帖子接口
#define bbsaddURL [NSString stringWithFormat:@"%@/ssmis/api/bbs/add",ALLURL]
//帖子详情接口
#define bbsinfoURL [NSString stringWithFormat:@"%@/ssmis/api/bbs/info",ALLURL]
//删除帖子接口
#define bbsdeletecommentURL [NSString stringWithFormat:@"%@/ssmis/api/bbs/deletecomment",ALLURL]
//删除诗集接口
#define deletepersonURL [NSString stringWithFormat:@"%@/ssmis/api/bbs/delete",ALLURL]
//签到相关
//签到信息接口
#define signinfoURL [NSString stringWithFormat:@"%@/ssmis/api/sign/info",ALLURL]
//添加签到接口
#define signaddURL [NSString stringWithFormat:@"%@/ssmis/api/sign/add",ALLURL]

#define addshanglianURL [NSString stringWithFormat:@"%@/ssmis/api/couplet/addshanglian",ALLURL]
//出联应对接口
#define cupletinfoURL [NSString stringWithFormat:@"%@/ssmis/api/couplet/shanglian",ALLURL]
//答对联接口
#define answerURL [NSString stringWithFormat:@"%@/ssmis/api/couplet/answer",ALLURL]
//下联列表
#define coupletinfoURL  [NSString stringWithFormat:@"%@/ssmis/api/couplet/info",ALLURL]
//曲信息接口
#define songinfoURL  [NSString stringWithFormat:@"%@/ssmis/api/song/info",ALLURL]
//符号信息接口
#define symbolinfoURL [NSString stringWithFormat:@"%@/ssmis/api/symbol/info",ALLURL]
//声调韵信息接口
#define toneinfoURL [NSString stringWithFormat:@"%@/ssmis/api/tone/info",ALLURL]

//诗信息接口
#define poetryinfoURL [NSString stringWithFormat:@"%@/ssmis/api/poetry/info",ALLURL]
//韵书接口
#define yunyininfoURL  [NSString stringWithFormat:@"%@/ssmis/api/yunyin/info",ALLURL]

//词信息接口
#define wordinfoURL [NSString stringWithFormat:@"%@/ssmis/api/word/info",ALLURL]

//首页banner
#define bannerURL  [NSString stringWithFormat:@"%@/ssmis/api/banner",ALLURL]

//添加草稿
#define draftaddURL [NSString stringWithFormat:@"%@/ssmis/api/draft/add",ALLURL]
//删除草稿接口
#define draftdeleteURL [NSString stringWithFormat:@"%@/ssmis/api/draft/delete",ALLURL]
//修改草稿接口
#define draftupdateURL  [NSString stringWithFormat:@"%@/ssmis/api/draft/update",ALLURL]
//草稿列表接口
#define draftpageURL  [NSString stringWithFormat:@"%@/ssmis/api/draft/page",ALLURL]
//草稿详细信息
#define draftinfoURL  [NSString stringWithFormat:@"%@/ssmis/api/draft/info",ALLURL]

//图片验证
#define imageotherURL [NSString stringWithFormat:@"%@/ssmis/api/account/codes",ALLURL]

#define phonecloginURL [NSString stringWithFormat:@"%@/ssmis/api/account/clogin",ALLURL]

#define searchURL  [NSString stringWithFormat:@"%@/ssmis/api/bbs/retrieval",ALLURL]
#endif /* Header_h */
