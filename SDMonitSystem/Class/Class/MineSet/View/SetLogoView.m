//
//  SetLogoView.m
//  SDMonitSystem
//
//  Created by tiao on 2018/1/23.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "SetLogoView.h"

@interface SetLogoView ()
@property (nonatomic,strong) UIScrollView *scrollView;
//背景view
@property (nonatomic,strong) UIView *bigBackGrounpView;
@end

@implementation SetLogoView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self initViewUI];
    }
    return self;
}

-(void)initViewUI{
    
    self.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    
    UIImageView *logoImage = [[UIImageView alloc]init];
    [self addSubview:logoImage];
    logoImage.image =[UIImage imageNamed:@"logo"];
    [logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(KSIphonScreenW(90)));
        make.center.equalTo(self);
    }];
    logoImage.layer.cornerRadius = KSIphonScreenW(45);
    logoImage.layer.masksToBounds = YES;
    
    UILabel *lab = [[UILabel alloc]init];
    [self addSubview:lab];
    lab.textColor = [UIColor tabBarItemTextColor];
    lab.font = [UIFont systemFontOfSize:17];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoImage.mas_bottom).offset(KSIphonScreenH(15));
        make.centerX.equalTo(logoImage.mas_centerX);
    }];
    //获取本地软件的版本号
    NSString *localVersion =  [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    lab.text = [NSString stringWithFormat:@"云时际V%@",localVersion];
}


@end
