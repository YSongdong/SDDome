//
//  PlayerToolView.m
//  SDMonitSystem
//
//  Created by tiao on 2018/3/18.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "PlayerToolView.h"



typedef NS_ENUM(NSUInteger, Direction) {
    DirectionLeftOrRight,
    DirectionUpOrDown,
    DirectionNone
};
@interface PlayerToolView () <ZYLButtonDelegate>
@property (nonatomic,strong) UIButton  *hpBtn;     //横竖屏按钮

@property (weak, nonatomic) UIView *playerView;

////直播封面遮蔽层image
@property (nonatomic,strong) UIImageView *suspImage;

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

@end

@implementation PlayerToolView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self createUI];
    }
    return self;
}

-(void) createUI{
    __weak typeof(self) weakSelf = self;
    
    self.backGrouView= [[UIView alloc]initWithFrame:self.bounds];
    self.backGrouView.backgroundColor = [UIColor clearColor];
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
    
    self.activeView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    [_coverView addSubview:self.activeView];
    //设置小菊花的frame
    [self.activeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@100);
        make.centerX.equalTo(_coverView.mas_centerX);
        make.centerY.equalTo(_coverView.mas_centerY);
    }];
    //设置小菊花颜色
    self.activeView.color = [UIColor whiteColor];
    //设置背景颜色
    self.volumeViewSlider.backgroundColor = [UIColor clearColor];
    //刚进入这个界面会显示控件，并且停止旋转也会显示，只是没有在转动而已，没有设置或者设置为YES的时候，刚进入页面不会显示
    self.activeView.hidesWhenStopped = NO;
    //开始转动
    [self.activeView startAnimating];
    
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
        
        weakSelf.btnBlock(YES);
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
//判断网络状态
-(void) alterNetWork:(NSString *)workStau {
    //隐藏返回按钮
    self.hideView.backBtn.hidden = YES;
    
    if (![workStau isEqualToString:@"NO"]) {
        if ([workStau isEqualToString:@"WIFI"]) {
            self.hideView.hidden = YES;
            //开始转动
            [self.activeView startAnimating];
            //显示菊花
            self.activeView.hidesWhenStopped = NO;
            //继续播放
            self.btnBlock(YES);
        }else{
        
            //显示菊花
            self.activeView.hidesWhenStopped = YES;
            
            self.hideView.hidden = NO;
            
            self.hideView.hideLab.text = @"使用手机流量会产生资费，是否继续播放!";
            //暂停播放
            self.btnBlock(NO);
        }
    }else{
        //停止转动
        [self.activeView stopAnimating];
        //隐藏菊花
        self.activeView.hidesWhenStopped = YES;
        
        self.hideView.hidden = NO;
        self.hideView.hideLab.text = @"没有网络，请重新连接网络！";
        self.hideView.palyBtn.hidden = YES;
        self.btnBlock(NO);
       
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
    //全屏下返回按钮
    self.backBlock(YES);
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
    //是否全屏 YES 全屏 NO 竖屏
    self.hpBlock(sender.selected);
}

//继续播放
-(void)palyBtnAction:(UIButton *) sender{
    
    //继续播放
    self.btnBlock(YES);
    
    self.coverImage.hidden = YES;
    //隐藏加载条
    self.activeView.hidesWhenStopped = YES;
    [self.activeView stopAnimating];
    
    self.hideView.hidden = YES;
   
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


@end
