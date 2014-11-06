//
//  FWRightViewController.m
//  FWShareSDKDemo
//
//  Created by CyonLeu on 14-8-10.
//  Copyright (c) 2014年 FlyWire. All rights reserved.
//

#import "FWRightViewController.h"
#import "FWViewController.h"

#import "FWShareManager.h"
#import "WeiboSDK.h"

@interface FWRightViewController ()<UIAlertViewDelegate, WBHttpRequestDelegate>

@property (nonatomic, strong) NSString *token;

@end

@implementation FWRightViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >  7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(oncancel:)];
    
    [self.navigationItem setLeftBarButtonItem:cancelItem];
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onChange:)];
    
    [self.navigationItem setRightBarButtonItem:done];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onShare:(id)sender
{
    [FWShareManager showShareViewFrom:self
                         shareContent:nil
                    completionHandler:^(SocialSNSType socialType, FWResponseState responseState, FWShareData *sourceShareData, NSError *error) {
        //
    }];
}

- (IBAction)oncancel:(id)sender
{
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)onChange:(id)sender
{
    NSLog(@"onChange");
    self.view.backgroundColor = [UIColor yellowColor];
}

- (IBAction)showNext:(id)sender
{
    UIViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"rightview"];
    [self presentViewController:viewController animated:YES completion:^{
        
    }];
}

- (IBAction)showAlertView:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享" message:@"分享一段文本" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"share", nil];
    [alertView show];
}

- (IBAction)onPush:(id)sender
{
    UIViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"rightview"];
    
    [self.navigationController pushViewController:viewController animated:YES];
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        [self onShare:nil];
    }
}

- (IBAction)onWeiboLogin:(id)sender
{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = SINA_WEIBO_REDIRECTURI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

- (IBAction)onWeiboLogout:(id)sender
{
    //    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    [WeiboSDK logOutWithToken:self.token delegate:self withTag:@"user1"];
}

- (IBAction)onShareData:(id)sender
{
    
}

#pragma mark -  WBHttpRequestDelegate <NSObject>


- (void)request:(WBHttpRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    
}

/**
 收到一个来自微博Http请求失败的响应
 
 @param error 错误信息
 */
//@optional
- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error
{
    
}

/**
 收到一个来自微博Http请求的网络返回
 
 @param result 请求返回结果
 */
//@optional
- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    
}

/**
 收到一个来自微博Http请求的网络返回
 
 @param data 请求返回结果
 */
//@optional
- (void)request:(WBHttpRequest *)request didFinishLoadingWithDataResult:(NSData *)data
{
    
}


@end
