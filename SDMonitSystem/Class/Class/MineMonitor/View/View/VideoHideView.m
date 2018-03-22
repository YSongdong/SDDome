//
//  VideoHideView.m
//  SDMonitSystem
//
//  Created by tiao on 2018/1/24.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "VideoHideView.h"

@interface  VideoHideView ()

@property (nonatomic ,strong) UIView *hideView;



@end

@implementation VideoHideView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self initHideView];
        
    }
    return self;
}
-(void) initHideView{
    
    __weak typeof(self) weakSelf = self;
    self.hideView = [[UIView alloc]init];
    [self addSubview:self.hideView];
    self.hideView.backgroundColor = [UIColor colorWithHexString:@"#292b2e"];
    [self.hideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.hideView addSubview:self.backBtn];
    [self.backBtn setImage:[UIImage imageNamed:@"back_wither"] forState:UIControlStateNormal];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.hideView).offset(10);
        make.left.equalTo(weakSelf.hideView).offset(10);
        make.width.height.equalTo(@40);
    }];
    [self.backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.hideLab = [[UILabel alloc]init];
    [self.hideView addSubview:self.hideLab];
    self.hideLab.textColor = [UIColor whiteColor];
    self.hideLab.textAlignment = NSTextAlignmentCenter;
    self.hideLab.numberOfLines = 2;
    self.hideLab.font = [UIFont systemFontOfSize:13];
    [self.hideLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_hideView).offset(10);
        make.right.equalTo(_hideView).offset(-10);
        make.centerX.equalTo(_hideView.mas_centerX);
        make.centerY.equalTo(_hideView.mas_centerY);
    }];
    
    self.palyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.hideView addSubview:self.palyBtn];
    [self.palyBtn setTitle:@"播放" forState:UIControlStateNormal];
    self.palyBtn.titleLabel.font =[UIFont systemFontOfSize:14];
    [self.palyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.palyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@80);
        make.height.equalTo(@30);
        make.top.equalTo(_hideLab.mas_bottom).offset(10);
        make.centerX.equalTo(_hideLab.mas_centerX);
    }];
    self.palyBtn.layer.cornerRadius = 15;
    self.palyBtn.layer.masksToBounds = YES;
    self.palyBtn.layer.borderWidth = 0.5;
    self.palyBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.palyBtn addTarget:self action:@selector(continueBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}
//继续播放
-(void)continueBtnAction:(UIButton *) sender{
    
    self.hideBlock();
}
//返回按钮
-(void)backBtnAction:(UIButton *) sender{
    
    self.backBlock();
    
}


@end
