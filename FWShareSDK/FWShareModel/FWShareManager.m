//
//  FWShareManager.m
//  FWShareSDKDemo
//
//  Created by Liuyong on 14-8-8.
//  Copyright (c) 2014年 FlyWire. All rights reserved.
//

#import "FWShareManager.h"
#import "FWShareView.h"

#import "YXApi.h"
#import "WXApi.h"
#import "WeiboSDK.h"

#import "YXApiObject.h"
#import "WXApiObject.h"


@interface FWShareManager () <YXApiDelegate, WXApiDelegate, WeiboSDKDelegate, UIAlertViewDelegate>

@property (nonatomic, weak)   UIViewController *fromViewController;
@property (nonatomic, strong) UIViewController *containerViewController;
@property (nonatomic, strong) NSMutableArray *socialTypes;
@property (nonatomic, assign) SocialSNSType selectedSocialType;
@property (nonatomic, strong) FWShareData *shareData;

@end



@implementation FWShareManager

#pragma mark - Class method

const NSUInteger cMaxThumbnailSize = 32 * 1024;


+ (FWShareManager *)sharedManager
{
    static FWShareManager *sharedManagerInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManagerInstance = [[FWShareManager alloc] init];
    });
    
    return sharedManagerInstance;
}

+ (void)setYiXinAPPKey:(NSString *)appKey
{
    [YXApi registerApp:appKey];
}

+ (void)setWeChatAPPKey:(NSString *)appKey withDescription:(NSString *)desc
{
    [WXApi registerApp:appKey withDescription:desc];
}


+ (void)setSinaWeiboAPPKey:(NSString *)appKey
{
    [WeiboSDK registerApp:appKey];
}


+ (void)showShareViewFrom:(UIViewController *)fromViewController
             shareContent:(FWShareData *)shareData
        completionHandler:(SharedCompletionHandler)completionHandler
{
    [FWShareManager showShareViewFrom:fromViewController
                        containerView:nil
                         shareContent:shareData
                    completionHandler:completionHandler];
    
}

+ (void)showShareViewFrom:(UIViewController *)fromViewController
            containerView:(UIView *)containerView
             shareContent:(FWShareData *)shareData
        completionHandler:(SharedCompletionHandler)completionHandler
{
    FWShareManager *sharedManager = [FWShareManager sharedManager];
    sharedManager.fromViewController = fromViewController;
    sharedManager.shareData = shareData;
    sharedManager.completionHandler = completionHandler;
    [sharedManager.shareView showInview:containerView];
}

+ (BOOL)initSocialTypes:(NSArray *)socialTypes
             itemTitles:(NSArray *)itemTitles
             iconImages:(NSArray *)iconImages
{
    if (!socialTypes || !itemTitles || !iconImages) {
        return NO;
    }
    
    FWShareManager *sharedManager = [FWShareManager sharedManager];
    [sharedManager.shareView setupItemTitles:itemTitles images:iconImages];
    [sharedManager.socialTypes addObjectsFromArray:socialTypes];
    return YES;
}

+ (BOOL)addSocialTypes:(NSArray *)socialTypes
            itemTitles:(NSArray *)itemTitles
            iconImages:(NSArray *)iconImages
{
    if (!socialTypes || !itemTitles || !iconImages) {
        return NO;
    }
    
    FWShareManager *sharedManager = [FWShareManager sharedManager];
    BOOL isAddSuccess = [sharedManager.shareView addItemTitles:itemTitles images:iconImages];
    if (isAddSuccess) {
       [sharedManager.socialTypes addObjectsFromArray:socialTypes];
    }
    return isAddSuccess;
}

+ (BOOL)addSocialType:(SocialSNSType)socialType
                title:(NSString *)title
            iconImage:(UIImage *)iconImage
{
    if (socialType != kSocialSNSTypeNone || !title || !iconImage) {
        return NO;
    }
    
    FWShareManager *sharedManager = [FWShareManager sharedManager];
    BOOL isAddSuccess = [sharedManager.shareView addItemTitle:title image:iconImage];
    if (isAddSuccess) {
        [sharedManager.socialTypes addObject:[NSNumber numberWithInt:socialType]];
    }
    return isAddSuccess;
}

