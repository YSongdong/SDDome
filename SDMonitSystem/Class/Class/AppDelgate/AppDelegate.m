//
//  AppDelegate.m
//  SDMonitSystem
//
//  Created by tiao on 2018/1/22.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "AppDelegate.h"

#import <AFNetworking/AFNetworking.h>

#import "LoginViewController.h"
#import "CustTableBarController.h"
#import "RootNaviController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    //修改tabbarItem颜色
    [[UITabBar appearance] setTintColor:[UIColor tabBarItemTextColor]];
    
    [self setupRootView];
    
    //判断网络状态
    [self monitorNetworking];

    return YES;
}
//进入程序
-(void) setupRootView{
    
    if ([UserInfo passLoginData]) {
       //否则直接进入应用
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CustTableBarController *custTabVC = [sb instantiateViewControllerWithIdentifier:@"CustTableBarController"];
        _window.rootViewController = custTabVC;

    }else{
        //登录界面
        LoginViewController *loginVC =[[LoginViewController alloc]init];
        RootNaviController *naviVC = [[RootNaviController alloc]initWithRootViewController:loginVC];
        _window.rootViewController = naviVC;
    }
}
//判断网络状态
- (void)monitorNetworking
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"NetWorkStatu" object:nil userInfo:@{@"netwrok":@"WIFI"}];
        }else if (status == AFNetworkReachabilityStatusReachableViaWWAN) {
            //GPRS网络
            [[NSNotificationCenter defaultCenter]postNotificationName:@"NetWorkStatu" object:nil userInfo:@{@"netwrok":@"GPRS"}];
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"NetWorkStatu" object:nil userInfo:@{@"netwrok":@"NO"}];
        }
        
    }];
}
- (void)applicationWillResignActive:(UIApplication *)application {
 
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
 
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
 
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
     
}


- (void)applicationWillTerminate:(UIApplication *)application {

}


@end
