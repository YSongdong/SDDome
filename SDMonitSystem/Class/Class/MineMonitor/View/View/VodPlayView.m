//
//  VodPlayView.m
//  PlayDemo
//
//  Created by tiao on 2018/1/12.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "VodPlayView.h"


#import "VideoHideView.h"
#import "ZYLButton.h"
#import "ZSLoading.h"
typedef NS_ENUM(NSUInteger, Direction) {
    DirectionLeftOrRight,
    DirectionUpOrDown,
    DirectionNone
};
@interface VodPlayView () <ZYLButtonDelegate>{
    NSTimer * _timer;
}

//播放器
@property (weak, nonatomic) UIView *playerView;

//播放工具view
@property (nonatomic,strong) UIView *playToolView;
//播放按钮
@property (nonatomic,strong) UIButton *playBtn;
//横竖屏按钮
@property (nonatomic,strong) UIButton *hpBtn;
//滑动条
@property (nonatomic,strong) UISlider *vodSlider;
//进度条
@property (nonatomic,strong) UIProgressView *vodProgreesView;
//开始时间
@property (nonatomic,strong) UILabel *beginLab;
//结束时间
@property (nonatomic,strong) UILabel *endLab;
//隐藏工具类view
@property (nonatomic,assign) BOOL hideTool;

//标题工具View
@property (nonatomic,strong) UIView *titleToolView;
//关闭按钮
@property (nonatomic,strong) UIButton *closeBtn;

//遮蔽层
@property (nonatomic,strong) VideoHideView *hideView;

//手势
@property (strong, nonatomic) ZYLButton *zylbutton;
//控制音量
@property (strong, nonatomic) UISlider* volumeViewSlider;
//手势位置
@property (assign, nonatomic) CGPoint startPoint;
//
@property (assign, nonatomic) CGFloat startVB;

@property (assign, nonatomic) Direction direction;


//加载
@property (nonatomic,strong) MBProgressHUD *hup;
@property (nonatomic,strong)ZSLoading * loading;
@end

@implementation VodPlayView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super  initWithFrame:frame]) {
        [self createVodPlayUI];
    }
    return self;
}

//创建点播UI
-(void) createVodPlayUI{
    
    __weak typeof(self) weakSelf = self;
    
    self.backGrouView= [[UIView alloc]initWithFrame:self.bounds];
    self.backGrouView.backgroundColor = [UIColor blackColor];
    self.backGrouView.alpha = 1;
    [self addSubview:self.backGrouView];

    self.showView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width,  self.frame.size.height)];
    [self addSubview:self.showView];
    
    //封面图
    self.coverImage = [[UIImageView alloc]init];
    [self addSubview:self.coverImage];
    [self.coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(weakSelf.showView);
    }];
    self.coverImage.image = [UIImage imageNamed:@"cover"];

    //添加自定义的Button到视频画面上
    self.zylbutton = [[ZYLButton alloc] init];
    self.zylbutton.touchDelegate = self;
    [self addSubview:self.zylbutton];
    [self.zylbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(weakSelf.showView).offset(0);
    }];
    //1、创建手势实例，并连接方法handleTapGesture,点击手势
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playerViewTap:)];
    //设置手势点击数,双击：点1下
    tapGesture.numberOfTapsRequired=1;
    
    // imageView添加手势识别
    [_zylbutton addGestureRecognizer:tapGesture];
    
//    //加载。。。。。。
//    self.hup = [[MBProgressHUD alloc]init];
//    [self addSubview:self.hup];
//    [self.hup showAnimated:YES];
//    self.hup.backgroundColor = [UIColor clearColor];
    

    //控制层view
    self.coverView = [[UIView alloc]initWithFrame:self.showView.frame];
    [self addSubview:self.coverView];
    
    _loading = [[ZSLoading alloc]init];
    [_coverView addSubview:_loading];
    [_loading mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(100);
        make.centerX.equalTo(_coverView.mas_centerX);
        make.centerY.equalTo(_coverView.mas_centerY);
        
    }];
    [_coverView layoutIfNeeded];
    _loading.frame = _loading.frame;
    

