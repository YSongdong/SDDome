//
//  TXLitePlayView.h
//  PlayDemo
//
//  Created by tiao on 2018/1/8.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IJKMediaFramework/IJKMediaFramework.h>
@interface TXLitePlayView : UIView

@property (nonatomic,copy) void(^btnBlock)(BOOL isSelectd);

@property (nonatomic, retain) id <IJKMediaPlayback> player;//播放器

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

//暂停播放
-(void) txlPause;
//恢复播放
-(void) txlResume;
//结束播放
-(void) endStopPlay;
//销毁播放器及组件
-(void) releasePlayer;
@end
