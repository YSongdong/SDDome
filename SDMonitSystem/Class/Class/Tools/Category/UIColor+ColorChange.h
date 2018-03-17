//
//  UIColor+ColorChange.h
//  PlayDemo
//
//  Created by tiao on 2018/1/12.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ColorChange)

+ (UIColor *) colorWithfdd000Color;

//导航栏背景色
+ (UIColor *) naviBackGroupColor;

//tabbar背景色
+ (UIColor*) tabBarItemTextColor;

//textfFeild背景色
+ (UIColor *)logintextFeildBackGrounpColor;

//登录按钮背景
+ (UIColor *)loginBtnBackGrounpColor;

//table背景色
+ (UIColor *)TableViewBackGrounpColor;
//线条颜色
+ (UIColor*) lineBackGrounpColor;

+ (UIColor *) colorWithHexString: (NSString *)color;
@end
