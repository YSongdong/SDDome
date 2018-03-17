//
//  TXLitePlayView.m
//  PlayDemo
//
//  Created by tiao on 2018/1/8.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "TXLitePlayView.h"

#import "VideoHideView.h"
#import "ZYLButton.h"
#import "ZSLoading.h"
typedef NS_ENUM(NSUInteger, Direction) {
    DirectionLeftOrRight,
    DirectionUpOrDown,
    DirectionNone
};

@interface TXLitePlayView () <ZYLButtonDelegate>

@property (nonatomic,strong) UIButton  *hpBtn;     //横竖屏按钮


@property (weak, nonatomic) UIView *playerView;

//网络判断遮蔽层
@property (nonatomic,strong) VideoHideView *hideView;
//暂停播放遮蔽层
@property (nonatomic,strong) UIView *suspendView;
////直播封面遮蔽层image
@property (nonatomic,strong) UIImageView *suspImage;
//直播封面遮蔽层播放按钮
@property (nonatomic,strong) UIButton   *playBtn;
//标题工具View
@property (nonatomic,strong) UIView *titleToolView;
//返回按钮
@property (nonatomic,strong) UIButton *backBtn;

//手势
@property (strong, nonatomic) ZYLButton *zylbutton;
//控制音量
@property (strong, nonatomic) UISlider* volumeViewSlider;
//手势位置
@property (assign, nonatomic) CGPoint startPoint;
//
@property (assign, nonatomic) CGFloat startVB;

@property (assign, nonatomic) Direction direction;

//隐藏工具类view
@property (nonatomic,assign) BOOL hideTool;
//工具view
@property (nonatomic,strong) UIView *toolView;
//加载
@property (nonatomic,strong) MBProgressHUD *hup;
@property (nonatomic,strong)ZSLoading * loading;
@end

@implementation TXLitePlayView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self =  [super initWithFrame:frame]) {
        [self createPlayUI];
    }
    return self;
}
-(void) createPlayUI{

    __weak typeof(self) weakSelf = self;
    
    self.backGrouView= [[UIView alloc]initWithFrame:self.bounds];
    self.backGrouView.backgroundColor = [UIColor blackColor];
    self.backGrouView.alpha = 1;
    [self addSubview:self.backGrouView];
    
    _showView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KSIphonScreenH(220))];
    [self addSubview:_showView];

    //封面图
    self.coverImage = [[UIImageView alloc]init];
    self.coverImage.image = [UIImage imageNamed:@"cover"];
    [self addSubview:self.coverImage];
    [self.coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.left.bottom.right.equalTo(weakSelf.showView);
    }];
    
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

    //控制层view
    self.coverView = [[UIView alloc]initWithFrame:self.showView.frame];
    [self addSubview:self.coverView];
    
    //添加点击事件
    UITapGestureRecognizer * tap  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playerViewTap:)];
    [self.coverView addGestureRecognizer:tap];
    
    //标题view
    self.titleToolView = [[UIView alloc]init];
    [self.coverView addSubview:self.titleToolView];
    self.titleToolView.backgroundColor = [UIColor clearColor];
    [self.titleToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(_coverView);
        make.height.equalTo(@(KSIphonScreenH(50)));
    }];
    
    //关闭按钮
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.titleToolView addSubview:self.backBtn];
    [self.backBtn setImage:[UIImage imageNamed:@"back_wither"] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(selectdCloseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleToolView);
        make.width.height.equalTo(@(KSIphonScreenH(40)));
        make.centerY.equalTo(_titleToolView.mas_centerY).offset(10);
    }];
    // 隐藏titleview
    self.titleToolView.hidden = YES;
    
    //工具view
    self.toolView = [[UIView alloc]init];
    [self.coverView addSubview:self.toolView];
    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(KSIphonScreenH(40)));
        make.right.left.bottom.equalTo(weakSelf.coverView);
    }];
    
    //黑色透明背景view
    UIView *backView= [[UIView alloc]init];
    [self.toolView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(_toolView.mas_height);
        make.right.left.bottom.equalTo(_toolView);
    }];
    backView.backgroundColor =[UIColor clearColor];
 
    //横屏屏按钮
    _hpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.toolView addSubview:_hpBtn];
    [_hpBtn setImage:[UIImage imageNamed:@"play_hp"] forState:UIControlStateNormal];
    [_hpBtn addTarget:self action:@selector(selectdHPBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_hpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(_toolView);
        make.width.height.equalTo(@(KSIphonScreenW(40)));
    }];
    
