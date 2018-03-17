//
//  ShowCalenarView.m
//  SDMonitSystem
//
//  Created by tiao on 2018/1/26.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "ShowCalenarView.h"

#import "FSCalendar.h"
#import "RangePickerCell.h"

@interface ShowCalenarView ()
<FSCalendarDelegate,
FSCalendarDataSource,
FSCalendarDelegateAppearance
>

@property (nonatomic,strong) FSCalendar *calendar;
@property (strong, nonatomic) NSCalendar *gregorian;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
// The start date of the range
@property (strong, nonatomic) NSDate *date1;
// The end date of the range
@property (strong, nonatomic) NSDate *date2;
//确定按钮
@property (nonatomic,strong) UIButton *tureBtn;
@end


@implementation ShowCalenarView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initCalendarView];
    }
    return self;
}

-(void) initCalendarView{
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, self.frame.size.height)];
    [self addSubview:backView];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.5;
    
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectdTap)];
    [backView addGestureRecognizer:tap];
    
    self.gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd";
    self.calendar.accessibilityIdentifier = @"calendar";

    UIView *whiterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KSIphonScreenH(300)+40)];
    whiterView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiterView];
    
    [whiterView addSubview:self.calendar];

    //创建点击跳转显示上一月和下一月button
    UIButton *previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
    previousButton.frame = CGRectMake(0, 10, 90, 34);
    previousButton.backgroundColor = [UIColor whiteColor];
    previousButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [previousButton setTitle:@"上一月" forState:UIControlStateNormal];
    [previousButton setTitleColor:[UIColor tabBarItemTextColor] forState:UIControlStateNormal];
    [previousButton addTarget:self action:@selector(previousClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_calendar addSubview:previousButton];

    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(CGRectGetWidth(self.frame)-90, 10, 90, 34);
    nextButton.backgroundColor = [UIColor whiteColor];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [nextButton setTitle:@"下一月" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor tabBarItemTextColor] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_calendar addSubview:nextButton];


    //取消
    UIButton *cacelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [whiterView addSubview:cacelBtn];
    [cacelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cacelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cacelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cacelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(KSIphonScreenW(70)));
        make.height.equalTo(@30);
        make.right.bottom.equalTo(whiterView).offset(-5);
       
    }];
    cacelBtn.layer.borderWidth = 0.5;
    cacelBtn.layer.borderColor = [UIColor tabBarItemTextColor].CGColor;
    cacelBtn.layer.cornerRadius = 15;
    cacelBtn.layer.masksToBounds = YES;
    cacelBtn.backgroundColor = [UIColor tabBarItemTextColor];
    [cacelBtn addTarget:self action:@selector(selectdTap) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *tureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [whiterView addSubview:tureBtn];
    [tureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cacelBtn.mas_left).offset(-10);
        make.width.height.equalTo(cacelBtn);
        make.centerY.equalTo(cacelBtn.mas_centerY);
    }];
    [tureBtn setTitle:@"确定" forState:UIControlStateNormal];
    tureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [tureBtn addTarget:self action:@selector(tureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    tureBtn.layer.borderWidth = 0.5;
    tureBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    tureBtn.layer.cornerRadius = 15;
    tureBtn.layer.masksToBounds = YES;
    tureBtn.backgroundColor = [UIColor lightGrayColor];
    tureBtn.enabled = NO;
    self.tureBtn = tureBtn;
    
}
-(void)selectdTap{
    
    self.showBlock();
    
}
//上一月按钮点击事件
- (void)previousClicked:(id)sender {
    
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *previousMonth = [self.calendar dateBySubstractingMonths:1 fromDate:currentMonth];
    [self.calendar setCurrentPage:previousMonth animated:YES];
}

//下一月按钮点击事件
- (void)nextClicked:(id)sender {
    
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *nextMonth = [self.calendar dateByAddingMonths:1 toDate:currentMonth];
    [self.calendar setCurrentPage:nextMonth animated:YES];
}
//确定按钮
-(void) tureBtnAction:(UIButton *)sender{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *beginStr= [self.dateFormatter stringFromDate:self.date1];
    NSString *endStr= [self.dateFormatter stringFromDate:self.date2];
    param[@"begin"] = beginStr;
    param[@"end"] = endStr;
    
    self.selectBlock(param.copy);
  //  [self selectdTap];
    
}
#pragma mark - FSCalendarDataSource

- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    return [self.dateFormatter dateFromString:@"2016-07-08"];
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    return [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:10 toDate:[NSDate date] options:0];
}

