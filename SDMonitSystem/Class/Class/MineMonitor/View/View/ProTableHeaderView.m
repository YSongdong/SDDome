//
//  ProTableHeaderView.m
//  SDMontir
//
//  Created by tiao on 2018/1/19.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "ProTableHeaderView.h"

@interface  ProTableHeaderView ()



@end

@implementation ProTableHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
    
}
-(void) createUI{
    self.backgroundColor =[UIColor whiteColor];
    __weak typeof(self) weakSelf = self;
    
    
    UIView *lineView=[[UIView alloc]init];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(17);
        make.width.equalTo(@2);
        make.top.equalTo(weakSelf).offset(11);
        make.bottom.equalTo(weakSelf).offset(-11);
    }];
    lineView.backgroundColor =[UIColor colorWithHexString:@"#333333"];
    
    UILabel *lab =[[UILabel alloc]init];
    [self addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineView.mas_right).offset(5);
        make.centerY.equalTo(lineView.mas_centerY);
    }];
    lab.textColor = [UIColor colorWithHexString:@"#333333"];
    lab.text =@"违规记录";
    lab.font =[UIFont systemFontOfSize:15];
    
    UIView *lView =[[UIView alloc]init];
    [self addSubview:lView];
    lView.backgroundColor = [UIColor lineBackGrounpColor];
    [lView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5);
        make.left.bottom.right.equalTo(weakSelf);
    }];
    
}


@end
