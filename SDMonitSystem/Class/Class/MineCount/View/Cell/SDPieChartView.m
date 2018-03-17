//
//  SDPieChartView.m
//  ChartsDemo
//
//  Created by tiao on 2018/1/10.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "SDPieChartView.h"

#import "SDMonitSystem-Bridging-Header.h"

@interface SDPieChartView ()

@property (nonatomic,strong) PieChartView *chartView;

@end
@implementation SDPieChartView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createPieUI];
    }
    return self;
}
//创建UI
-(void) createPieUI{
    
    self.chartView = [[PieChartView alloc]initWithFrame:self.bounds];
    
    [self addSubview:self.chartView];
    
    [self createUI];
    
}
-(void) createUI{
    _chartView.usePercentValuesEnabled = YES;
    _chartView.drawSlicesUnderHoleEnabled = NO;
    _chartView.holeRadiusPercent = 0.58;
    _chartView.transparentCircleRadiusPercent = 0.61;
    _chartView.chartDescription.enabled = NO;
    [_chartView setExtraOffsetsWithLeft:2.f top:2.f right:2.f bottom:2.f];
    [_chartView setNeedsDisplay];
    _chartView.drawCenterTextEnabled = NO;
 
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSMutableAttributedString *centerText = [[NSMutableAttributedString alloc] initWithString:@"Charts\nby Daniel Cohen Gindi"];
    [centerText setAttributes:@{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:13.f],
     NSParagraphStyleAttributeName: paragraphStyle} range:NSMakeRange(0, centerText.length)];
    [centerText addAttributes:@{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f],
     NSForegroundColorAttributeName: UIColor.grayColor } range:NSMakeRange(10, centerText.length - 10)];
    [centerText addAttributes:@{  NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:11.f], NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f] } range:NSMakeRange(centerText.length - 19, 19)];
    _chartView.centerAttributedText = centerText;
    
    _chartView.drawHoleEnabled = NO;
    _chartView.rotationAngle = 0.0;
    _chartView.rotationEnabled = YES;
    _chartView.highlightPerTapEnabled = YES;
    
    _chartView.drawEntryLabelsEnabled = NO;
    
    ChartLegend *l = _chartView.legend;
    l.horizontalAlignment = ChartLegendHorizontalAlignmentLeft;
    l.verticalAlignment = ChartLegendVerticalAlignmentBottom;
    l.orientation = ChartLegendOrientationHorizontal;
    l.drawInside = NO;
    l.xEntrySpace = 7.0;
    l.yEntrySpace = 0.0;
    l.yOffset = 5.0;
    
    [_chartView animateWithXAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];
}

- (void)setDataCount:(NSInteger)count dataValues:(NSArray *)dataValue
{
   
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        double vale = [dataValue[i] doubleValue];
        [values addObject:[[PieChartDataEntry alloc] initWithValue:vale label:self.dataArr[i % self.dataArr.count] icon: nil]];
    }
    
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:values label:self.titleLab];
    
    dataSet.drawIconsEnabled = NO;
    
    //圆块之间的空隙
    dataSet.sliceSpace = 0;
    
    dataSet.iconsOffset = CGPointMake(0, 40);
    
    dataSet.colors = self.colorArr;
    
    PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
    
    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
    pFormatter.numberStyle = NSNumberFormatterPercentStyle;
    pFormatter.maximumFractionDigits = 1;
    pFormatter.multiplier = @1.f;
    pFormatter.percentSymbol = @" %";
    [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:pFormatter]];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.f]];
    [data setValueTextColor:UIColor.whiteColor];
    
    _chartView.data = data;
    [_chartView highlightValues:nil];
}
#pragma mark --- 懒加载
-(NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSArray array];
    }
    return _dataArr;
}
-(NSArray *)colorArr{
    if (!_colorArr) {
        _colorArr = [NSArray array];
    }
    return _colorArr;
    
}


@end