#pragma mark   --- 标题工具view
    self.titleToolView = [[UIView alloc]init];
    [self.coverView addSubview:self.titleToolView];
    self.titleToolView.backgroundColor = [UIColor clearColor];
    [self.titleToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(_coverView);
        make.height.equalTo(@(KSIphonScreenH(50)));
    }];
    
    //关闭按钮
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.titleToolView addSubview:self.closeBtn];
    [self.closeBtn setImage:[UIImage imageNamed:@"back_wither"] forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(selectdCloseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleToolView).offset(5);
        make.width.height.equalTo(@(KSIphonScreenH(40)));
        make.centerY.equalTo(_titleToolView.mas_centerY).offset(15);
    }];
   
    //标题
    self.vodTitleLab = [[UILabel alloc]init];
    [self.titleToolView addSubview:self.vodTitleLab];
    self.vodTitleLab.font = [UIFont systemFontOfSize:15];
    self.vodTitleLab.textColor = [UIColor whiteColor];
    [self.vodTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.closeBtn.mas_right).offset(5);
        make.right.equalTo(weakSelf.titleToolView.mas_right).offset(10+SafeAreaBottomHeight);
        make.centerY.equalTo(weakSelf.closeBtn.mas_centerY);
    }];
    
#pragma mark   --- 播放工具view
    self.playToolView = [[UIView alloc]init];
    self.playToolView.backgroundColor = [UIColor clearColor];
    [self.coverView addSubview:self.playToolView];
    [self.playToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_coverView);
        make.height.equalTo(@(KSIphonScreenH(40)));
    }];
    
    //播放按钮
    self.playBtn = [[UIButton alloc]init];
    [self.playBtn setImage:[UIImage imageNamed:@"play_samll"] forState:UIControlStateNormal];
    self.playBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.playBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.playBtn setImage:[UIImage imageNamed:@"play_selectd"] forState:UIControlStateSelected];
    [self.playBtn addTarget:self action:@selector(selectPlayBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.playToolView addSubview:self.playBtn];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_playToolView).offset(1);
        make.width.height.equalTo(@(KSIphonScreenH(40)));
        make.centerY.equalTo(_playToolView.mas_centerY);
    }];
    
    //开始时间
    self.beginLab = [[UILabel alloc]init];
    self.beginLab.font =[UIFont systemFontOfSize:11];
    self.beginLab.textColor = [UIColor whiteColor];
    self.beginLab.text = @"00:00";
    self.beginLab.textAlignment = NSTextAlignmentCenter;
    [self.playToolView addSubview:self.beginLab];
    [self.beginLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_playBtn.mas_right);
        make.width.height.equalTo(@(KSIphonScreenH(40)));
        make.centerY.equalTo(_playBtn.mas_centerY);
    }];
    
    //结束时间
    self.endLab = [[UILabel alloc]init];
    [self.playToolView addSubview:self.endLab];
    self.endLab.font = [UIFont systemFontOfSize:11];
    self.endLab.textColor = [UIColor whiteColor];
    self.endLab.text = @"00:00";
    self.endLab.textAlignment = NSTextAlignmentCenter;
    [self.endLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.playToolView).offset(-10);
        make.width.height.equalTo(@(KSIphonScreenH(40)));
        make.centerY.equalTo(weakSelf.playToolView.mas_centerY);
    }];
    
    //进度条
    self.vodProgreesView = [[UIProgressView alloc]init];
    [self.playToolView addSubview:self.vodProgreesView];
    //完成
    self.vodProgreesView .progressTintColor = [UIColor whiteColor];
    //未完成
    self.vodProgreesView .trackTintColor = [UIColor whiteColor];
    //设置进度条的进度值
    self.vodProgreesView .progress = 0;
    [self.vodProgreesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_beginLab.mas_right).offset(5);
        make.right.equalTo(_endLab.mas_left).offset(-5);
        make.centerY.equalTo(_playBtn.mas_centerY);
    }];
    
    //进度条
    self.vodSlider = [[UISlider alloc]init];
    [self.playToolView addSubview:self.vodSlider];
    [self.vodSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_beginLab.mas_right).offset(5);
        make.right.equalTo(_endLab.mas_left).offset(-5);
        make.centerY.equalTo(_playBtn.mas_centerY);
    }];
   
    //设置滑动条的位置
    self.vodSlider.value  = 0;
    // 设置可连续变化
    self.vodSlider.continuous = YES;
    //设置左侧滑动条的背景颜色
    self.vodSlider.minimumTrackTintColor = [UIColor tabBarItemTextColor];
    //设置右侧滑动条的背景颜色
    self.vodSlider.maximumTrackTintColor = [UIColor whiteColor];
    //设置滑块的颜色
    self.vodSlider.thumbTintColor = [UIColor whiteColor];
    //对滑动条添加事件
    [self.vodSlider addTarget:self action:@selector(sliderValuechange:) forControlEvents:UIControlEventValueChanged];
    UITapGestureRecognizer * sliderTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sliderTap:)];
    UIImage * image = [self createImageWithColor:[UIColor whiteColor]];
    UIImage * circleImage = [self circleImageWithImage:image borderWidth:0 borderColor:[UIColor clearColor]];
    [self.vodSlider setThumbImage:circleImage forState:(UIControlStateNormal)];
    [self.vodSlider addGestureRecognizer:sliderTap];

    //添加点击事件
    UITapGestureRecognizer * tap  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playerViewTap:)];
    [self.coverView addGestureRecognizer:tap];
  
    self.hideView = [[VideoHideView alloc]init];
    [self addSubview:self.hideView];
    [self.hideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(weakSelf.showView);
    }];
    //继续播放
    self.hideView.hideBlock = ^{
        weakSelf.hideView.hidden = YES;
        [weakSelf selectPlayBtnAction:weakSelf.playBtn];
    };

    //关闭viwe
    self.hideView.backBlock = ^{
        
        [weakSelf selectdCloseBtnAction:weakSelf.closeBtn];
    };
    self.hideView.hidden = YES;

   //判断网络状态
    [KRMainNetTool ysy_hasNetwork:^(NSString *net) {
        
        [weakSelf alterNetWork:net];
    }];
}
#pragma mark-初始化playerView
-(void)setupPlayerView{
    //播放器
    IJKFFOptions *options = [IJKFFOptions optionsByDefault]; //使用默认配置
    //软解，更稳定
    [options setPlayerOptionIntValue:0 forKey:@"videotoolbox"];
    //解码参数，画面更清晰
    [options setCodecOptionIntValue:IJK_AVDISCARD_DEFAULT forKey:@"skip_loop_filter"];
    //
    [options setCodecOptionIntValue:IJK_AVDISCARD_DEFAULT forKey:@"skip_frame"];
    //如果是rtsp协议，可以优先用tcp(默认是用udp)
    [options setFormatOptionValue:@"tcp" forKey:@"rtsp_transport"];
    
    [options setOptionIntValue:2 forKey:@"videotoolbox" ofCategory:kIJKFFOptionCategoryPlayer];
    
    _player = [[IJKFFMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:self.url] withOptions:options];
    //缩放模式为FILL
    //  [_player setScalingMode:IJKMPMovieScalingModeAspectFit];
    _player.shouldAutoplay = NO;
    [_player prepareToPlay];
    [self installMovieNotificationObservers];
    
    UIView *playerView = [self.player view];
    
    self.playerView = _showView;
    
    playerView.frame = self.showView.frame;
    playerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.playerView insertSubview:playerView atIndex:0];
  
}

