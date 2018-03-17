//
//  ShowSpaceView.m
//  SDMonitSystem
//
//  Created by tiao on 2018/2/8.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "ShowSpaceView.h"

@implementation ShowSpaceView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self initView];
        
    }
    return self;
    
}
-(void) initView{
    
    __weak typeof(self) weakSelf =self;
    
    self.backgroundColor = [UIColor lineBackGrounpColor];
    
    
    UIImageView *imageV =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"unData"]];
    [self addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    
    
    UILabel *lab = [[UILabel alloc]init];
    [self addSubview:lab];
    
    self.lab = lab;
    
    lab.textColor =[UIColor blackColor];
    lab.font = [UIFont systemFontOfSize:14];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageV.mas_bottom).offset(20);
        make.centerX.equalTo(imageV.mas_centerX);
    }];

}





@end
