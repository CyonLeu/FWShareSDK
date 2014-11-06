FWShareSDK
==========

# Destination feature
* custum shareView , share to social ,including Wechat, Yixin, SinaWeibo, TxWeibo

Demo effect:

![Alt text](http://nanny.netease.com/gzliuyong2014/fwsharesdk/raw/master/screenShot.png)

![Alt text](http://nanny.netease.com/gzliuyong2014/fwsharesdk/raw/master/shareScreenShot.gif)

 
 
# How to use FWSharSDK 
 
ADD to you Podfile the line: 

	pod 'FWShareSDK', :podspec => 'http://nanny.netease.com/gzliuyong2014/fwsharesdk/raw/master/FWShareSDK.podspec'


### You can see FWShareSDKDemo 

	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
	{   
 	   //初始化分享视图
 	   [self initShareView];
   		return YES;
	}

#### step 1 注册
    
    [FWShareManager setYiXinAPPKey:YX_APPID];
    [FWShareManager setWeChatAPPKey:WX_APPID withDescription:nil];
    [FWShareManager setSinaWeiboAPPKey:SINA_WEIBO_APPID];

#### step 2 设置图标显示大小，列等
    
    [[FWShareManager sharedManager] setShareTitle:@"分享到"];
    [[FWShareManager sharedManager] setShareItemSize:CGSizeMake(70, 70) titleHeight:20 itemColumn:4];


#### step 3 添加图标和标题
    
    [FWShareManager initSocialTypes:@[[NSNumber numberWithInt:kSocialSNSTypeYixinSession],
                                     [NSNumber numberWithInt:kSocialSNSTypeYixinTimeLine],
                                     [NSNumber numberWithInt:kSocialSNSTypeWeChatSession],
                                     [NSNumber numberWithInt:kSocialSNSTypeWeChatTimeLine],
                                     [NSNumber numberWithInt:kSocialSNSTypeSinaWeibo]
                                     ]
                        itemTitles:@[@"易信好友",
                                     @"易信朋友圈",
                                     @"微信好友",
                                     @"微信朋友圈",
                                     @"新浪微博"]
                        iconImages:@[ [UIImage imageNamed:@"YixinIcon"],
                                      [UIImage imageNamed:@"YixinCircleIcon"],
                                      [UIImage imageNamed:@"WeChatIcon"],
                                      [UIImage imageNamed:@"WeChatCircleIcon"],
                                      [UIImage imageNamed:@"SinaWeiboIcon"]
                                      ]];
     
    
#### step 4 share content

	- (IBAction)onShareButton:(id)sender
    //step 4 显示视图并分享数据内容 
    FWShareData *shareData = [FWShareData message]; 
    shareData.dataType = kShareDataTypeText; 
    shareData.text = @"分享一个好玩的游戏信息"; 
    shareData.bText = YES; 
     
    [FWShareManager showShareViewFrom:self shareContent:shareData completionHandler:^(SocialSNSType socialType, FWResponseState reponseState, FWShareData *sourceShareData, NSError *error) { 
            [self completionHandlerShareSocialType:socialType reponseState:reponseState data:sourceShareData error:error]; 
    }]; 
     
	} 
 
 
## Handle OpenUrl 
 
* add function in appDelegate.m 
 
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation NS_AVAILABLE_IOS(4_2); // no equiv. notification. return NO if the application can't open for some reason 
{ 
    return [FWShareManager handleOpenURL:url]; 
} 
 
## Back APP after sharing （分享后返回应用）

在Project->Info -> URL Types (+)添加 URL Schemes
URL Schemes：appkey
注意，新浪微博为：wb+appkey ；如 wb2766074661
 

-- VISUAL --