-(void)setUrl:(NSString *)url{
    _url = url;
    
    [self setupPlayerView];
}
//播放按钮
-(void)selectPlayBtnAction:(UIButton *)sender{
    
    //隐藏封面
    self.coverImage.hidden = YES;
    
    sender.selected = !sender.selected;

     if (sender.selected) {
         
         [self txlResume];
         [_timer setFireDate:[NSDate distantPast]];

     }else{
         [_timer setFireDate:[NSDate distantFuture]];
         [self txlPause];
     }
}
//判断网络状态
-(void) alterNetWork:(NSString *)workStau {
    
    if (![workStau isEqualToString:@"NO"]) {
        if ([workStau isEqualToString:@"WIFI"]) {
            
            self.hideView.hidden = YES;
            
        }else{
            
            self.hideView.hidden = NO;
            self.hideView.hideLab.text = @"使用手机流量会产生资费，是否继续播放!";
        }
    }else{
        
        self.hideView.hidden = NO;
        
        if ([self.url isEqualToString:@""]) {
            self.hideView.hideLab.text = @"暂无视频！";
        }else{
            self.hideView.hideLab.text = @"没有网络，请重新连接网络！";
        }
        self.hideView.palyBtn.hidden = YES;
        
        [self txlPause];
        
    }
}
//刷新UI
-(void)layoutIfNeeded{
    [super layoutIfNeeded];
    self.coverView.frame = self.showView.frame;
    //封面图
    self.coverImage.frame =self.showView.frame;
}
#pragma mark  ----关闭view---
-(void) selectdCloseBtnAction:(UIButton *) sender{
    //移除播放器
    if ([self.delegate respondsToSelector:@selector(selectdCloseBtn)]) {
        [self.delegate selectdCloseBtn];
        [self txlPause];
        [_timer setFireDate:[NSDate distantFuture]];
        
    }
}

