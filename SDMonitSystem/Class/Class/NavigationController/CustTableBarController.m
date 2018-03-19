//
//  CustTableBarController.m
//  SDMontir
//
//  Created by tiao on 2018/1/16.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "CustTableBarController.h"

#import "DetaViewController.h"
@interface CustTableBarController ()

@end

@implementation CustTableBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNaviBar];
  
}
-(BOOL)shouldAutorotate{
    
    if ([self.selectedViewController isKindOfClass:[DetaViewController class]]) {
        return YES;
    }
    return self.selectedViewController.shouldAutorotate;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    if ([self.selectedViewController isKindOfClass:[DetaViewController class]]) {
        return UIInterfaceOrientationMaskAll;
    }
    
    return self.selectedViewController.supportedInterfaceOrientations;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
//    if ([self.selectedViewController isKindOfClass:[ProDetaViewController class]]) {
//
//        return UIStatusBarStyleDefault;
//
//    }
    return UIStatusBarStyleLightContent;
}

//自定义UINavigationBar
-(void) customNaviBar{
    //获取所有的导航控制器
    NSArray *naviControllers=self.viewControllers;
    for (UINavigationController *navi in naviControllers) {
        //获取UINavigationBar
        UINavigationBar *naviBar=navi.navigationBar;

        //  [naviBar setBackgroundImage:[UIImage imageNamed:@"navi_bg.jpg"] forBarMetrics:UIBarMetricsDefault];
        
        [naviBar setBarTintColor:[UIColor  naviBackGroupColor]];
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