+ (BOOL)handleOpenURL:(NSURL *)url
{
    FWShareManager *sharedManager = [FWShareManager sharedManager];
    
    return [YXApi handleOpenURL:url delegate:sharedManager]
    || [WXApi handleOpenURL:url delegate:sharedManager]
    || [WeiboSDK handleOpenURL:url delegate:sharedManager];
}

+ (void)shareContent:(FWShareData *)shareData
        toSocialType:(SocialSNSType)socialType
   completionHandler:(SharedCompletionHandler)completionHandler
{
    FWShareManager *sharedManager = [FWShareManager sharedManager];
    sharedManager.completionHandler = completionHandler;
    [sharedManager shareContent:shareData toSocialType:socialType];
}

#pragma  mark - Instance method

- (UIViewController *)containerViewController
{
    if (!_containerViewController) {
        _containerViewController = [[UIViewController alloc] init];
        _containerViewController.view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    }
    
    return _containerViewController;
}


- (FWShareView *)shareView
{
    if (!_shareView) {
        _shareView = [[FWShareView alloc] initWithTitle:@"分享到" itemTitles:@[] images:@[] selectedHandler:^(NSInteger index){
            //视图消失
            
            if (index >= 0 && index < self.socialTypes.count) {
                SocialSNSType socialType = (SocialSNSType)[self.socialTypes[index] intValue];
                [self shareContent:self.shareData toSocialType:socialType];
            }
            else {
                [self shareContent:self.shareData toSocialType:kSocialSNSTypeNone];
            }
            
        }];
    }
    
    return _shareView;
}

- (NSMutableArray *)socialTypes
{
    if (!_socialTypes) {
        _socialTypes = [NSMutableArray array];
    }
    
    return _socialTypes;
}

- (void)setShareTitle:(NSString *)title
{
    self.shareView.title = title;
}

- (void)setShareItemSize:(CGSize)itemSize titleHeight:(CGFloat)titleHeight itemColumn:(NSUInteger)column
{
    self.shareView.itemSize = itemSize;
    self.shareView.titleHeight = titleHeight;
    self.shareView.numOfColumns = column;
}

- (void)shareContent:(FWShareData *)shareData toSocialType:(SocialSNSType)socialType
{
    if (self.shareData != shareData) {
        self.shareData = shareData;
    }
    self.selectedSocialType = socialType;
    
    //先判断是否安装客户端，若未安装，则提示未安装客户端信息，不发送分享信息
    switch (socialType) {
        case kSocialSNSTypeYixinSession:
        case kSocialSNSTypeYixinTimeLine:
            if (![YXApi isYXAppInstalled]) {
                [self showAlertViewMessage:kShowMessageNotInstallApp];
                return;
            }
            break;
        case kSocialSNSTypeWeChatSession:
        case kSocialSNSTypeWeChatTimeLine:
            if (![WXApi isWXAppInstalled]) {
                [self showAlertViewMessage:kShowMessageNotInstallApp];
                return;
            }
            break;
        case kSocialSNSTypeSinaWeibo:
            
            if (![WeiboSDK isWeiboAppInstalled]) {
                [self showAlertViewMessage:kShowMessageNotInstallApp];
                return;
            }
            break;
            
        default:
            break;
    }
    
    if (self.completionHandler) {
        self.completionHandler(socialType, FWResponseStateBegan, shareData, nil);
    }
    
    if (self.completionHandler && shareData.dataType == kShareDataTypeWebPage) {
        FWWebpageObject *sourceMediaObject = (FWWebpageObject *)shareData.mediaObject;
        NSData *thumbnailData = sourceMediaObject.thumbnailData;
        if (thumbnailData.length > cMaxThumbnailSize) {
            //缩略图过大32k,再次压缩
            CGFloat compress = (CGFloat)cMaxThumbnailSize / thumbnailData.length;
            NSData *data = UIImageJPEGRepresentation([UIImage imageWithData:thumbnailData], compress);
            if (data.length > cMaxThumbnailSize) {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"message",kShowMessageThumbnailLarge, nil];
                self.completionHandler(socialType, FWResponseStateFail, shareData, [NSError errorWithDomain:FWShareErrorDomain code:102 userInfo:userInfo]);
                return;
            }
            else {
                sourceMediaObject.thumbnailData = data;
            }
        }
    }
    
    switch (socialType) {
        case kSocialSNSTypeYixinSession:
        {
            [self shareContent:shareData toYiXin:kYXSceneSession];
        }
            break;
        case kSocialSNSTypeYixinTimeLine:
        {
            [self shareContent:shareData toYiXin:kYXSceneTimeline];
        }
            break;
        case kSocialSNSTypeWeChatSession:
        {
            [self shareContent:shareData toWeChat:WXSceneSession];
        }
            break;
        case kSocialSNSTypeWeChatTimeLine:
        {
            [self shareContent:shareData toWeChat:WXSceneTimeline];
        }
            break;
        case kSocialSNSTypeSinaWeibo:
        {
            [self shareContentToSinaWeibo:shareData];
        }
            break;
     
        default:    //kSocialSNSTypeNone do nothing
            if (self.completionHandler) {
                self.completionHandler(kSocialSNSTypeNone, FWResponseStateCancel, shareData, nil);
            }
            break;
    }
}


