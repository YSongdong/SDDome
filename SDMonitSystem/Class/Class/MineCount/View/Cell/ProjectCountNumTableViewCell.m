//
//  ProjectCountNumTableViewCell.m
//  SDMontir
//
//  Created by tiao on 2018/1/16.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "ProjectCountNumTableViewCell.h"


@interface  ProjectCountNumTableViewCell ()

//设备数量
@property (weak, nonatomic) IBOutlet UILabel *equipmentCountLab;
//违规次数
@property (weak, nonatomic) IBOutlet UILabel *ruleCountLab;
//btnview
@property (weak, nonatomic) IBOutlet UIView *showBtnView;

@property (nonatomic,assign) NSInteger pageTag;

@property (nonatomic,assign) BOOL isSelectd;
@end

@implementation ProjectCountNumTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.pageTag  = 0 ;
    self.isSelectd =NO;
    [self initViewUI];
}
-(void) initViewUI{
    
    NSArray *arr = @[@"自定义",@"7天",@"本周",@"本月"];
    for (int i=0; i<4; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10+i*(KScreenW/4-20)+i*10, (self.showBtnView.frame.size.height-26)/2, KScreenW/4-20, 26)];
        [self.showBtnView addSubview:btn];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        btn.titleLabel.font =[UIFont systemFontOfSize:15];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor tabBarItemTextColor] forState:UIControlStateSelected];
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = [UIColor tabBarItemTextColor].CGColor;
        
        btn.tag = 100+i;
        btn.layer.cornerRadius = 13;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];

    }
}
-(void)btnAction:(UIButton *)sender{
   
    //第一次点击btn
    if (self.pageTag == 0) {
        //新的btn
        sender.selected = YES;
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        sender.backgroundColor = [UIColor tabBarItemTextColor];
        self.pageTag = sender.tag;

    }else{

        UIButton *oldBtn = [self viewWithTag:self.pageTag];
        oldBtn.selected = NO;
        [oldBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        oldBtn.backgroundColor  =[UIColor whiteColor];

        //新的btn
        sender.selected = YES;
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        sender.backgroundColor = [UIColor tabBarItemTextColor];
        self.pageTag = sender.tag;
    }
    self.headerViewBlock(sender);
}
// 取消选中状态
-(void)cancelSelectaStuta{
    
    if (self.pageTag != 0) {
        UIButton *oldBtn = [self viewWithTag:self.pageTag];
        oldBtn.selected = NO;
        [oldBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        oldBtn.backgroundColor  =[UIColor whiteColor];
    }
}

-(void)setData:(NSDictionary *)data{
    _data =data;
    
    double prNum = [data[@"violat"] integerValue];
    double devices = [data[@"devices"] integerValue];
    //设备数量
    self.equipmentCountLab.text = [NSString stringWithFormat:@"%.f台",devices];
 
    self.ruleCountLab.text = [NSString stringWithFormat:@"%.f次",prNum];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
