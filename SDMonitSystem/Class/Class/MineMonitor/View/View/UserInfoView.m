//
//  UserInfoView.m
//  SDMontir
//
//  Created by tiao on 2018/1/19.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "UserInfoView.h"

@interface  UserInfoView ()
//头像
@property (nonatomic,strong) UIImageView *headerImage;
//名字
@property (nonatomic,strong) UILabel *nameLab;
//职称
@property (nonatomic,strong) UILabel *profeLab;
//项目
@property (nonatomic,strong) UILabel *workLab;

@end


@implementation UserInfoView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self =  [super initWithFrame:frame]) {
        
        [self layoutUI];
    }
    return self;
    
}

//创建UI
-(void) layoutUI{
    
    self.backgroundColor = [UIColor whiteColor];
    __weak typeof(self) weakSelf = self;
    
    //设置头像view
    self.headerImage = [[UIImageView alloc]init];
    [self addSubview:self.headerImage];
    [self.headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@80);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.mas_centerY).offset(-20);
    }];
    self.headerImage.layer.cornerRadius = 40;
    self.headerImage.layer.masksToBounds = YES;
    self.headerImage.image = [UIImage imageNamed:@"header"];
    self.headerImage.layer.borderWidth =5;
    self.headerImage.layer.borderColor = [UIColor colorWithHexString:@"#dcf4fe"].CGColor;
    
    //封面
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:[UserInfo obtainWithAvatars]] placeholderImage:[UIImage imageNamed:@"header"]options:SDWebImageRetryFailed];
    
    //名字
    self.nameLab = [[UILabel alloc]init];
    [self addSubview:self.nameLab];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerImage.mas_bottom).offset(20);
        make.centerX.equalTo(_headerImage.mas_centerX);
    }];
    self.nameLab.textColor =[UIColor colorWithHexString:@"#14baf7"];
    self.nameLab.font =[UIFont systemFontOfSize:20];
    self.nameLab.text = [UserInfo obtainWithRenname];
/*
    //中间线
    UIView *lineView = [[UIView alloc]init];
    [self addSubview:lineView];
    lineView.backgroundColor = [UIColor tabBarItemTextColor];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(KSIphonScreenH(15)));
        make.width.equalTo(@1);
        make.top.equalTo(weakSelf.nameLab.mas_bottom).offset(KSIphonScreenH(10));
        make.centerX.equalTo(weakSelf.nameLab.mas_centerX);
    }];

    //项目
    self.workLab = [[UILabel alloc]init];
    [self addSubview:self.workLab];
    [self.workLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lineView.mas_left).offset(-10);
        make.centerY.equalTo(lineView.mas_centerY);
    }];
    self.workLab.font = [UIFont systemFontOfSize:15];
    self.workLab.textColor = [UIColor tabBarItemTextColor];
    self.workLab.text = @"";

    //职称
    self.profeLab = [[UILabel alloc]init];
    [self addSubview:self.profeLab];
    [self.profeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineView.mas_right).offset(10);
        make.centerY.equalTo(lineView.mas_centerY);
    }];
    self.profeLab.textColor =[UIColor tabBarItemTextColor];
    self.profeLab.font = [UIFont systemFontOfSize:15];
    self.profeLab.text  = @"";
*/
}

//-(void)setDict:(NSDictionary *)dict{
//
//    _dict = dict;
//
//    //职位
//    self.profeLab.text = dict[@"position"];
//
//    //姓名
//    self.nameLab.text = [UserInfo obtainWithRenname];
//
//    //
//    self.workLab.text = dict[@"depart"];
//
//     //封面
//    [self.headerImage sd_setImageWithURL:[UserInfo obtainWithAvatars] placeholderImage:[UIImage imageNamed:@"header"]options:SDWebImageRetryFailed];
//
//}



@end
