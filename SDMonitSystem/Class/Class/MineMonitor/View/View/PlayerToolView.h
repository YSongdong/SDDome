//
//  PlayerToolView.h
//  SDMonitSystem
//
//  Created by tiao on 2018/3/18.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VideoHideView.h"
#import "ZYLButton.h"

@interface PlayerToolView : UIView
@property (nonatomic,strong) UIView *showView;

//直播封面mage
@property (nonatomic,strong) UIImageView *coverImage;
//控制层view
@property (nonatomic,strong) UIView *coverView;
//时间
@property (nonatomic,strong) UILabel *timeLab;
//播放地址
@property (nonatomic,strong) NSString *url;
//网络状态
@property (nonatomic,strong) NSString *netWorkStatu;
//背景view
@property (nonatomic,strong) UIView *backGrouView;
//暂停播放遮蔽层
@property (nonatomic,strong) UIView *suspendView;
//直播封面遮蔽层播放按钮
@property (nonatomic,strong) UIButton   *playBtn;
//返回按钮
@property (nonatomic,strong) UIButton *backBtn;
//网络判断遮蔽层
@property (nonatomic,strong) VideoHideView *hideView;
//标题工具View
@property (nonatomic,strong) UIView *titleToolView;
//菊花加载
@property (nonatomic, strong) UIActivityIndicatorView * activeView;
//暂停和继续播放 YES 继续播放  NO暂停播放
@property (nonatomic,copy) void(^btnBlock)(BOOL isPlay);
//全屏下返回按钮
@property (nonatomic,copy) void(^backBlock)(BOOL isBack);
//是否全屏 YES 全屏 NO 竖屏
@property (nonatomic,copy) void(^hpBlock)(BOOL isHP);

@end
