//
//  VideoHideView.h
//  SDMonitSystem
//
//  Created by tiao on 2018/1/24.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoHideView : UIView
//提示文字
@property (nonatomic,strong) UILabel *hideLab;
//播放按钮
@property (nonatomic,strong) UIButton *palyBtn;
//返回按钮
@property (nonatomic,strong) UIButton *backBtn;

//继续播放点击事件
@property (nonatomic,copy) void(^hideBlock)(void);

//返回点击事件
@property (nonatomic,copy) void(^backBlock)(void);
@end
