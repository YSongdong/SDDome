//
//  BaseViewController.h
//  SDMontir
//
//  Created by tiao on 2018/1/19.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BaseViewController : UIViewController

- (void)customNaviItemTitle:(NSString *)title titleColor:(UIColor *)color;

- (void)customTabBarButtonimage:(NSString *)imageName target:(id)target action:(SEL)selector isLeft:(BOOL)isLeft;
@end
