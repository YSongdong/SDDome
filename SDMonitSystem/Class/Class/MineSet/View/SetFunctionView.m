//
//  SetFunctionView.m
//  SDMonitSystem
//
//  Created by tiao on 2018/1/23.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "SetFunctionView.h"

@interface SetFunctionView ()


@end

@implementation SetFunctionView


-(instancetype)initWithFrame:(CGRect)frame leftImage:(NSString *)leftImage andTitle:(NSString*)title andTarget:(id)target andAction:(SEL)action andTag:(NSInteger)tag{
    if (self = [super initWithFrame:frame]) {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:backBtn];
        backBtn.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        backBtn.backgroundColor = [UIColor whiteColor];
        [backBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        backBtn.tag = tag;
        
        UIImage *image=[UIImage imageNamed:leftImage];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImageView *imageView =[[UIImageView alloc]init];
        [self addSubview:imageView];
        imageView.image = image;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@22);
            make.left.equalTo(backBtn).offset(34);
            make.centerY.equalTo(backBtn.mas_centerY);
        }];
        
        UILabel *lab = [[UILabel alloc]init];
        [self addSubview:lab];
        lab.textColor = [UIColor colorWithHexString:@"#555555"];
        lab.text = title;
        lab.font = [UIFont systemFontOfSize:15];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).offset(20);
            make.centerY.equalTo(imageView.mas_centerY);
        }];
        
        UIView *lineView = [[UIView alloc]init];
        [self addSubview:lineView];
        lineView.backgroundColor =[UIColor colorWithHexString:@"#eeeeee"];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@1);
            make.left.bottom.right.equalTo(backBtn);
        }];
    }
    return self;
}







@end