#pragma mark - private method share content

- (void)shareContent:(FWShareData *)shareData toYiXin:(enum YXScene)yxScene
{
    SendMessageToYXReq *req = [[SendMessageToYXReq alloc] init];
    req.scene = yxScene;
 
    if (shareData.dataType == kShareDataTypeImage)
    {
        req.bText = NO;
        req.text = self.shareData.text;
        
        FWImageObject *sourceMediaObject = (FWImageObject *)shareData.mediaObject;
        
        YXImageObject *imageObject = [YXImageObject object];
        imageObject.imageData = sourceMediaObject.imageData;
        
        YXMediaMessage *message = [YXMediaMessage message];
        message.thumbData = sourceMediaObject.thumbnailData;
        message.mediaObject = imageObject;
        
        req.message = message;
    }
    else if (shareData.dataType == kShareDataTypeWebPage) {
        
        FWWebpageObject *sourceMediaObject = (FWWebpageObject *)shareData.mediaObject;
        
        YXWebpageObject *pageObject = [YXWebpageObject object];
        pageObject.webpageUrl = sourceMediaObject.webpageUrl;
        
        YXMediaMessage *message = [YXMediaMessage message];
        message.title = sourceMediaObject.title;
        message.description = sourceMediaObject.desc;
        [message setThumbData:sourceMediaObject.thumbnailData];
        message.mediaObject = pageObject;
        
        req.message = message;
    }
    else {
        //默认以文本信息发送
        req.bText = YES;
        req.text = shareData.text;
    }
   
    
    [YXApi sendReq:req];
}

- (void)shareContent:(FWShareData *)shareData toWeChat:(enum WXScene)wxScene
{
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.scene = wxScene;
    
    if (shareData.dataType == kShareDataTypeImage) {
        req.bText = NO;
        
        FWImageObject *sourceMediaObject = (FWImageObject *)shareData.mediaObject;

        WXMediaMessage *message = [WXMediaMessage message];
        req.text = shareData.text;
        message.title = shareData.text;
        WXImageObject *imageObject = [WXImageObject object];
        imageObject.imageData = sourceMediaObject.imageData;
        message.mediaObject = imageObject;
        message.thumbData = sourceMediaObject.thumbnailData;
        
        req.message = message;
    }
    else if (shareData.dataType == kShareDataTypeWebPage) {
        req.bText = NO;
        FWWebpageObject *sourceMediaObject = (FWWebpageObject *)shareData.mediaObject;
        
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = sourceMediaObject.title;
        message.description = sourceMediaObject.desc;
        message.thumbData = sourceMediaObject.thumbnailData;
        
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = sourceMediaObject.webpageUrl;
        message.mediaObject = ext;
        
        req.message = message;
    }
    else {
        req.bText = YES;
        req.text = shareData.text;
    }
    
    [WXApi sendReq:req];
}

