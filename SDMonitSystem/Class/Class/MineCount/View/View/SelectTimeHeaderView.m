//
//  SelectTimeHeaderView.m
//  SDMonitSystem
//
//  Created by tiao on 2018/1/25.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "SelectTimeHeaderView.h"

@interface SelectTimeHeaderView ()

@property (nonatomic,assign) NSInteger pageTag;

@end

@implementation SelectTimeHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self  = [super initWithFrame:frame]) {
        
        [self initViewUI];
    }
    return self;
}

-(void) initViewUI{
    
    NSArray *arr = @[@"自定义",@"7天",@"本周",@"本月"];
    for (int i=0; i<4; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10+i*70+i*10, (self.frame.size.height-20)/2, 70, 20)];
        [self addSubview:btn];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        btn.titleLabel.font =[UIFont systemFontOfSize:15];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor tabBarItemTextColor] forState:UIControlStateSelected];
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = [UIColor tabBarItemTextColor].CGColor;
        
        btn.tag = 100+i;
        btn.layer.cornerRadius = 10;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            btn.selected =YES;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            btn.backgroundColor = [UIColor tabBarItemTextColor];
            self.pageTag = btn.tag;
        }
        
    }
    
}

-(void)btnAction:(UIButton *)sender{
  
    UIButton *oldBtn = [self viewWithTag:self.pageTag];
    oldBtn.selected = NO;
    [oldBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    oldBtn.backgroundColor  =[UIColor whiteColor];
    
    //新的btn
    sender.selected = YES;
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    sender.backgroundColor = [UIColor tabBarItemTextColor];
    self.pageTag = sender.tag;
    
    sender.selected = !sender.selected;
    self.headerViewBlock(sender.selected);
}
-(void)selectdShowTime:(NSDictionary *)dict{
    NSString *begin = dict[@"begin"];
    NSString *end = dict[@"end"];
    
    NSString *timeStr = [NSString stringWithFormat:@"%@至%@",begin,end];
    
    UIButton *selectBtn = [self viewWithTag:103];

    dispatch_async(dispatch_get_main_queue(), ^{
         [selectBtn setTitle:timeStr forState:UIControlStateSelected];
    });
   
   
    
   
    
}




@end
