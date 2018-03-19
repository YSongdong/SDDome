//
//  RootNaviController.m
//  SDMonitSystem
//
//  Created by tiao on 2018/1/22.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "RootNaviController.h"

#import "DetaViewController.h"
@interface RootNaviController () 

@end

@implementation RootNaviController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
-(BOOL)shouldAutorotate{
    
    if ([self.topViewController isKindOfClass:[DetaViewController class]]) {
        return YES;
    }
    return self.topViewController.shouldAutorotate;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    if ([self.topViewController isKindOfClass:[DetaViewController class]]) {
        return UIInterfaceOrientationMaskAll;
    }
    
    return self.topViewController.supportedInterfaceOrientations;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
//    if ([self.topViewController isKindOfClass:[ProDetaViewController class]]) {
//        
//         return UIStatusBarStyleDefault;
//    }
    return UIStatusBarStyleLightContent;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //去除导航栏下方的横线
   // [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
