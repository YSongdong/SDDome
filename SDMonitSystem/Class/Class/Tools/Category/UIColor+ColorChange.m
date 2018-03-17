//
//  UIColor+ColorChange.m
//  PlayDemo
//
//  Created by tiao on 2018/1/12.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "UIColor+ColorChange.h"

@implementation UIColor (ColorChange)


+ (UIColor *) colorWithfdd000Color
{
    
    return [UIColor colorWithHexString:@"#fdd000"];
    
}

//导航栏背景色
+ (UIColor *) naviBackGroupColor
{
    
    return [UIColor colorWithHexString:@"#373B3C"];
    
}
//tabbar背景色
+ (UIColor*) tabBarItemTextColor{
    
    return [UIColor colorWithHexString:@"#14B9F7"];
}
//textfFeild背景色
+ (UIColor*) logintextFeildBackGrounpColor{
    
    return [UIColor colorWithHexString:@"#efefef"];
}
//登录按钮背景
+ (UIColor *)loginBtnBackGrounpColor{
    
     return [UIColor colorWithHexString:@"#26beef"];
}
//线条颜色
+ (UIColor*) lineBackGrounpColor{
    
    return [UIColor colorWithHexString:@"#E2E2E2"];
}
//table背景色
+ (UIColor *)TableViewBackGrounpColor{
    return [UIColor colorWithHexString:@"#e2e2e2"];
}
+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
@end
