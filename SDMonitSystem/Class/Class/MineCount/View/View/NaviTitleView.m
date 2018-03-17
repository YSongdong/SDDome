//
//  NaviTitleView.m
//  SDMonitSystem
//
//  Created by tiao on 2018/1/25.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "NaviTitleView.h"

@implementation NaviTitleView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self initViewUI];
    }
    return self;
    
}

-(void) initViewUI{
    
    __weak typeof(self) weakSelf = self;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(weakSelf);
    }];
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(selectEquiBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *titleLab = [[UILabel alloc]init];
    [self addSubview:titleLab];
    titleLab.text = @"项目统计";
    titleLab.textColor = [UIColor whiteColor];
    titleLab.font = [UIFont systemFontOfSize:13];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(5);
        make.centerX.equalTo(weakSelf.mas_centerX);
    }];
    
    self.equiNameLab = [[UILabel alloc]init];
    [weakSelf addSubview:self.equiNameLab];
    self.equiNameLab.textColor = [UIColor whiteColor];
    
//    //保存第一个项目
//    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
//    if ([userD objectForKey:@"project"]) {
//         NSDictionary *dict = [userD objectForKey:@"project"];
//         self.equiNameLab.text = dict[@"name"];
//    }
    self.equiNameLab.textAlignment = NSTextAlignmentRight;
    self.equiNameLab.font = [UIFont systemFontOfSize:10];
    [self.equiNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf).offset(-5);
        make.centerX.equalTo(titleLab.mas_centerX);
    }];
    
    UIImageView *image =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"count_down"]];
    [self addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@15);
        make.centerY.equalTo(weakSelf.equiNameLab.mas_centerY);
        make.left.equalTo(weakSelf.equiNameLab.mas_right).offset(2);
    }];
}

-(void)selectEquiBtnAction:(UIButton *) sender{
    sender.selected = !sender.selected;
    
    self.titleViewBlock(sender);
    
}
// 图文混排
-(NSMutableAttributedString *) attributeString:(NSString *)str{
    
     NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, 2)];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, 2)];
    // 创建图片图片附件
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:@"count_down"];
    attach.bounds = CGRectMake(0, 0, 20, 20);
    
    NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];

    [string appendAttributedString:attachString];
    
    return string;
}






@end
