//
//  FWAppDelegate.m
//  FWShareSDKDemo
//
//  Created by Liuyong on 14-8-8.
//  Copyright (c) 2014年 FlyWire. All rights reserved.
//

#import "FWAppDelegate.h"
#import "FWShareManager.h"

#define YX_APPID @"yxecf821e0b29842e991eb4da9b03e215f"
#define WX_APPID @"wx0079f5a083063f4b"

#define SINA_WEIBO_APPID @"2045436852"
#define SINA_WEIBO_REDIRECTURI @"http://www.sina.com"

#define TENCENT_WEIBO_APPKEY     @"801532006"
#define TENCENT_WEIBO_APPSECRET  @"01b678e4e022e91d4061a8d86cb9f300"
#define TENCENT_WEIBO_REDIRECTURI             @"http://www.cyonleu.com/"

@implementation FWAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
   
    //初始化分享视图
    
    [self initShareView];
    
     UIViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"mainVC"];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation NS_AVAILABLE_IOS(4_2); // no equiv. notification. return NO if the application can't open for some reason
{
    return [FWShareManager handleOpenURL:url];
}

/**
 *  @brief  init share view item
 */
- (void)initShareView
{
    //初始化工作---------------------begin--------------------
    
    //step 1 注册
    
    [FWShareManager setYiXinAPPKey:YX_APPID];
    [FWShareManager setWeChatAPPKey:WX_APPID withDescription:nil];
    [FWShareManager setSinaWeiboAPPKey:SINA_WEIBO_APPID];
    
    //step 2 设置图标显示大小，列等
    
    [[FWShareManager sharedManager] setShareTitle:@"分享到"];
    [[FWShareManager sharedManager] setShareItemSize:CGSizeMake(70, 70) titleHeight:20 itemColumn:4];
    
    //step 3 添加图标和标题
    
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
    
    //初始化工作---------------------end--------------------
}

@end
