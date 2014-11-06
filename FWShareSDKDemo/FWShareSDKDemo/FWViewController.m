//
//  FWViewController.m
//  FWShareSDKDemo
//
//  Created by Liuyong on 14-8-8.
//  Copyright (c) 2014年 FlyWire. All rights reserved.
//

#import "FWViewController.h"
#import "FWShareView.h"
#import "FWShareManager.h"
#import "FWRightViewController.h"

@interface FWViewController ()


@end

@implementation FWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    self.view.backgroundColor = [UIColor blueColor];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >  7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
   
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onShareButton:(id)sender
{
    
    //step 4 显示视图并分享数据内容
    FWShareData *shareData = [FWShareData message];
    shareData.dataType = kShareDataTypeText;
    shareData.text = @"分享一个好玩的游戏信息";
    shareData.bText = YES;
    
    [FWShareManager showShareViewFrom:self shareContent:shareData completionHandler:^(SocialSNSType socialType, FWResponseState responseState, FWShareData *sourceShareData, NSError *error) {
            [self completionHandlerShareSocialType:socialType responseState:responseState data:sourceShareData error:error];
    }];
    
}



- (IBAction)showRightView
{
    UIViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"rightview"];
    
    UINavigationController *nvController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    [self presentViewController:nvController animated:YES completion:^{
        //
    }];
}

- (IBAction)showNext:(id)sender
{
    UIViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"rightview"];
    [self presentViewController:viewController animated:YES completion:^{
        
    }];
}
- (IBAction)onPush:(id)sender
{
    UIViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"mainVC"];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

/**
 *  分享纯文本消息
 *
 *  @param sender sender description
 */
- (IBAction)shareText:(id)sender
{
    //step 4 显示视图并分享数据内容
    FWShareData *shareData = [FWShareData message];
    shareData.dataType = kShareDataTypeText;
    shareData.text = @"分享一个好玩的游戏信息";
    shareData.bText = YES;
    
    [FWShareManager showShareViewFrom:self shareContent:shareData completionHandler:^(SocialSNSType socialType, FWResponseState responseState, FWShareData *sourceShareData, NSError *error) {
        
        [self completionHandlerShareSocialType:socialType responseState:responseState data:sourceShareData error:error];
    }];
}

/**
 *  分享图片信息，可包含文本
 *
 *  @param sender sender description
 */
- (IBAction)shareImageMessage:(id)sender
{
    //step 4 显示视图并分享数据内容
    FWShareData *shareData = [FWShareData message];
    shareData.dataType = kShareDataTypeImage;
    shareData.text = @"分享一个好玩的游戏信息";
    shareData.bText = NO;
    
    FWImageObject *imageObject = [FWImageObject object];
    imageObject.imageData = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"share" ofType:@"jpg"]];
    imageObject.thumbnailData = UIImageJPEGRepresentation([UIImage imageNamed:@"icon58x58"], 1.0);
    shareData.mediaObject = imageObject;
    
    [FWShareManager showShareViewFrom:self shareContent:shareData completionHandler:^(SocialSNSType socialType, FWResponseState responseState, FWShareData *sourceShareData, NSError *error) {
        
        [self completionHandlerShareSocialType:socialType responseState:responseState data:sourceShareData error:error];

    }];
}

/**
 *  分享多媒体信息，webpage
 *
 *  @param sender sender description
 */
- (IBAction)shareWebpage:(id)sender
{
    //step 4 显示视图并分享数据内容
    FWShareData *shareData = [FWShareData message];
    shareData.dataType = kShareDataTypeWebPage;
    shareData.text = @"分享一个好玩的游戏信息";
    shareData.bText = NO;
    
    FWWebpageObject *mediaObject = [FWWebpageObject object];
    mediaObject.title = @"好玩的游戏";
    mediaObject.desc = @"这个游戏很经典，小伙伴快来跟我一起玩吧。";
    mediaObject.thumbnailData = UIImageJPEGRepresentation([UIImage imageNamed:@"menubg"], 1);
    mediaObject.webpageUrl = @"http://nie.163.com";
    
    shareData.mediaObject = mediaObject;
    
    [FWShareManager showShareViewFrom:self shareContent:shareData completionHandler:^(SocialSNSType socialType, FWResponseState responseState, FWShareData *sourceShareData, NSError *error) {
        [self completionHandlerShareSocialType:socialType responseState:responseState data:sourceShareData error:error];
            }];
}

- (void)completionHandlerShareSocialType:(SocialSNSType)socialType
                            responseState:(FWResponseState)responseState
                                    data:(FWShareData *)shareData
                                   error:(NSError *)error
{
    if (socialType == kSocialSNSTypeNone) {
        //说明什么也没选择，取消；此时 responseState =FWResponseStateCancel
        NSLog(@"没有选择分享到社交网络，取消");
    }
    
    NSLog(@"error:%@", error);
    
    if (responseState == FWResponseStateBegan) {
        NSLog(@"分享开始");
    }
    else if (responseState == FWResponseStateSuccess) {
        NSLog(@"分享成功");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"分享成功" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alertView show];
    }
    else if (responseState == FWResponseStateFail) {
        NSLog(@"分享失败");
    }
    else if (responseState == FWResponseStateCancel) {
        NSLog(@"分享取消");
    }
    

}

@end
