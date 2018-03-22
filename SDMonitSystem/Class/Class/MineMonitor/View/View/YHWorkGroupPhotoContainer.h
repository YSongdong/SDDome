//
//  YHWorkGroupPhotoContainer.h
//  HKPTimeLine  仿赤兔、微博动态
//  CSDN:  http://blog.csdn.net/samuelandkevin
//  Created by samuelandkevin on 16/9/20.
//  Copyright © 2016年 HKP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHWorkGroupPhotoContainer : UIView

//YEs 是返回  NO 横屏
@property (nonatomic,copy) void(^btnBlock)(BOOL isBack);

@property (nonatomic, strong) NSArray *picUrlArray;//缩略图URL
@property (nonatomic, strong) NSArray *picOriArray;//原图url
//时间
@property (nonatomic,strong) NSString *timeStr;
//名称
@property (nonatomic,strong) NSString *titleStr;

- (instancetype)initWithWidth:(CGFloat)width;

- (CGFloat)setupPicUrlArray:(NSArray *)picUrlArray;

@end
