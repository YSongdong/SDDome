//
//  DetaViewController.m
//  SDMonitSystem
//
//  Created by tiao on 2018/3/18.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "DetaViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "PlayerToolView.h"
#import "ShowSpaceView.h"
#import "ProTableHeaderView.h"
#import "DetaTableViewCell.h"
#define DETATABEVIEW_CEL  @"DetaTableViewCell"

@interface DetaViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
UIGestureRecognizerDelegate,
UIScrollViewDelegate
>

@property (nonatomic, retain) id <IJKMediaPlayback> player;//播放器
@property (weak, nonatomic) UIView *playerView;
//headerView
@property (nonatomic,strong) ProTableHeaderView *headerView;
//播放工具VIew
@property (nonatomic,strong) PlayerToolView *toolView;
//判断是横屏还是竖屏  YES 横屏 NO 竖屏
@property (nonatomic,assign) BOOL  isHP;
@property (nonatomic,strong) UITableView *proTableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
//空白页
@property (nonatomic,strong) ShowSpaceView *showSpaceView;
//置顶按钮
@property (nonatomic,strong) UIButton *topBtn;
//分页
@property (nonatomic,assign) NSInteger  page;

//记录是哪个cell弹出查看大图view
@property (nonatomic,strong) NSIndexPath *bigIndexPath;

@end

@implementation DetaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor TableViewBackGrounpColor];
    self.page = 1 ;
    self.isHP = NO;
    //设置导航栏
    [self initNaviBar];
    [self createUI];
    //请求播放地址
    [self requestLoadData];
    //请求违规列表
    [self requestProjectRecordData];
    //创建headerView
    [self initHeaderView];
    //创建tableview
    [self initTableView];
    
    //注册通知
    [self registerNotifi];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.player shutdown];
    [self.player.view removeFromSuperview];
    self.player = nil;
}
//注册通知
-(void) registerNotifi{
    //注册通知
    //程序从前台退到后台
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification  object:nil];
    //app从后台推到前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground)name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    //获取网络状态
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(networkTifi:) name:@"NetWorkStatu" object:nil];
   
}