//    //加载。。。。。。
//    self.hup = [[MBProgressHUD alloc]init];
//    [self addSubview:self.hup];
//    [self.hup showAnimated:YES];
//    self.hup.backgroundColor = [UIColor clearColor];
    
    _loading = [[ZSLoading alloc]init];
    [_coverView addSubview:_loading];
    [_loading mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(100);
        make.centerX.equalTo(_coverView.mas_centerX);
        make.centerY.equalTo(_coverView.mas_centerY);
    
    }];
    [_coverView layoutIfNeeded];
    _loading.frame = _loading.frame;
    
    //暂停播放遮蔽层
    self.suspendView = [[UIView alloc]init];
    [self addSubview:self.suspendView];
    [self.suspendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(weakSelf.showView);
    }];

    self.suspImage = [[UIImageView alloc]init];
    [self.suspendView addSubview:self.suspImage];
    self.suspImage.image = [UIImage imageNamed:@"cover"];
    self.suspImage.userInteractionEnabled = YES;
    [self.suspImage mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.left.bottom.right.equalTo(weakSelf.suspendView);
    }];

    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.suspImage addSubview:self.playBtn];
    [self.playBtn setImage:[UIImage imageNamed:@"play_big"] forState:UIControlStateNormal];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(KSIphonScreenH(100)));
        make.center.equalTo(_coverImage);
    }];
    [self.playBtn addTarget:self action:@selector(palyBtnAction:) forControlEvents:UIControlEventTouchUpInside];

    self.suspendView.hidden = YES;

    // 判断网络层
    self.hideView = [[VideoHideView alloc]init];
    [self addSubview:self.hideView];
    [self.hideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(weakSelf.showView);
    }];
    self.hideView.hideBlock = ^{

        [weakSelf txlResume];
    };
    //关闭viwe
    self.hideView.backBlock = ^{
        
        [weakSelf selectdCloseBtnAction:nil];
    };
    self.hideView.hidden = YES;
    
    //网络判断
    [KRMainNetTool ysy_hasNetwork:^(NSString *net) {
      
        [weakSelf alterNetWork:net];
    }];
 
}
#pragma mark-初始化playerView
-(void)setupPlayerView{
    //播放器
    IJKFFOptions *options = [IJKFFOptions optionsByDefault]; //使用默认配置
    
    [options setFormatOptionValue:@"tcp" forKey:@"rtsp_transport"];
    
    [options setOptionIntValue:2 forKey:@"videotoolbox" ofCategory:kIJKFFOptionCategoryPlayer];
    
    _player = [[IJKFFMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:self.url] withOptions:options];
    
    UIView *playerView = [self.player view];
    
    self.playerView = _showView;
  
    playerView.frame = self.showView.frame;
    playerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.playerView insertSubview:playerView atIndex:0];
   //缩放模式为FILL
  //  [_player setScalingMode:IJKMPMovieScalingModeAspectFit];
    self.player.shouldAutoplay = NO;
    [self.player prepareToPlay];
    [self installMovieNotificationObservers];
    
}

//判断网络状态
-(void) alterNetWork:(NSString *)workStau {
    //隐藏返回按钮
    self.hideView.backBtn.hidden = YES;
    
    if (![workStau isEqualToString:@"NO"]) {
        if ([workStau isEqualToString:@"WIFI"]) {
            self.hideView.hidden = YES;
            //继续播放
            [self txlResume];
            
        }else{
            //暂停播放
            [self txlPause];
            
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
        [self endStopPlay];
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
-(void)setShowView:(UIView *)showView{
    _showView = showView;
}
-(void)setNetWorkStatu:(NSString *)netWorkStatu{
    
    _netWorkStatu = netWorkStatu;
    
    [self alterNetWork:netWorkStatu];
}
//返回按钮点击方法
-(void)selectdCloseBtnAction:(UIButton *)sender{
    
     // 隐藏titleview
     self.titleToolView.hidden = YES;
     sender.selected = NO;
    // 隐藏背景色
     self.backGrouView.hidden = YES;
    
     self.btnBlock(sender.selected);
}
//横屏
-(void)selectdHPBtnAction:(UIButton *) sender{
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        //显示返回按钮
        self.hideView.backBtn.hidden = NO;
        // 显示背景色
        self.backGrouView.hidden = NO;
    }else{
        //隐藏返回按钮
        self.hideView.backBtn.hidden = YES;
        // 隐藏背景色
        self.backGrouView.hidden = YES;
    }
    // 隐藏titleview
    self.titleToolView.hidden = !sender.selected;
    self.btnBlock(sender.selected);
}
-(void)setUrl:(NSString *)url{
    _url = url;
    
    [self setupPlayerView ];
}
//暂停播放
-(void) txlPause{
    [self.player pause];
    //显示播放遮蔽层
    self.suspendView.hidden = NO;
    self.playBtn.hidden = NO;
}

//恢复播放
-(void) txlResume{

    self.hideView.hidden = YES;
    
    self.suspendView.hidden = YES;
    
    [self.player play];
    
}

//结束播放
-(void)endStopPlay{

    [_player stop];
    [_player shutdown];
}

//继续播放
-(void)palyBtnAction:(UIButton *) sender{
    self.coverImage.hidden = YES;
    //隐藏加载条
    _loading.hidden = YES;

    self.hideView.hidden = YES;
    //继续播放
    [self txlResume];
    
}
//销毁播放器及组件
-(void) releasePlayer{

    [_loading removeFromSuperview];
    [_player shutdown];
    _player = nil;
    [_player.view removeFromSuperview];
    [_backGrouView removeFromSuperview];
    [_showView removeFromSuperview];
    [[NSNotificationCenter defaultCenter]removeObserver:self];

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
#pragma Selector func

- (void)loadStateDidChange:(NSNotification*)notification {
    IJKMPMovieLoadState loadState = _player.loadState;
    
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        
        NSLog(@"LoadStateDidChange: IJKMovieLoadStatePlayThroughOK: %d\n",(int)loadState);
    }else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
        
        if (![self.player isPlaying]) {
            [self.player prepareToPlay];
        }
        
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}

- (void)moviePlayBackFinish:(NSNotification*)notification {
    int reason =[[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    switch (reason) {
        case IJKMPMovieFinishReasonPlaybackEnded:
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

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification {
    //隐藏加载条
    _loading.hidden = YES;
    //隐藏封面
    self.coverImage.hidden = YES;

}
- (void)moviePlayBackStateDidChange:(NSNotification*)notification {
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
