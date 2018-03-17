//
//  ProDetaViewController.m
//  SDMontir
//
//  Created by tiao on 2018/1/19.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "ProDetaViewController.h"

#import "TXLitePlayView.h"
#import "VodPlayView.h"
#import "ProTableHeaderView.h"
#import "ShowSpaceView.h"
#import "ProDetaTableViewCell.h"
#define PRODETATABLEVIEW_CELL @"ProDetaTableViewCell"
@interface ProDetaViewController ()
<UITableViewDelegate,
UITableViewDataSource,
VodPlayViewDelegate,
UIGestureRecognizerDelegate,
UIScrollViewDelegate
>
//直播view
@property (nonatomic,strong) TXLitePlayView *playView;
//回放view
@property (nonatomic,strong) VodPlayView *vodPalyView;

@property (nonatomic,strong) UITableView *proTableView;
@property (nonatomic,strong) NSMutableArray *dataArr;

//headerView
@property (nonatomic,strong) ProTableHeaderView *headerView;
//判断是否是录播   YES 录播 NO 直播
@property (nonatomic,assign) BOOL isVodTxl;
//判断是横屏还是竖屏  YES 横屏 NO 竖屏
@property (nonatomic,assign) BOOL  isHP;

//分页
@property (nonatomic,assign) NSInteger  page;
//空白页
@property (nonatomic,strong) ShowSpaceView *showSpaceView;
//置顶按钮
@property (nonatomic,strong) UIButton *topBtn;
@end

