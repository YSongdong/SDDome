//
//  ToolView.m
//  SDMonitSystem
//
//  Created by tiao on 2018/3/22.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "ToolView.h"
#import <MediaPlayer/MediaPlayer.h>


@interface ToolView (){
    //是否显示工具栏
    BOOL isShowToolBar;
    
    CGPoint _currentPoint;
    float _systemVolume; // 系统声音大小
    BOOL _isComplate;// 播放完成
    BOOL _isGes;// 滑动手势只执行一次
    MPVolumeView *volumeView ;// 不显示系统音量提示

    UIImageView *blightView;// 明暗提示图
    UIImageView *voiceView; // 音量提示图
    UIProgressView *blightPtogress; // 明暗提示
    UIProgressView *volumeProgress; // 音量提示
   
}

//顶部view 返回btn
@property (nonatomic,strong) UIButton *topBackBtn;
//底部view
@property (nonatomic,strong) UIView *bottomView;
//底部横屏按钮
@property (nonatomic,strong) UIButton *bottomHPBtn;
// 是否正在拖拽
@property (nonatomic, assign) BOOL progressDragging;
//默认第一次需要判断 YES
@property (nonatomic,assign) BOOL oneNetWork;
//隐藏工具类view
@property (nonatomic,assign) BOOL hideTool;
@end

@implementation ToolView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self =  [super initWithFrame:frame]) {
        [self createToolView];
    }
    return self;
}

-(void) createToolView{
    __weak typeof(self) weakSelf = self;
    //播放器显示view
    _showView = [[UIView alloc]initWithFrame:self.bounds];
    [self addSubview:_showView];
   
    //封面
    self.coverImage  =[[UIImageView alloc]init];
    [self addSubview:self.coverImage];
    [self.coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.showView);
    }];
    
    _gestView = [[UIView alloc]init];
    [self addSubview:_gestView];
    [_gestView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_showView);
    }];
    //单击
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectGestTap:)];
    [tap setNumberOfTapsRequired:1];
    [_gestView addGestureRecognizer:tap];
    //双击
    UITapGestureRecognizer *douluTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectdDouleTap:)];
    [douluTap setNumberOfTapsRequired:2];
    [_gestView addGestureRecognizer:douluTap];

    //滑动
    UIPanGestureRecognizer *panGest = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(selectGestViewPan:)];
    [_gestView addGestureRecognizer:panGest];
    
    //控制层view
    self.coverView = [[UIView alloc]init];
    [self addSubview:self.coverView];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.showView);
    }];
    
    //单击
    UITapGestureRecognizer *coverViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectGestTap:)];
    [coverViewTap setNumberOfTapsRequired:1];
    [_coverView addGestureRecognizer:coverViewTap];
    //双击
    UITapGestureRecognizer *coverDouluTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectdDouleTap:)];
    [coverDouluTap setNumberOfTapsRequired:2];
    [_coverView addGestureRecognizer:coverDouluTap];
    
    //滑动
    UIPanGestureRecognizer *coverPanGest = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(selectGestViewPan:)];
    [_coverView addGestureRecognizer:coverPanGest];
    
    
    //顶部view
    self.topView = [[UIView alloc]init];
    [_coverView addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.gestView);
        make.height.equalTo(@50);
    }];
    
    //顶部返回按钮
    self.topBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.topView addSubview:self.topBackBtn];
    [self.topBackBtn setImage:[UIImage imageNamed:@"back_wither"] forState:UIControlStateNormal];
    [self.topBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@30);
        make.left.equalTo(weakSelf.topView).offset(10);
        make.bottom.equalTo(weakSelf.topView);
    }];
    [self.topBackBtn addTarget:self action:@selector(selectBackBtnActon:) forControlEvents:UIControlEventTouchUpInside];
    
    //顶部标题
    self.topTitleLab = [[UILabel alloc]init];
    self.topTitleLab.textColor = [UIColor whiteColor];
    self.topTitleLab.font = [UIFont systemFontOfSize:16];
    [self.topView addSubview:self.topTitleLab];
    [self.topTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.topBackBtn.mas_right).offset(5);
        make.right.equalTo(weakSelf.topView).offset(-10);
        make.centerY.equalTo(weakSelf.topBackBtn.mas_centerY);
    }];
    
    //底部view
    self.bottomView = [[UIView alloc]init];
    [self.coverView addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.gestView);
        make.height.equalTo(@40);
    }];
    
    //底部横屏按钮
    self.bottomHPBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bottomView addSubview:self.bottomHPBtn];
    [self.bottomHPBtn setImage:[UIImage imageNamed:@"play_hp"] forState:UIControlStateNormal];
    [self.bottomHPBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.bottomView).offset(-10);
        make.centerY.equalTo(weakSelf.bottomView.mas_centerY);
        make.width.height.equalTo(@30);
    }];
     [self.bottomHPBtn addTarget:self action:@selector(selectdHPBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //网络状态提示层（view）
    self.networkStatuView = [[VideoHideView alloc]init];
    [self addSubview:self.networkStatuView];
    [self.networkStatuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.gestView);
    }];
    //继续播放
    self.networkStatuView.contuneBtnBlock = ^{
        
        weakSelf.btnBlock(YES);
    };
    //返回
    self.networkStatuView.backBlock = ^{
        
        weakSelf.backBlock(YES);
    };
    //隐藏竖屏返回按钮
    self.networkStatuView.backBtn.hidden = YES;
    //隐藏
    self.networkStatuView.hidden = YES;
   
    // 菊花加载
    self.activeView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    [self addSubview:self.activeView];
    //设置小菊花的frame
    [self.activeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@100);
        make.centerX.equalTo(_gestView.mas_centerX);
        make.centerY.equalTo(_gestView.mas_centerY);
    }];
    //设置小菊花颜色
    self.activeView.color = [UIColor whiteColor];
