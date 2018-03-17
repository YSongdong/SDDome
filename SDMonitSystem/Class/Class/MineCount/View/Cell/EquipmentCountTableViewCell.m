//
//  EquipmentCountTableViewCell.m
//  SDMontir
//
//  Created by tiao on 2018/1/16.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "EquipmentCountTableViewCell.h"

#import "SymbolsValueFormatter.h"
#import "DateValueFormatter.h"
#import "SetValueFormatter.h"

@import Charts;
@interface EquipmentCountTableViewCell ()<ChartViewDelegate>

@property (nonatomic,strong) LineChartView * lineView;
@property (nonatomic,strong) UILabel * markY;

@end


@implementation EquipmentCountTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initlineView];
    
}
- (UILabel *)markY{
    if (!_markY) {
        _markY = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 35, 25)];
        _markY.font = [UIFont systemFontOfSize:13.0];
        _markY.textAlignment = NSTextAlignmentCenter;
        _markY.text =@"";
        _markY.textColor = [UIColor whiteColor];
        _markY.backgroundColor = [UIColor grayColor];
    }
    return _markY;
}
- (void )initlineView {
    self.lineView = [[LineChartView alloc] initWithFrame:CGRectMake(0, 40, KScreenW, self.frame.size.height-20)];
    
     [self addSubview:self.lineView];
    
    self.lineView.delegate = self;//设置代理
    self.lineView.backgroundColor =  [UIColor whiteColor];
    self.lineView.noDataText = @"暂无数据";
    self.lineView.chartDescription.enabled = YES;
    self.lineView.scaleYEnabled = NO;//取消Y轴缩放
    self.lineView.doubleTapToZoomEnabled = NO;//取消双击缩放
    self.lineView.dragEnabled = YES;//启用拖拽图标
    self.lineView.dragDecelerationEnabled = YES;//拖拽后是否有惯性效果
    self.lineView.dragDecelerationFrictionCoef = 0.9;//拖拽后惯性效果的摩擦系数(0~1)，数值越小，惯性越不明显
    [self.lineView setScaleEnabled:YES];
    self.lineView.drawGridBackgroundEnabled = NO;
    _lineView.legend.enabled = YES;//是否启用标注栏
    
    //设置滑动时候标签
    ChartMarkerView *markerY = [[ChartMarkerView alloc] init];
    markerY.offset = CGPointMake(-999, -8);
    markerY.chartView = _lineView;
    self.lineView.marker = markerY;
    [markerY addSubview:self.markY];
    
    self.lineView.rightAxis.enabled = NO;//不绘制右边轴
    ChartYAxis *leftAxis = _lineView.leftAxis;//获取左边Y轴
    leftAxis.labelCount = 5 ;//Y轴label数量，数值不一定，如果forceLabelsEnabled等于YES, 则强制绘制制定数量的label, 但是可能不平均
    leftAxis.forceLabelsEnabled = NO;//不强制绘制指定数量的label
    leftAxis.axisMinValue = 0;//设置Y轴的最小值
    //leftAxis.axisMaxValue = 105;//设置Y轴的最大值
    leftAxis.inverted = NO;//是否将Y轴进行上下翻转
    leftAxis.axisLineColor = [UIColor clearColor];//Y轴颜色
    leftAxis.valueFormatter = [[SymbolsValueFormatter alloc]init];
    leftAxis.labelPosition = YAxisLabelPositionOutsideChart;//label位置
    leftAxis.labelTextColor = [UIColor colorWithHexString:@"#7F7F7F"];//文字颜色
    leftAxis.labelFont = [UIFont systemFontOfSize:10.0f];//文字字体
    leftAxis.gridColor = [UIColor grayColor];//网格线颜色
    leftAxis.gridAntialiasEnabled = NO;//开启抗锯齿
    leftAxis.drawZeroLineEnabled = NO;
    leftAxis.drawLimitLinesBehindDataEnabled = NO;
    
    ChartXAxis *xAxis = _lineView.xAxis;
    xAxis.granularityEnabled = YES;//设置重复的值不显示
    xAxis.labelPosition= XAxisLabelPositionBottom;//设置x轴数据在底部
    xAxis.gridColor = [UIColor clearColor];
    xAxis.labelTextColor = [UIColor colorWithHexString:@"#7F7F7F"];//文字颜色
    xAxis.axisLineColor = [UIColor grayColor];
    xAxis.labelFont = [UIFont systemFontOfSize:10];
    
    self.lineView.maxVisibleCount = 999;//
    //描述及图例样式
    [self.lineView setDescriptionText:@""];
    self.lineView.legend.enabled = NO;
    
    [self.lineView animateWithXAxisDuration:1.0f];
   
}
- (void)setData:(NSArray *)dataArr colorArr:(NSArray *)colorArr{
    
    NSArray *arr =dataArr[0];
    
    //X轴上面需要显示的数据
    self.lineView.xAxis.valueFormatter = [[DateValueFormatter alloc]initWithArr:arr[1]];
    
    //Y轴对应数据
    NSArray *arrY = arr[0];

    //对应Y轴上面需要显示的数据
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    for (int i = 0; i < arrY.count; i++) {
        int a = [arrY[i] intValue];
        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:a];
        [yVals addObject:entry];
    }
    
    LineChartDataSet *set1 = nil;
    if (_lineView.data.dataSetCount > 0) {

        set1 = (LineChartDataSet *)_lineView.data.dataSets[0];
        set1.values = yVals;
        [_lineView.data notifyDataChanged];
        [_lineView notifyDataSetChanged];
     
    }else{
        
        //创建LineChartDataSet对象
        set1 = [[LineChartDataSet alloc]initWithValues:yVals label:@"DataSet 1"];
        //设置折线的样式
        set1.lineWidth = 2.0/[UIScreen mainScreen].scale;//折线宽度
        set1.drawValuesEnabled = YES;//是否在拐点处显示数据
        set1.valueFormatter = [[SetValueFormatter alloc]initWithArr:yVals];
        
        set1.valueColors = @[[UIColor brownColor]];//折线拐点处显示数据的颜色
        
        [set1 setColor:[UIColor greenColor]];//折线颜色
        set1.highlightColor = [UIColor redColor];
        set1.drawSteppedEnabled = NO;//是否开启绘制阶梯样式的折线图
        //折线拐点样式
        set1.drawCirclesEnabled = NO;//是否绘制拐点
        set1.drawFilledEnabled = NO;//是否填充颜色
        set1.formSize = 15;
        
        //将 LineChartDataSet 对象放入数组中
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        //创建 LineChartData 对象, 此对象就是lineChartView需要最终数据对象
        LineChartData *data = [[LineChartData alloc]initWithDataSets:dataSets];
        
        [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.f]];//文字字体
        [data setValueTextColor:[UIColor blackColor]];//文字颜色

        self.lineView.data = data;
    }
}
- (void)chartValueSelected:(ChartViewBase * _Nonnull)chartView entry:(ChartDataEntry * _Nonnull)entry highlight:(ChartHighlight * _Nonnull)highlight {
    
    _markY.text = [NSString stringWithFormat:@"%d",(int)entry.y];
    //将点击的数据滑动到中间
    [_lineView centerViewToAnimatedWithXValue:entry.x yValue:entry.y axis:[_lineView.data getDataSetByIndex:highlight.dataSetIndex].axisDependency duration:1.0];
}
- (void)chartValueNothingSelected:(ChartViewBase * _Nonnull)chartView {
    
}
-(void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    //未穿工作衣
    [colors addObject:[UIColor colorWithHexString:@"#ff5c5c"]];
    //未穿工作裤
    [colors addObject:[UIColor colorWithHexString:@"#dc72b8"]];
    //未戴安全帽
    [colors addObject:[UIColor colorWithHexString:@"#3fd7f4"]];
    //未穿工作鞋
    [colors addObject:[UIColor colorWithHexString:@"#ffb85c"]];
    //工作衣不规范
    [colors addObject:[UIColor colorWithHexString:@"#2b88b8"]];
    //工作裤不规范
    [colors addObject:[UIColor colorWithHexString:@"#2b88b8"]];
    //现场接打电话
    [colors addObject:[UIColor colorWithHexString:@"#2b88b8"]];
    //现场抽烟
    [colors addObject:[UIColor colorWithHexString:@"#2b88b8"]];
    
  
     [self setData:dataArr colorArr:colors.copy];
    
}




/*
-(void) createLine{
    
    self.lineView.layer.cornerRadius = 2;
    self.lineView.layer.masksToBounds = YES;
    

    self.sdLineChartView = [[SDLineChartView alloc]initWithFrame:CGRectMake(0, 10, KScreenW, 197)];
    
    [self.lineView addSubview:self.sdLineChartView];

    self.sdLineChartView.contentFillColorArr = @[[UIColor colorWithRed:208/255.0 green:244/255.0 blue:233/255.0 alpha:0.6],[UIColor colorWithRed:208/255.0 green:244/255.0 blue:233/255.0 alpha:0.6]];
    
}

-(void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    
    NSArray *arr = dataArr[0];

    //拿到下面的文字
    self.sdLineChartView.daysTitlesArr = arr[1];
    // 拿到数据
//    NSArray *daysArr =@[@"2",@"24",@"25",@"14",@"32",@"36",@"56",@"48"];
    self.sdLineChartView.daysArr = arr[2] ;

    [self.sdLineChartView creteLineUI];
}

*/
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
