//
//  FWConstants.h
//  FWShareSDKDemo
//
//  Created by Liuyong on 14-8-8.
//  Copyright (c) 2014年 FlyWire. All rights reserved.
//

//#import <Foundation/Foundation.h>


typedef enum SocialSNSType {
    kSocialSNSTypeNone              = -1,
    kSocialSNSTypeYixinSession      = 0, //易信好友
    kSocialSNSTypeYixinTimeLine     = 1, //易信朋友圈
    kSocialSNSTypeWeChatSession     = 2, //微信好友
    kSocialSNSTypeWeChatTimeLine    = 3, //微信朋友圈
    kSocialSNSTypeSinaWeibo         = 4, //新浪微博
//    kSocialSNSTypeTencentWeibo      = 5, //腾讯微博
    
} SocialSNSType;

typedef enum FWResponseState {
	FWResponseStateBegan = 0, /**< 开始 */
	FWResponseStateSuccess = 1, /**< 成功 */
	FWResponseStateFail = 2, /**< 失败 */
	FWResponseStateCancel = 3 /**< 取消 */
}FWResponseState;

#define kShowMessageNotInstallApp @"未安装客户端"
#define kShowMessageThumbnailLarge @"缩略图大于32k"
#define kAlertViewTagNotInstalled 101

extern NSString * const FWShareErrorDomain;