//    //刚进入这个界面会显示控件，并且停止旋转也会显示，只是没有在转动而已，没有设置或者设置为YES的时候，刚进入页面不会显示
//    self.activeView.hidesWhenStopped = NO;
//    //开始转动
//    [self.activeView startAnimating];
    
    //播放按钮
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.coverView addSubview:self.playBtn];
    [self.playBtn setImage:[UIImage imageNamed:@"play_suspend"] forState:UIControlStateNormal];
    [self.playBtn setImage:[UIImage imageNamed:@"play_play"] forState:UIControlStateSelected];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@50);
        make.centerX.equalTo(weakSelf.showView.mas_centerX);
        make.centerY.equalTo(weakSelf.showView.mas_centerY);
    }];
    [self.playBtn addTarget:self action:@selector(selectdPlayBtnAction:) forControlEvents:UIControlEventTouchUpInside];
 /*
    // 隐藏系统音量显示
    volumeView=[MPVolumeView new];
    volumeView.frame = CGRectMake(-1000, -1000, 60, 60);
    [self addSubview:volumeView];
    
    UIImage *blightImage = [UIImage imageNamed:@"blight"];
    UIImage *voiceImage = [UIImage imageNamed:@"volume"];
    
    blightView =[[UIImageView alloc] initWithFrame:CGRectMake((KScreenH-150)/2,(KScreenW-150)/2, 150, 150)];
    blightView.image =blightImage;
    blightView.alpha=0.0;
    blightView.backgroundColor =[UIColor clearColor];
    [self addSubview:blightView];
    
    voiceView =[[UIImageView alloc] initWithFrame:CGRectMake((KScreenH-150)/2,(KScreenW-150)/2, 150, 150)];
    voiceView.image =voiceImage;
    voiceView.alpha=0.0;
    voiceView.backgroundColor =[UIColor clearColor];
    [self addSubview:voiceView];
    
    blightPtogress =[[UIProgressView alloc] initWithFrame:CGRectMake(20,blightView.frame.size.height-20,blightView.frame.size.width-40,20)];
    blightPtogress.backgroundColor = [UIColor clearColor];
    blightPtogress.trackTintColor =[UIColor blackColor];
    blightPtogress.progressTintColor =[UIColor whiteColor];
    blightPtogress.progress =0.5f;
    // 改变进度条的粗细
    blightPtogress.transform = CGAffineTransformMakeScale(1.0f,2.0f);
    blightPtogress.progressViewStyle=UIProgressViewStyleBar;
    [blightView addSubview:blightPtogress];
    
    volumeProgress =[[UIProgressView alloc] initWithFrame:CGRectMake(20,blightView.frame.size.height-20,blightView.frame.size.width-40,20)];
    volumeProgress.backgroundColor = [UIColor clearColor];
    volumeProgress.trackTintColor =[UIColor blackColor];
    volumeProgress.progress =0.5f;
    volumeProgress.transform = CGAffineTransformMakeScale(1.0f,2.0f);
    volumeProgress.progressViewStyle=UIProgressViewStyleBar;
    volumeProgress.progressTintColor =[UIColor whiteColor];
    [voiceView addSubview:volumeProgress];
    
    */
    
    //默认第一次需要判断 YES
    self.oneNetWork = YES;
    //默认竖屏顶部view隐藏
    self.topView.hidden = YES;
    
}
#pragma mark  ---按钮点击事件
// 顶部view 返回事件
-(void)selectBackBtnActon:(UIButton *) sender{
    
    self.backBlock(YES);
}
//点击暂停播放按钮
-(void)selectdPlayBtnAction:(UIButton *) sender{
    __weak typeof(self) weakSelf = self;
    sender.selected = !sender.selected;
    //
    if (sender.selected) {
        //第一次播放网络判断
        if (self.oneNetWork) {
            self.oneNetWork = NO;
            //网络判断
            [KRMainNetTool ysy_hasNetwork:^(NSString *net) {

                [weakSelf alterNetWork:net];
            }];
        }else{
            //播放
            self.btnBlock(YES);
        }
    }else{
        //暂停
        self.btnBlock(NO);
    }
}
-(void)setNetWorkStatu:(NSString *)netWorkStatu{
    
    _netWorkStatu = netWorkStatu;
  
    [self alterNetWork:netWorkStatu];
}
//判断网络状态
-(void) alterNetWork:(NSString *)workStau {
    //隐藏
    self.networkStatuView.hidden = NO;

    if (![workStau isEqualToString:@"NO"]) {
        if ([workStau isEqualToString:@"WIFI"]) {
            //开始转动
            [self.activeView startAnimating];
            //显示菊花
            self.activeView.hidesWhenStopped = NO;
            //继续播放
            self.btnBlock(YES);
        }else{
            
            //隐藏菊花
            self.activeView.hidesWhenStopped = YES;
            //停止转动
            [self.activeView stopAnimating];
            
            self.networkStatuView.hidden = NO;
            
            self.networkStatuView.hideLab.text = @"使用手机流量会产生资费，是否继续播放!";
            //暂停播放
            self.btnBlock(NO);
        }
    }else{
        //停止转动
        [self.activeView stopAnimating];
        //隐藏菊花
        self.activeView.hidesWhenStopped = YES;
        
        self.networkStatuView.hidden = NO;
        self.networkStatuView.hideLab.text = @"没有网络，请重新连接网络！";
        self.networkStatuView.palyBtn.hidden = YES;
        //暂停播放
        self.btnBlock(NO);
    }
}
//横屏
-(void)selectdHPBtnAction:(UIButton *) sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        //显示返回按钮
        self.networkStatuView.backBtn.hidden = NO;
        // 显示顶部view
        self.topView.hidden = NO;
        //隐藏竖屏返回按钮
        self.networkStatuView.backBtn.hidden = YES;
    }else{
        //隐藏返回按钮
        self.networkStatuView.backBtn.hidden = YES;
        // 隐藏背景色
     //   self.backGrouView.hidden = YES;
        // 隐藏顶部view
        self.topView.hidden = YES;
        //显示竖屏返回按钮
        self.networkStatuView.backBtn.hidden = NO;
    }
    //是否全屏 YES 全屏 NO 竖屏
    self.hpBlock(sender.selected);
}
#pragma mark ----手势事件---
//点击事件
-(void)selectGestTap:(UITapGestureRecognizer *) sender{

    //每次点击取消还在进程中的隐藏方法
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideView) object:nil];
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
            [self performSelector:@selector(hideView) withObject:nil afterDelay:4];
        }
    }];
 
}
-(void)hideView{
    [UIView animateWithDuration:0.25 animations:^{
        self.coverView.alpha = 0 ;
    }completion:^(BOOL finished) {
        self.coverView.hidden = YES;
        _hideTool = YES;
    }];
}
-(void) selectdDouleTap:(UITapGestureRecognizer *) sender{
    
    //双击事件
    [self selectdPlayBtnAction:self.playBtn];

}