- (NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date
{
    if ([self.gregorian isDateInToday:date]) {
        return @"今";
    }
    return nil;
}
- (FSCalendarCell *)calendar:(FSCalendar *)calendar cellForDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    RangePickerCell *cell = [calendar dequeueReusableCellWithIdentifier:@"cell" forDate:date atMonthPosition:monthPosition];
    
    return cell;
}

- (void)calendar:(FSCalendar *)calendar willDisplayCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition: (FSCalendarMonthPosition)monthPosition
{
    [self configureCell:cell forDate:date atMonthPosition:monthPosition];
}

#pragma mark - FSCalendarDelegate

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    return monthPosition == FSCalendarMonthPositionCurrent;
}

- (BOOL)calendar:(FSCalendar *)calendar shouldDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    return NO;
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
   
    if (calendar.swipeToChooseGesture.state == UIGestureRecognizerStateChanged) {
        // If the selection is caused by swipe gestures
        if (!self.date1) {
            self.date1 = date;
        } else {
            if (self.date2) {
                [calendar deselectDate:self.date2];
            }
            self.date2 = date;
        }
    } else {
        if (self.date2) {
            [calendar deselectDate:self.date1];
            [calendar deselectDate:self.date2];
            self.date1 = date;
            self.date2 = nil;
        } else if (!self.date1) {
            self.date1 = date;
        } else {
            self.date2 = date;
        }
    }
    //判断确定按钮是否可用
    if (self.date1 != nil & self.date2 != nil) {
        self.tureBtn.enabled = YES;
        self.tureBtn.backgroundColor = [UIColor tabBarItemTextColor];
        self.tureBtn.layer.borderColor = [UIColor tabBarItemTextColor].CGColor;
    }else{
        self.tureBtn.enabled = NO;
        self.tureBtn.backgroundColor  =[UIColor lightGrayColor];
        self.tureBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    [self configureVisibleCells];
}

- (void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did deselect date %@",[self.dateFormatter stringFromDate:date]);
    [self configureVisibleCells];
}

- (NSArray<UIColor *> *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventDefaultColorsForDate:(NSDate *)date
{
    if ([self.gregorian isDateInToday:date]) {
        return @[[UIColor orangeColor]];
    }
    return @[appearance.eventDefaultColor];
}

#pragma mark - Private methods

- (void)configureVisibleCells
{
    [self.calendar.visibleCells enumerateObjectsUsingBlock:^(__kindof FSCalendarCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDate *date = [self.calendar dateForCell:obj];
        FSCalendarMonthPosition position = [self.calendar monthPositionForCell:obj];
        [self configureCell:obj forDate:date atMonthPosition:position];
    }];
}

- (void)configureCell:(__kindof FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position
{
    RangePickerCell *rangeCell = cell;
    if (position != FSCalendarMonthPositionCurrent) {
        rangeCell.middleLayer.hidden = YES;
        rangeCell.selectionLayer.hidden = YES;
        return;
    }
    if (self.date1 && self.date2) {
        // The date is in the middle of the range
        BOOL isMiddle = [date compare:self.date1] != [date compare:self.date2];
        rangeCell.middleLayer.hidden = !isMiddle;
    } else {
        rangeCell.middleLayer.hidden = YES;
    }
    BOOL isSelected = NO;
    isSelected |= self.date1 && [self.gregorian isDate:date inSameDayAsDate:self.date1];
    isSelected |= self.date2 && [self.gregorian isDate:date inSameDayAsDate:self.date2];
    rangeCell.selectionLayer.hidden = !isSelected;
    
}
-(FSCalendar *)calendar{
    if (!_calendar) {
        FSCalendar *calendar = [[FSCalendar alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KSIphonScreenH(300))];
        calendar.dataSource = self;
        calendar.delegate = self;
        calendar.allowsMultipleSelection = YES;
        calendar.appearance.headerMinimumDissolvedAlpha = 0;
        calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase;
        
        //设置翻页方式为水平
        calendar.scrollDirection = FSCalendarScrollDirectionHorizontal;
        calendar.backgroundColor = [UIColor whiteColor];
        calendar.appearance.titleDefaultColor = [UIColor naviBackGroupColor];
        calendar.appearance.headerTitleColor = [UIColor naviBackGroupColor];
        calendar.appearance.titleFont = [UIFont systemFontOfSize:15];
        calendar.weekdayHeight = 0;
        calendar.swipeToChooseGesture.enabled = YES;
        calendar.today = nil; // Hide the today circle
        [calendar registerClass:[RangePickerCell class] forCellReuseIdentifier:@"cell"];
        self.calendar = calendar;
    }
    return _calendar;
}



@end