//右滑返回delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    //结束播放
    [self.player shutdown];
    [self.player.view removeFromSuperview];
    self.player = nil;
    return YES;
}
#pragma mark ---headerView---
-(void) initHeaderView{
    self.headerView =[[ProTableHeaderView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight+CGRectGetHeight(self.toolView.frame)+2, KScreenW, KSIphonScreenH(40))];
    [self.view addSubview:self.headerView];
}
#pragma mark -----设置导航栏----
-(void) initNaviBar{
    [self customNaviItemTitle:self.dict[@"name"] titleColor:[UIColor whiteColor]];
    
    [self customTabBarButtonimage:@"back_wither" target:self action:@selector(rightBtnAction:) isLeft:YES];
    
}
-(void)rightBtnAction:(UIButton *) sender{
  
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ----UITableViewDataSource  UITableViewDelegate---
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    DetaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DETATABEVIEW_CEL forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dict = self.dataArr[indexPath.row];
    __weak typeof(self) weakSelf = self;
    cell.btnBlock = ^(BOOL isBack) {
        if (isBack) {
            //返回
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            //横屏
            [weakSelf landscapAction:nil];
        }
    };
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.dataArr[indexPath.row];
    
    return [DetaTableViewCell cellHeightDict:dict];
}
#pragma mark  ----- 通知事件-------
//app从前台退到后台
-(void) applicationDidEnterBackground
{
    //暂停播放
    [self.player pause];
}
//app从后台推到前台
-(void)applicationWillEnterForeground
{
   
    if (self.isHP) {
            //先横屏
            [self landscapAction:nil];
    }else{
            [self portraitAction:nil];
    }
    //继续播放
    [self.player play];
}
- (void)statusBarOrientationChange:(NSNotification *)notification {
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (orientation == UIDeviceOrientationLandscapeLeft) {
        
        [self alterVodPlayHPFrame:YES];
        
    }else if (orientation == UIDeviceOrientationLandscapeRight) {
        
        [self alterVodPlayHPFrame:YES];
        
    }else if (orientation == UIDeviceOrientationPortrait) {
        
        [self alterVodPlayHPFrame:NO];
            
      
    }
}
//网络状态通知事件
-(void)networkTifi:(NSNotification *) tifi{
    
    NSString *network = [tifi.userInfo objectForKey:@"netwrok"];

    self.toolView.netWorkStatu = network;
   
}
#pragma mark -----横竖屏处理事件 ------
// 横屏
- (void)landscapAction:(id)sender {
    
    [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
    [self alterVodPlayHPFrame:YES];
}
// 竖屏
- (void)portraitAction:(id)sender {
    
    [self interfaceOrientation:UIInterfaceOrientationPortrait];
    [self alterVodPlayHPFrame:NO];
}
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}
//控制vodPlayView是否横竖Ping  YES 横屏 NO 竖屏
-(void) alterVodPlayHPFrame:(BOOL)isHP{
    if (isHP) {
        //直播
        self.navigationController.navigationBar.hidden = YES;
        self.toolView.frame = CGRectMake(0, 0, KScreenW, KScreenH);
        self.toolView.showView.frame = CGRectMake(SafeAreaHPNaviTopHeight, 0, KScreenW-SafeAreaHPBottomHeight-SafeAreaHPNaviTopHeight, KScreenH);
        self.toolView.coverImage.frame = self.toolView.showView.frame;
        self.toolView.coverView.frame = self.toolView.showView.frame;
        self.toolView.backGrouView.frame = self.toolView.showView.frame;
        self.headerView.hidden = YES;
        self.proTableView.hidden = YES;
        self.topBtn.hidden = YES;
        
    }else{
        //直播
        self.navigationController.navigationBar.hidden = NO;
        self.toolView.frame = CGRectMake(0, 0, KScreenW, KScreenH);
        self.toolView.showView.frame = CGRectMake(0, SafeAreaTopHeight, KScreenW, KSIphonScreenH(220));
        self.toolView.coverImage.frame = self.toolView.showView.frame;
        self.toolView.coverView.frame = self.toolView.showView.frame;
        self.toolView.backGrouView.frame = self.toolView.frame;
        self.headerView.hidden = NO;
        self.proTableView.hidden = NO;

    }
}
#pragma mark  -- 状态栏--------
//状态栏文字颜色
-(UIStatusBarStyle)preferredStatusBarStyle
{
    //白色文字，深色背景时使用
    return UIStatusBarStyleLightContent;
}
//状态栏的隐藏
- (BOOL)prefersStatusBarHidden {
    
    return NO;
    
}
-(void)createUI{
    __weak typeof(self) weakSelf = self;
    //创建toolview
    self.toolView = [[PlayerToolView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, KScreenW, KSIphonScreenH(220))];
    [self.view addSubview:self.toolView];
    //判断是否播放YES NO
    self.toolView.btnBlock = ^(BOOL isPlay) {
        if (isPlay) {
            //继续播放
            [weakSelf.player play];
            weakSelf.toolView.hideView.hidden = YES;
            weakSelf.toolView.suspendView.hidden = YES;
            

        }else{
            //暂停播放
            [weakSelf.player pause];
            weakSelf.toolView.suspendView.hidden = NO;
            weakSelf.toolView.playBtn.hidden = NO;
            
        }
    };
    //判断是否全屏
    self.toolView.hpBlock = ^(BOOL isHP) {
        if (isHP) {
            //全屏
            [weakSelf landscapAction:nil];
            weakSelf.isHP = YES;

        }else{
            //竖屏
            [weakSelf portraitAction:nil];
            weakSelf.isHP = NO;

        }
    };
    //全屏下返回按钮
    self.toolView.backBlock = ^(BOOL isBack) {
        if (isBack) {
            [weakSelf portraitAction:nil];
            weakSelf.isHP = NO;
        }
    };
}
#pragma mark  ----创建播放器-----
-(void) createPlayer:(NSString *)url{
    //播放器
    IJKFFOptions *options = [IJKFFOptions optionsByDefault]; //使用默认配置
    
    [options setFormatOptionValue:@"tcp" forKey:@"rtsp_transport"];
    
    [options setOptionIntValue:2 forKey:@"videotoolbox" ofCategory:kIJKFFOptionCategoryPlayer];
    
    _player = [[IJKFFMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:url] withOptions:options];
    
    UIView *playerView = [self.player view];
    
    self.playerView = self.toolView.showView;
    
    playerView.frame = self.toolView.showView.frame;
    playerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.playerView insertSubview:playerView atIndex:0];
    //缩放模式为FILL
    //  [_player setScalingMode:IJKMPMovieScalingModeAspectFit];
    self.player.shouldAutoplay = YES;
    [self.player prepareToPlay];
    [self installMovieNotificationObservers];
    
}
#pragma mark ----UITableView----
-(void)initTableView{
    self.proTableView =[[UITableView alloc]initWithFrame:CGRectMake(0,SafeAreaTopHeight+CGRectGetHeight(self.toolView.frame)+CGRectGetHeight(self.headerView.frame)+2, KScreenW, KScreenH-CGRectGetHeight(self.toolView.frame)-CGRectGetHeight(self.headerView.frame)-2-SafeAreaTopHeight) style:UITableViewStylePlain];
    [self.view addSubview:self.proTableView];
    
    self.proTableView.separatorColor = [UIColor lineBackGrounpColor];
    self.proTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.proTableView.delegate = self;
    self.proTableView.dataSource = self;
    
    //适配ios 11
    if (@available(iOS 11.0, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        
    }
    [self.proTableView registerClass:[DetaTableViewCell class] forCellReuseIdentifier:DETATABEVIEW_CEL];
 
    //加载空白页
    self.showSpaceView =[ [ShowSpaceView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, CGRectGetHeight(self.proTableView.frame))];
    self.showSpaceView.lab.text = @"暂无违规记录";
    [self.proTableView addSubview:self.showSpaceView];
    
    __weak typeof(self) weakSelf = self;
    self.proTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf requestProjectRecordData];
    } ];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf requestProjectRecordData];
    }];
    
    self.proTableView.mj_footer = footer;
    footer.refreshingTitleHidden = YES;
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"" forState:MJRefreshStatePulling];
    [footer setTitle:@"" forState:MJRefreshStateRefreshing];
    //隐藏footer
    self.proTableView.mj_footer.hidden = YES;
    
    //加载置顶按钮
    self.topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.topBtn];
    [self.topBtn setTitle:@"顶部" forState:UIControlStateNormal];
    self.topBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.topBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.topBtn.backgroundColor = [UIColor tabBarItemTextColor];
    [self.topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@50);
        make.right.equalTo(weakSelf.view).offset(-15);
        make.bottom.equalTo(weakSelf.view).offset(-40);
    }];
    self.topBtn.layer.cornerRadius = 25;
    self.topBtn.layer.masksToBounds = YES;
    self.topBtn.hidden = YES;
    [self.topBtn addTarget:self action:@selector(selectdOnTapBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];

}
-(void)selectdOnTapBtnAction:(UIButton *)  sender{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.proTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
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
            NSLog(@"playbackStateDidChange: 播放完毕: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonUserExited:
             NSLog(@"playbackStateDidChange: 用户退出播放: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
            //隐藏加载条
            self.toolView.activeView.hidesWhenStopped = YES;
            [self.toolView.activeView stopAnimating];
            //隐藏封面
            self.toolView.coverImage.hidden = YES;
            //网络断连层
            self.toolView.hideView.hidden = NO;
            self.toolView.hideView.hideLab.text = @"没有网络，请重新连接网络！";
            self.toolView.hideView.palyBtn.hidden = YES;
            
            NSLog(@"playbackStateDidChange: 播放出现错误: %d\n", reason);
            break;
            
        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification {
    //结束转动
    [self.toolView.activeView stopAnimating];
    self.toolView.activeView.hidden = YES;
    //隐藏封面
    self.toolView.coverImage.hidden = YES;
    
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
}
#pragma mark ----数据相关------
-(void)setDeviceID:(NSString *)deviceID{
    _deviceID = deviceID;
}
//播放地址
-(void) requestLoadData{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"did"] =self.dict[@"did"];
    param[@"vid"] = self.dict[@"vid"];
    param[@"way"] = self.dict[@"way"];
    param[@"jsession"] = [UserInfo obtainWithMarks];
    param[@"name"] = self.dict[@"name"];
    [[KRMainNetTool sharedKRMainNetTool] postRequstWith:SystemProjectInfo_URL params:param withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        NSNumber *code = showdata[@"code"];
        
        if ([code integerValue] == 0) {
            NSDictionary *dict = showdata[@"data"];
            //封面
            [UIImageView sd_setImageView:weakSelf.toolView.coverImage WithURL:weakSelf.dict[@"header_img"]];
            //url
            [weakSelf createPlayer:dict[@"rtsp"]];
        }else{
            [SVProgressHUD showErrorWithStatus:showdata[@"msg"]];
            [SVProgressHUD dismissWithDelay:1];
        }
        
    }];
}
//违规列表
-(void) requestProjectRecordData{
    
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    param[@"ChnIndex"] = self.dict[@"way"];
    param[@"nvr_sn"] = self.dict[@"did"];
    param[@"projectId"] = self.projectID;
    param[@"limit"] = @"10";
    param[@"page"] = [NSNumber numberWithInteger:self.page];
    [[KRMainNetTool sharedKRMainNetTool] postRequstWith:SystemBehaviorRecord_URL params:param withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        
        [weakSelf.proTableView.mj_footer endRefreshing];
        [weakSelf.proTableView.mj_header endRefreshing];
        
        if (error) {
            [SVProgressHUD showErrorWithStatus:error];
            [SVProgressHUD dismissWithDelay:1];
            return ;
        }
     //   NSLog(@"-----11111111====%@----",showdata);
        NSNumber *code = showdata[@"code"];
        if ([code integerValue] == 0) {
            //显示foot
            weakSelf.proTableView.mj_footer.hidden = NO;
            NSArray *dataArr = showdata[@"data"];
            if (dataArr.count > 0) {
                //隐藏空白页
                weakSelf.showSpaceView.hidden = YES;
                //判断
                if (weakSelf.page == 1) {
                    [weakSelf.dataArr removeAllObjects];
                }
                [weakSelf.dataArr addObjectsFromArray:dataArr];
                //保存第一个项目
                NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
                NSDictionary *dic = self.dataArr[0];
                [userD setObject:dic forKey:@"project"];
                
                [weakSelf.proTableView reloadData];
                
            }else{
                //判断是否没有项目
                NSNumber *count = showdata[@"count"];
                if ([count integerValue] == 0) {
                    weakSelf.showSpaceView.hidden = YES;
                    weakSelf.proTableView.mj_footer.hidden = YES;
                    [weakSelf.dataArr removeAllObjects];
                    //删除NSUser对象
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"project"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [weakSelf.proTableView reloadData];
                    
                    weakSelf.showSpaceView.hidden = NO;
                }else if (weakSelf.dataArr.count == [showdata[@"count"] integerValue]) {
                    
                    // weakSelf.proTableView.mj_footer.state = MJRefreshStateNoMoreData;
                    [SVProgressHUD showSuccessWithStatus:@"暂无更多数据"];
                    [SVProgressHUD dismissWithDelay:1];
                }
            }
        }else{
            [SVProgressHUD showErrorWithStatus:showdata[@"msg"]];
            [SVProgressHUD dismissWithDelay:1];
        }
        
    }];
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
    
}


@end