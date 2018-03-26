//
//  ToolView.h
//  SDMonitSystem
//
//  Created by tiao on 2018/3/22.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoHideView.h"


@interface ToolView : UIView
//播放器显示view
@property (nonatomic,strong) UIView *showView;
//手势控制view
@property (nonatomic,strong) UIView *gestView;
//控制层view
@property (nonatomic,strong) UIView *coverView;
//顶部view
@property (nonatomic,strong) UIView *topView;
//封面image
@property (nonatomic,strong) UIImageView *coverImage;
//顶部viewtitle
@property (nonatomic,strong) UILabel *topTitleLab;
//网络判断层
@property (nonatomic,strong) VideoHideView *networkStatuView;
//网络状态
@property (nonatomic,strong) NSString *netWorkStatu;
//菊花加载
@property (nonatomic, strong) UIActivityIndicatorView * activeView;
//播放按钮
@property (nonatomic,strong) UIButton *playBtn;
//暂停和继续播放 YES 继续播放  NO暂停播放
@property (nonatomic,copy) void(^btnBlock)(BOOL isPlay);
//全屏下返回按钮
@property (nonatomic,copy) void(^backBlock)(BOOL isBack);
//是否全屏 YES 全屏 NO 竖屏
@property (nonatomic,copy) void(^hpBlock)(BOOL isHP);
@end