//滑动事件
-(void)selectGestViewPan:(UIPanGestureRecognizer *)sender{
    
    CGPoint point= [sender locationInView:self];
    
    typedef NS_ENUM(NSUInteger, UIPanGestureRecognizerDirection) {
        UIPanGestureRecognizerDirectionUndefined,
        UIPanGestureRecognizerDirectionUp,
        UIPanGestureRecognizerDirectionDown,
        UIPanGestureRecognizerDirectionLeft,
        UIPanGestureRecognizerDirectionRight
    };
    static UIPanGestureRecognizerDirection direction = UIPanGestureRecognizerDirectionUndefined;
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            if (direction == UIPanGestureRecognizerDirectionUndefined) {
                CGPoint velocity = [sender velocityInView:self];
                
                BOOL isVerticalGesture = fabs(velocity.y) > fabs(velocity.x);
                if (isVerticalGesture) {
                    if (velocity.y > 0) {
                        direction = UIPanGestureRecognizerDirectionDown;
                    } else {
                        direction = UIPanGestureRecognizerDirectionUp;
                    }
                }
                else {
                    if (velocity.x > 0) {
                        direction = UIPanGestureRecognizerDirectionRight;
                    } else {
                        direction = UIPanGestureRecognizerDirectionLeft;
                    }
                }
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            
            switch (direction) {
                case UIPanGestureRecognizerDirectionUp: {
                    
                    float dy = point.y - _currentPoint.y;
                    int index = (int)dy;
                    // 左侧 上下改变亮度
                    if(_currentPoint.x <self.frame.size.width/2){
                        blightView.alpha =1.0f;
                        if(index >0){
                            [UIScreen mainScreen].brightness = [UIScreen mainScreen].brightness- 0.01;
                        }else{
                            [UIScreen mainScreen].brightness = [UIScreen mainScreen].brightness+ 0.01;
                        }
                        blightPtogress.progress =[UIScreen mainScreen].brightness;
                    }else{// 右侧上下改变声音
                        voiceView.alpha =1.0f;
                        if(index>0){
                            [self setVolumeDown];
                        }else{
                            [self setVolumeUp];
                        }
                        volumeProgress.progress =_systemVolume;
                    }
                    break;
                }
                case UIPanGestureRecognizerDirectionDown: {
                    
                    float dy = point.y - _currentPoint.y;
                    int index = (int)dy;
                    // 左侧 上下改变亮度
                    if(_currentPoint.x <self.frame.size.width/2){
                        blightView.alpha =1.0f;
                        if(index >0){
                            [UIScreen mainScreen].brightness = [UIScreen mainScreen].brightness- 0.01;
                        }else{
                            [UIScreen mainScreen].brightness = [UIScreen mainScreen].brightness+ 0.01;
                        }
                        blightPtogress.progress =[UIScreen mainScreen].brightness;
                    }else{// 右侧上下改变声音
                        voiceView.alpha =1.0f;
                        if(index>0){
                            [self setVolumeDown];
                        }else{
                            [self setVolumeUp];
                        }
                        volumeProgress.progress =_systemVolume;
                    }
                    break;
                }
                default: {
                    break;
                }
            }
            break;
        }
        case UIGestureRecognizerStateEnded: {
            _isGes =NO;
            NSLog(@"end");
            
            direction = UIPanGestureRecognizerDirectionUndefined;
            [UIView animateWithDuration:0.5f animations:^{
                blightView.alpha =0.0f;
                voiceView.alpha=0.0f;
            }];
            break;
        }
        default:
            break;
    }
    
}
-(void)setVolumeUp
{
    _systemVolume = _systemVolume+0.01;
    
}
-(void)setVolumeDown{
    
    _systemVolume = _systemVolume-0.01;
    
}



@end
