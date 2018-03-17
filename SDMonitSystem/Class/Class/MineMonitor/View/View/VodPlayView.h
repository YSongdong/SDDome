//
//  VodPlayView.h
//  PlayDemo
//
//  Created by tiao on 2018/1/12.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IJKMediaFramework/IJKMediaFramework.h>

@protocol VodPlayViewDelegate <NSObject>

//关闭view 恢复竖屏
-(void) selectdCloseBtn;

@end

@interface VodPlayView : UIView

//是否点击横竖屏切换
@property (nonatomic,copy) void(^btnBlock)(BOOL isSelectd);

@property (nonatomic, retain) id <IJKMediaPlayback> player;

@property (nonatomic,weak) id <VodPlayViewDelegate> delegate;
//视频显示view
@property (nonatomic,strong) UIView *showView;
//控制层view
@property (nonatomic,strong) UIView *coverView;
//背景view
@property (nonatomic,strong) UIView *backGrouView;
//封面图
@property (nonatomic,strong) UIImageView *coverImage;
//播放地址
@property (nonatomic,strong) NSString *url;
//网络状态
@property (nonatomic,strong) NSString *netWorkStatu;
//标题
@property (nonatomic,strong) UILabel *vodTitleLab;

//暂停播放
-(void) txlPause;
//恢复播放
-(void) txlResume;
//结束播放
-(void) endStopPlay;
//销毁播放器及组件
-(void) releasePlayer;
@end