- (void)shareContentToSinaWeibo:(FWShareData *)shareData
{
    WBMessageObject *message = [WBMessageObject message];
    
    if (shareData.dataType == kShareDataTypeText) {
        message.text = shareData.text;
    }
    else if (shareData.dataType == kShareDataTypeImage) {
        
        FWImageObject *sourceMediaObject = (FWImageObject *)shareData.mediaObject;
        message.text = shareData.text;
        WBImageObject *imageObject = [WBImageObject object];
        imageObject.imageData = sourceMediaObject.imageData;
        message.imageObject = imageObject;
    }
    else if (shareData.dataType == kShareDataTypeWebPage) {
        
        FWWebpageObject *sourceMediaObject = (FWWebpageObject *)shareData.mediaObject;
        message.text = [NSString stringWithFormat:@"%@ %@", sourceMediaObject.title, sourceMediaObject.desc];
        WBWebpageObject *webpage = [WBWebpageObject object];
        if (!webpage.objectID) {
            webpage.objectID = @"weiboDataId";
        }
        else {
            webpage.objectID = sourceMediaObject.objectID;
        }
        webpage.title = sourceMediaObject.title;
        webpage.description = sourceMediaObject.desc;
        webpage.thumbnailData = sourceMediaObject.thumbnailData;
        webpage.webpageUrl = sourceMediaObject.webpageUrl;
        message.mediaObject = webpage;
    }
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
    request.userInfo = @{@"ShareMessageFrom": @"FWShareManager",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         };
    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    
    [WeiboSDK sendRequest:request];
}

- (void)showAlertViewMessage:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
    alertView.tag = kAlertViewTagNotInstalled;
    
    [alertView show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kAlertViewTagNotInstalled) {
        if (buttonIndex == 0) {
            if (self.completionHandler) {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"message",@"未安装客户端", nil];
                NSError *error = [NSError errorWithDomain:FWShareErrorDomain code:-1 userInfo:userInfo];
                self.completionHandler(self.selectedSocialType, FWResponseStateFail, self.shareData, error);
            }
        }
    }
}


#pragma mark - YXApiDelegate

/*! @brief 易信SDK Delegate
 *
 * 接收来至易信客户端的事件消息，接收后唤起第三方App来处理。
 * 易信SDK会在handleOpenURL中根据消息回调YXApiDelegate的方法。
 */
- (void)onReceiveRequest: (YXBaseReq *)req
{
    
}
- (void)onReceiveResponse: (YXBaseResp *)resp
{
    if([resp isKindOfClass:[SendMessageToYXResp class]])
    {
        FWResponseState responseState;
        if (resp.code == kYXRespSuccess) {
            responseState = FWResponseStateSuccess;
        }
        else if (resp.code == kYXRespErrUserCancel) {
            responseState = FWResponseStateCancel;
        }
        else if (resp.code == kYXRespErrSentFail) {
            responseState = FWResponseStateFail;
        }
        else {
            responseState = FWResponseStateFail;
        }
        
        if (self.completionHandler) {
            self.completionHandler(self.selectedSocialType, responseState, self.shareData, nil);
        }
    }
}

#pragma mark - WXApiDelegate

-(void) onReq:(BaseReq*)req
{
}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        FWResponseState responseState;
        if (resp.errCode == WXSuccess) {
            responseState = FWResponseStateSuccess;
        }
        else if (resp.errCode == WXErrCodeUserCancel) {
            responseState = FWResponseStateCancel;
        }
        else if (resp.errCode == WXErrCodeSentFail) {
            responseState = FWResponseStateFail;
        }
        else {
            responseState = FWResponseStateFail;
        }
        
        if (self.completionHandler) {
            self.completionHandler(self.selectedSocialType, responseState, self.shareData, nil);
        }

    }
}

#pragma mark - WeiboSDKDelegate

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)resp
{
    if ([resp isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        FWResponseState responseState;
        if (resp.statusCode == WeiboSDKResponseStatusCodeSuccess) {
            responseState = FWResponseStateSuccess;
        }
        else if (resp.statusCode == WeiboSDKResponseStatusCodeUserCancel) {
            responseState = FWResponseStateCancel;
        }
        else if (resp.statusCode == WeiboSDKResponseStatusCodeSentFail) {
            responseState = FWResponseStateFail;
        }
        else {
            responseState = FWResponseStateFail;
        }
        
        if (self.completionHandler) {
            self.completionHandler(self.selectedSocialType, responseState, self.shareData, nil);
        }
    }
    else if ([resp isKindOfClass:WBAuthorizeResponse.class])
    {
        
    }
}

@end
