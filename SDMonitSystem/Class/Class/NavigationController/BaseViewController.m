//
//  BaseViewController.m
//  SDMontir
//
//  Created by tiao on 2018/1/19.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController () <UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIPercentDrivenInteractiveTransition *interactiveTransition;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.interactivePopGestureRecognizer.delegate = self;

}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.childViewControllers.count == 1) {
        return NO;
    }else{
        return YES;
    }
}
-(BOOL)shouldAutorotate{
    
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskPortrait;
}

- (void)customNaviItemTitle:(NSString *)title titleColor:(UIColor *)color
{
    // 定制UINavigationItem的titleView
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor =color;
    // 设置文字
    titleLabel.text = title;
    
    // 设置导航项的标题视图
    self.navigationItem.titleView = titleLabel;
}

- (void)customTabBarButtonimage:(NSString *)imageName target:(id)target action:(SEL)selector isLeft:(BOOL)isLeft
{
    UIImage *image=[UIImage imageNamed:imageName];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    UIImageView *imageView =[[UIImageView alloc]initWithImage:image];
    //    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setImage:image forState:UIControlStateNormal];
    // [button setBackgroundImage:imageView.image forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchDown];
    button.frame = CGRectMake(0, 0, 21, 21);
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    
    // 判断是否为左侧按钮
    UIBarButtonItem * buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    if (isLeft) {
        self.navigationItem.leftBarButtonItem = buttonItem;
    }
    else {
        self.navigationItem.rightBarButtonItem = buttonItem;
    }
}



@end