#pragma mark------点击了playerView-----------
-(void)playerViewTap:(UITapGestureRecognizer *)recognizer{
    //每次点击取消还在进程中的隐藏方法
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
    _hideTool = !_hideTool;
    [UIView animateWithDuration:0.25 animations:^{
        if (_hideTool) {
            self.coverView.alpha = 0;
        }else{
            self.coverView.alpha = 1;
        }
    } completion:^(BOOL finished) {
        if (_hideTool) {
            self.coverView.hidden = YES;

        }else{
            self.coverView.hidden = NO;
            //如果最后没隐藏,在调用隐藏的代码
            [self performSelector:@selector(hide) withObject:nil afterDelay:4];
        }
    }];

}
#pragma mark-隐藏cover
-(void)hide{
    [UIView animateWithDuration:0.25 animations:^{
        self.coverView.alpha = 0 ;
    }completion:^(BOOL finished) {
        self.coverView.hidden = YES;
        _hideTool = YES;
    }];
}
//暂停播放
-(void) txlPause{
   
    [_player pause];
    [_timer setFireDate:[NSDate distantFuture]];
}
//恢复播放
-(void) txlResume{
    
    if (self.playBtn.selected) {
       [_player play];
       [_timer setFireDate:[NSDate distantPast]];
    }
}
//结束播放
-(void)endStopPlay{
    
    [_player stop];
    [_player shutdown];
    
}
//销毁播放器及组件
-(void) releasePlayer{
    [_loading removeFromSuperview];
    [_player shutdown];
    _player = nil;
    [_timer invalidate];
    _timer =  nil;
    [_player.view removeFromSuperview];
    [_backGrouView removeFromSuperview];
    [_showView removeFromSuperview];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

-(void)setNetWorkStatu:(NSString *)netWorkStatu{
    
    _netWorkStatu = netWorkStatu;
    
    [self alterNetWork:netWorkStatu];
}

#pragma mark  --- 滑条实现方法
//滑动条
-(void)sliderValuechange:(UISlider *)sender
{
    // 暂停播放
    [self txlPause];
    //取消收回工具栏的动作
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
    _player.currentPlaybackTime = sender.value*_player.duration;
    // 恢复播放
    [_player play];
    [_timer setFireDate:[NSDate distantPast]];
    self.playBtn.selected = YES;
    
}
//点击滑动条
-(void)sliderTap:(UITapGestureRecognizer *)tap
{
    // 暂停播放
    [self txlPause];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
    
    CGPoint point = [tap locationInView:self.vodSlider];
    
    [self.vodSlider setValue:point.x/self.vodSlider.bounds.size.width*1 animated:YES];
    
    _player.currentPlaybackTime = self.vodSlider.value*_player.duration;
    // 恢复播放
    [_player play];
    [_timer setFireDate:[NSDate distantPast]];
    self.playBtn.selected = YES;
    
}
#pragma mark-公共方法
- (NSString*)TimeformatFromSeconds:(NSInteger)seconds
{
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02d",(int)seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02d",(int)(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02d",(int)seconds%60];
    //format of time
    NSString *timeStr;
    if (([str_minute integerValue] + ([str_hour integerValue]*60) < 10)) {
        timeStr = [NSString stringWithFormat:@"0%d",(int)([str_minute integerValue] + ([str_hour integerValue]*60))];
    }else{
        timeStr = [NSString stringWithFormat:@"%d",(int)([str_minute integerValue] + ([str_hour integerValue]*60))];
    }
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",timeStr,str_second];
    
    return format_time;
}
//从图片
- (UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0,0,15,15);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
- (UIImage *)circleImageWithImage:(UIImage *)oldImage borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    // 2.开启上下文
    CGFloat imageW = oldImage.size.width + 22 * borderWidth;
    CGFloat imageH = oldImage.size.height + 22 * borderWidth;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    
    // 3.取得当前的上下文,这里得到的就是上面刚创建的那个图片上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 4.画边框(大圆)
    [borderColor set];
    CGFloat bigRadius = imageW * 0.5; // 大圆半径
    CGFloat centerX = bigRadius; // 圆心
    CGFloat centerY = bigRadius;
    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(ctx); // 画圆。As a side effect when you call this function, Quartz clears the current path.
    
    // 5.小圆
    CGFloat smallRadius = bigRadius - borderWidth;
    CGContextAddArc(ctx, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    // 裁剪(后面画的东西才会受裁剪的影响)
    CGContextClip(ctx);
    
    // 6.画图
    [oldImage drawInRect:CGRectMake(borderWidth, borderWidth, oldImage.size.width, oldImage.size.height)];
    
    // 7.取图
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 8.结束上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}
#pragma mark -----手势-------
#pragma mark  -- 音量
#pragma mark - 开始触摸
/*************************************************************************/

- (void)touchesBeganWithPoint:(CGPoint)point {
    //记录首次触摸坐标
    self.startPoint = point;
    //检测用户是触摸屏幕的左边还是右边，以此判断用户是要调节音量还是亮度，左边是亮度，右边是音量
    if (self.startPoint.x <= self.zylbutton.frame.size.width / 2.0) {
        //亮度
        self.startVB = [UIScreen mainScreen].brightness;
    } else {
        //音/量
        self.startVB = self.volumeViewSlider.value;
    }
}
#pragma mark - 结束触摸
- (void)touchesEndWithPoint:(CGPoint)point {
    
    
}
#pragma mark - 拖动
- (void)touchesMoveWithPoint:(CGPoint)point {
    //得出手指在Button上移动的距离
    CGPoint panPoint = CGPointMake(point.x - self.startPoint.x, point.y - self.startPoint.y);
    //分析出用户滑动的方向
    if (self.direction == DirectionNone) {
        if (panPoint.x >= 30 || panPoint.x <= -30) {
            
            
        } else if (panPoint.y >= 30 || panPoint.y <= -30) {
            //音量和亮度
            self.direction = DirectionUpOrDown;
        }
    }
    if (self.direction == DirectionNone) {
        return;
    } else if (self.direction == DirectionUpOrDown) {
        //音量和亮度
        if (self.startPoint.x <= self.zylbutton.frame.size.width / 2.0) {
            //调节亮度
            if (panPoint.y < 0) {
                
                if ((self.startVB + (-panPoint.y / 30.0 / 10) < 1)) {
                    //增加亮度
                    [[UIScreen mainScreen] setBrightness:self.startVB + (-panPoint.y / 30.0 / 10)];
                }
                
            } else {
                if ((self.startVB - (panPoint.y / 30.0 / 10) > 0)) {
                    //减少亮度
                    [[UIScreen mainScreen] setBrightness:self.startVB - (panPoint.y / 30.0 / 10)];
                }
                
            }
            
        } else {
            //音量
            if (panPoint.y < 0) {
                //增大音量
                [self.volumeViewSlider setValue:self.startVB + (-panPoint.y / 30.0 / 10) animated:YES];
                if (self.startVB + (-panPoint.y / 30 / 10) - self.volumeViewSlider.value >= 0.1) {
                    [self.volumeViewSlider setValue:1 animated:NO];
                    [self.volumeViewSlider setValue:self.startVB + (-panPoint.y / 30.0 / 10) animated:YES];
                }
                
            } else {
                //减少音量
                [self.volumeViewSlider setValue:self.startVB - (panPoint.y / 30.0 / 10) animated:YES];
            }
        }
    } else if (self.direction == DirectionLeftOrRight ) {
        
    }
}
#pragma mark-加载状态改变
- (void)loadStateDidChange:(NSNotification*)notification {
    IJKMPMovieLoadState loadState = _player.loadState;
    
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        //总时长
        self.endLab.text = [self TimeformatFromSeconds:_player.duration];
        NSLog(@"LoadStateDidChange: IJKMovieLoadStatePlayThroughOK: %d\n",(int)loadState);
    }else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
    
        
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}
#pragma mark-播放状态改变
- (void)moviePlayBackFinish:(NSNotification*)notification {
    int reason =[[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    switch (reason) {
        case IJKMPMovieFinishReasonPlaybackEnded:
            //关闭定时器
            [_timer setFireDate:[NSDate distantFuture]];
            //关闭播放器
            [self endStopPlay];
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
            NSLog(@"------777-----");
            break;
            
        case IJKMPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
            NSLog(@"------888-----");
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
            //隐藏加载条
            _loading.hidden = YES;
            //隐藏封面
            self.coverImage.hidden = YES;
            //网络断连层
            self.hideView.hidden = NO;
            self.hideView.hideLab.text = @"没有网络，请重新连接网络！";
            self.hideView.palyBtn.hidden = YES;
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
            NSLog(@"------999-----");
            break;
            
        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}
// 加载完成
- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification {
    //隐藏封面
    self.coverImage.hidden = YES;
    //隐藏加载
    _loading.hidden = YES;
    //暂停播放
    [_player pause];
}
- (void)moviePlayBackStateDidChange:(NSNotification*)notification {
    if (self.player.playbackState==IJKMPMoviePlaybackStatePlaying) {
        //视频开始播放的时候开启计时器
        if (!_timer) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(UpdateTimer) userInfo:nil repeats:YES];
            //先暂停定时器
            [_timer setFireDate:[NSDate distantFuture]];
        }
        [self performSelector:@selector(hide) withObject:nil afterDelay:4];
    }
    switch (_player.playbackState) {
        case IJKMPMoviePlaybackStateStopped:
            
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
            NSLog(@"------111-----");
            break;
            
        case IJKMPMoviePlaybackStatePlaying:
            
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
            NSLog(@"------222-----");
            break;
            
        case IJKMPMoviePlaybackStatePaused:
            
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
            NSLog(@"------333-----");
            break;
            
        case IJKMPMoviePlaybackStateInterrupted:
            
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
            NSLog(@"------444-----");
            break;
            
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
            NSLog(@"------555-----");
            break;
        }
            
        default: {
            
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
            NSLog(@"------666-----");
            break;
        }
    }
}
#pragma mark---------UI更新方法---------
-(void)UpdateTimer{
    
    CGFloat current = _player.currentPlaybackTime;
    CGFloat total = _player.duration;
    CGFloat able = _player.playableDuration;
    self.beginLab.text = [self TimeformatFromSeconds:_player.currentPlaybackTime];
    [self.vodProgreesView setProgress:able/total animated:YES];
    [self.vodSlider setValue:current/total animated:YES];
 
}
#pragma Install Notifiacation
- (void)installMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(loadStateDidChange:)   name:IJKMPMoviePlayerLoadStateDidChangeNotification  object:_player];
    [[NSNotificationCenter defaultCenter] addObserver:self   selector:@selector(moviePlayBackFinish:) name:IJKMPMoviePlayerPlaybackDidFinishNotification  object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaIsPreparedToPlayDidChange:) name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification   object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackStateDidChange:) name:IJKMPMoviePlayerPlaybackStateDidChangeNotification  object:_player];
    
}

- (void)removeMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMoviePlayerLoadStateDidChangeNotification  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification   object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:_player];
    
}



@end
