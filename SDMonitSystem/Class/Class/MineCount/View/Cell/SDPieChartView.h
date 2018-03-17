//
//  SDPieChartView.h
//  ChartsDemo
//
//  Created by tiao on 2018/1/10.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDPieChartView : UIView

//数据源个数组
@property (nonatomic,strong) NSArray *dataArr;
//颜色数组
@property (nonatomic,strong) NSArray *colorArr;
//总汇标题
@property (nonatomic,strong) NSString *titleLab;

- (void)setDataCount:(NSInteger)count dataValues:(NSArray *)dataValue;
@end