@implementation ProDetaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor TableViewBackGrounpColor];
    self.page = 1 ;
    self.isHP = NO;
    //设置导航栏
    [self initNaviBar];
    //创建直播view
    [self initLitePalyView];
    //播放地址
    [self requestLoadData];
    //请求违规列表
    [self requestProjectRecordData];
    //创建headerView
    [self initHeaderView];
    //创建tableiview
    [self initTableView];
    //注册通知
    [self registerNotifi];
   
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
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
    [_playView endStopPlay];
    return YES;
}
#pragma mark ----UITableViewDataSource  UITableViewDelegate---
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProDetaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PRODETATABLEVIEW_CELL forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    cell.dict = self.dataArr[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat hieght =[ProDetaTableViewCell heightForExplain:self.dataArr[indexPath.row][@"behavior"]];
    if (hieght > KSIphonScreenH(108)) {
         return [ProDetaTableViewCell heightForExplain:self.dataArr[indexPath.row][@"behavior"]];
    }else{
         return 108*kWJHeightCoefficient;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = self.dataArr[indexPath.row];
    
    //播放地址
    if (![dict[@"video_url"] isEqualToString:@""]) {
        
        //先暂停直播播放
        [self.playView txlPause];
        //设置为录播
        self.isVodTxl = YES;
        
        self.vodPalyView = [[VodPlayView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH)];
        
        self.vodPalyView.delegate = self;
        
        //先横屏
        [self landscapAction:nil];
        
        self.vodPalyView.url = dict[@"video_url"];
      //  self.vodPalyView.url = @"http://77ucb3.com1.z0.glb.clouddn.com/video.mp4";
        //封面图
        [Tool sd_setImageView:self.vodPalyView.coverImage WithURL:dict[@"image_url"]];
        
        self.vodPalyView.vodTitleLab.text = dict[@"behavior"];
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.vodPalyView];
        
    }else{

        [SVProgressHUD showErrorWithStatus:@"暂无视频！"];
        [SVProgressHUD dismissWithDelay:1];
    }

}//关闭view
-(void)selectdCloseBtn{
    //结束播放
    [self.vodPalyView releasePlayer];
    [self.vodPalyView removeFromSuperview];
    self.vodPalyView = nil;
    //设置为直播
    self.isVodTxl = NO;
    //强制竖屏
    [self portraitAction:nil];
}
#pragma mark ---headerView---
-(void) initHeaderView{
    self.headerView =[[ProTableHeaderView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight+CGRectGetHeight(self.playView.frame)+2, KScreenW, KSIphonScreenH(40))];
    [self.view addSubview:self.headerView];
}
#pragma mark -----设置导航栏----
-(void) initNaviBar{
    [self customNaviItemTitle:self.titleStr titleColor:[UIColor whiteColor]];
    
    [self customTabBarButtonimage:@"back_wither" target:self action:@selector(rightBtnAction:) isLeft:YES];

}
-(void)rightBtnAction:(UIButton *) sender{
    [self.playView releasePlayer];
    [self.playView removeFromSuperview];
    self.playView = nil;
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark  ----创建直播view----
-(void)initLitePalyView{
    
    self.playView = [[TXLitePlayView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, KScreenW, KSIphonScreenH(220))];
    __weak typeof(self) weakSelf = self;
    self.playView.btnBlock = ^(BOOL isSelectd) {
        if (isSelectd) {
            [weakSelf landscapAction:nil];
            weakSelf.isHP = YES;
        }else{
            [weakSelf portraitAction:nil];
            weakSelf.isHP = NO;
        }
    };
    [self.view addSubview:self.playView];
}
#pragma mark  ----- 通知事件-------
//app从前台退到后台
-(void) applicationDidEnterBackground
{
    if (!self.isVodTxl) {
        
    }else{
        
        [self.vodPalyView txlPause];
    }
}
//app从后台推到前台
-(void)applicationWillEnterForeground
{
    if (!self.isVodTxl) {
        if (self.isHP) {
            //先横屏
            [self landscapAction:nil];
        }else{
            [self portraitAction:nil];
        }
    }else{
        //先横屏
        [self landscapAction:nil];
        
        [self.vodPalyView txlResume];
    }
}
- (void)statusBarOrientationChange:(NSNotification *)notification {

    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (orientation == UIDeviceOrientationLandscapeLeft) {
  
        [self alterVodPlayHPFrame:YES];
      
    }else if (orientation == UIDeviceOrientationLandscapeRight) {
 
        [self alterVodPlayHPFrame:YES];
       
    }else if (orientation == UIDeviceOrientationPortrait) {
        if (!self.isVodTxl) {
            
            [self alterVodPlayHPFrame:NO];
            
        }else{
            
        }
    }
}
//网络状态通知事件
-(void)networkTifi:(NSNotification *) tifi{
 
    NSString *network = [tifi.userInfo objectForKey:@"netwrok"];
    if (!self.isVodTxl) {
        
        self.playView.netWorkStatu = network;
    }else{
        
        self.vodPalyView.netWorkStatu = network;
    }
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
         //判断是否是录播
        if (!self.isVodTxl) {
            //直播
            self.navigationController.navigationBar.hidden = YES;
            self.playView.frame = CGRectMake(0, 0, KScreenW, KScreenH);
            self.playView.showView.frame = CGRectMake(SafeAreaHPNaviTopHeight, 0, KScreenW-SafeAreaHPBottomHeight-SafeAreaHPNaviTopHeight, KScreenH);
            self.playView.coverImage.frame = self.playView.showView.frame;
            self.playView.coverView.frame = self.playView.showView.frame;
            self.playView.backGrouView.frame = self.playView.frame;
            self.headerView.hidden = YES;
            self.proTableView.hidden = YES;
            self.topBtn.hidden = YES;
        }else{
            self.vodPalyView.frame = CGRectMake(0, 0, KScreenW, KScreenH);
            self.vodPalyView.showView.frame = CGRectMake(SafeAreaHPNaviTopHeight, 0, KScreenW-SafeAreaHPBottomHeight-SafeAreaHPNaviTopHeight, KScreenH);
            self.vodPalyView.coverView.frame = self.vodPalyView.showView.frame;
            self.vodPalyView.coverImage.frame = self.vodPalyView.showView.frame;
            self.vodPalyView.backGrouView.frame = self.vodPalyView.frame;
        }
    }else{
        //判断是否是录播
        if (!self.isVodTxl) {
             //直播
            self.navigationController.navigationBar.hidden = NO;
            self.playView.frame = CGRectMake(0, 0, KScreenW, KScreenH);
            self.playView.showView.frame = CGRectMake(0, SafeAreaTopHeight, KScreenW, KSIphonScreenH(220));
            self.playView.coverImage.frame = self.playView.showView.frame;
            self.playView.coverView.frame = self.playView.showView.frame;
            self.playView.backGrouView.frame = self.playView.frame;
            self.headerView.hidden = NO;
            self.proTableView.hidden = NO;
        }
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
#pragma mark ----UITableView----
-(void)initTableView{
    self.proTableView =[[UITableView alloc]initWithFrame:CGRectMake(0,SafeAreaTopHeight+CGRectGetHeight(self.playView.frame)+CGRectGetHeight(self.headerView.frame)+2, KScreenW, KScreenH-CGRectGetHeight(self.playView.frame)-CGRectGetHeight(self.headerView.frame)-2-SafeAreaTopHeight) style:UITableViewStylePlain];
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
    [self.proTableView registerNib:[UINib nibWithNibName:PRODETATABLEVIEW_CELL bundle:nil] forCellReuseIdentifier:PRODETATABLEVIEW_CELL];
    
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
-(void)selectdOnTapBtnAction:(UIButton *)  sender{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.proTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];

}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark -----UIScrollDelegate----
//只要滚动了就会触发
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    if (scrollView == self.proTableView) {
        CGFloat index =  scrollView.contentOffset.y;
        
        if (index > 160) {
            self.topBtn.hidden = NO;
        }else{
            self.topBtn.hidden = YES;
        }
    }
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
            [UIImageView sd_setImageView:weakSelf.playView.coverImage WithURL:weakSelf.dict[@"header_img"]];
            //url
            weakSelf.playView.url = dict[@"rtsp"];
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
    param[@"page"] = [NSNumber numberWithInteger:self.page];
    [[KRMainNetTool sharedKRMainNetTool] postRequstWith:SystemBehaviorRecord_URL params:param withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        
        [weakSelf.proTableView.mj_footer endRefreshing];
        [weakSelf.proTableView.mj_header endRefreshing];
        
        if (error) {
            [SVProgressHUD showErrorWithStatus:error];
            [SVProgressHUD dismissWithDelay:1];
            return ;
        }
        NSLog(@"-----11111111====%@----",showdata);
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
