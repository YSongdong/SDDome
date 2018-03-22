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
#import "DetaViewController.h"
#import "Reachability.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    //修改tabbarItem颜色
    [[UITabBar appearance] setTintColor:[UIColor tabBarItemTextColor]];
    
    [self setupRootView];
    
    //判断网络状态

    //注册通知，异步加载，判断网络连接情况
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [reachability startNotifier];
    
    return YES;
}

/**
 *此函数通过判断联网方式，通知给用户
 */
- (void)reachabilityChanged:(NSNotification *)notification
{
    Reachability *curReachability = [notification object];
    NSParameterAssert([curReachability isKindOfClass:[Reachability class]]);
    NetworkStatus curStatus = [curReachability currentReachabilityStatus];
    
    if(curStatus == NotReachable) {
        //没有网
        NSDictionary *dic = @{@"netwrok":@"NO"};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NetWorkStatu" object:nil userInfo:dic];
    }else  if(curStatus == ReachableViaWiFi) {
        //WIFI
        NSDictionary *dic = @{@"netwrok":@"WIFI"};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NetWorkStatu" object:nil userInfo:dic];
    }else if(curStatus == ReachableViaWWAN) {
        NSDictionary *dic = @{@"netwrok":@"GPRS"};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NetWorkStatu" object:nil userInfo:dic];
    }
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
