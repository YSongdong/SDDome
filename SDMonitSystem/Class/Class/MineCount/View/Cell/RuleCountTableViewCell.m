//
//  RuleCountTableViewCell.m
//  SDMontir
//
//  Created by tiao on 2018/1/16.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "RuleCountTableViewCell.h"

#import "SDPieChartView.h"
#import "SDMonitSystem-Bridging-Header.h"


@interface RuleCountTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *pieView;

@property (nonatomic,strong)  SDPieChartView  *pieChartView;

@end

@implementation RuleCountTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self createPieChartView];
}
-(void) createPieChartView{
    
    self.pieView.layer.cornerRadius = 2;
    self.pieView.layer.masksToBounds = YES;

    self.pieChartView = [[SDPieChartView alloc]initWithFrame:CGRectMake(0, 40,KScreenW ,self.frame.size.height)];
    
    self.pieChartView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.pieChartView];
    
}
-(void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    
    
    
    NSArray *arr = dataArr[0];
    
    //违规类型
    NSArray *parties = arr[1];
    
    //百分比
    NSArray *percenArr = arr[2];
    
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    //未穿工作衣
    [colors addObject:[UIColor colorWithHexString:@"#8bad49"]];
    //未穿工作裤
    [colors addObject:[UIColor colorWithHexString:@"#dcc912"]];
    //未戴安全帽
    [colors addObject:[UIColor colorWithHexString:@"#7f8eac"]];
    //未穿工作鞋
    [colors addObject:[UIColor colorWithHexString:@"#d26e77"]];
    //工作衣不规范
    [colors addObject:[UIColor colorWithHexString:@"#ffad77"]];
    //工作裤不规范
    [colors addObject:[UIColor colorWithHexString:@"#52a6e1"]];
    //现场接打电话
    [colors addObject:[UIColor colorWithHexString:@"#9c9fe1"]];
    //现场抽烟
    [colors addObject:[UIColor colorWithHexString:@"#2eb2b9"]];
    
    self.pieChartView.dataArr =parties;
    self.pieChartView.colorArr =colors;
    [self.pieChartView setDataCount:parties.count dataValues:percenArr];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
