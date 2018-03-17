//
//  MineMonitViewController.m
//  SDMonitSystem
//
//  Created by tiao on 2018/1/22.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "MineMonitViewController.h"


#import "UserInfoView.h"
#import "ShowSpaceView.h"
#import "ProjectViewController.h"

#import "MineSetViewController.h"
#import "MonitorTableViewCell.h"

#define MONITORTABLEVIEW_CELL @"MonitorTableViewCell"

@interface MineMonitViewController ()<UITableViewDelegate,UITableViewDataSource>
//用户view
@property (nonatomic,strong)UserInfoView  *userView;

@property (nonatomic,strong) UITableView *proTableView;

@property (nonatomic,strong) NSMutableArray *dataArr;
//分页
@property (nonatomic,assign) NSInteger  page;
//空白页
@property (nonatomic,strong) ShowSpaceView *showSpaceView;

@end

@implementation MineMonitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    //设置导航栏
    [self initNaviBar];
    //设置用户信息view
    [self initUserInfoView];
    //请求数据
    [self requestLoadData];
 
    //创建tableiview
    [self initTableView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //请求数据
   // [self requestLoadData];
    self.navBarBgAlpha = @"1.0";
}
#pragma mark ----创建Tableview--
-(void)initTableView{
    self.proTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, KSIphonScreenH(185)+SafeAreaTopHeight, KScreenW, KScreenH-SafeAreaTopHeight-KSIphonScreenH(185)-49-SafeAreaBottomHeight)];
    [self.view addSubview:self.proTableView];
    self.proTableView.backgroundColor = [UIColor whiteColor];
    self.proTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.proTableView.delegate = self;
    self.proTableView.dataSource = self;
    self.proTableView.showsHorizontalScrollIndicator = NO;
    
    [self.proTableView registerNib:[UINib nibWithNibName:MONITORTABLEVIEW_CELL bundle:nil] forCellReuseIdentifier:MONITORTABLEVIEW_CELL];
    
    //加载空白页
    self.showSpaceView =[ [ShowSpaceView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, CGRectGetHeight(self.proTableView.frame))];
    self.showSpaceView.lab.text = @"暂无项目";
    [self.proTableView addSubview:self.showSpaceView];
    
    __weak typeof(self) weakSelf = self;
    self.proTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf requestLoadData];
    } ];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf requestLoadData];
    }];
    
    self.proTableView.mj_footer = footer;
    footer.refreshingTitleHidden = YES;
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"" forState:MJRefreshStatePulling];
    [footer setTitle:@"" forState:MJRefreshStateRefreshing];
    //隐藏footer
    weakSelf.proTableView.mj_footer.hidden = YES;
}
#pragma mark ----UITableViewDataSoucre---
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MonitorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MONITORTABLEVIEW_CELL forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dict = self.dataArr[indexPath.row];
    return cell;
    
}
#pragma mrak --- UITableViewDelegate---
//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     return 340*kWJHeightCoefficient;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.hidesBottomBarWhenPushed = YES;
    NSDictionary *dict = self.dataArr[indexPath.row];
    ProjectViewController *projeVC = [[ProjectViewController alloc]init];
    projeVC.projectID = dict[@"ID"];
    projeVC.projectName = dict[@"Name"];
    [self.navigationController pushViewController:projeVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}
#pragma mrak ---- 用户信息view ----
-(void) initUserInfoView{
    self.userView = [[UserInfoView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, KScreenW, KSIphonScreenH(185))];
    [self.view addSubview:self.userView];
}
#pragma mark -----设置导航栏----
-(void) initNaviBar{
    [self customNaviItemTitle:@"我的监控" titleColor:[UIColor whiteColor]];
    [self customTabBarButtonimage:@"user_sett" target:self action:@selector(rightBtnAction:) isLeft:NO];
    [self getSub:self.navigationController.navigationBar andLevel:1];
    
}
// 获取子视图
- (void)getSub:(UIView *)view andLevel:(int)level {
    NSArray *subviews = [view subviews];
    if ([subviews count] == 0) return;
    for (UIView *subview in subviews) {
        
        NSString *blank = @"";
        for (int i = 1; i < level; i++) {
            blank = [NSString stringWithFormat:@"  %@", blank];
        }
        [self getSub:subview andLevel:(level+1)];
    }
}
//设置
-(void)rightBtnAction:(UIButton *) sender{
    self.hidesBottomBarWhenPushed = YES;
    MineSetViewController *setVC = [[MineSetViewController alloc]init];
    [self.navigationController pushViewController:setVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
//请求数据
-(void) requestLoadData{
    
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"jsession"] = [UserInfo obtainWithMarks];
    param[@"page"] = [NSNumber numberWithInteger:self.page];
    [[KRMainNetTool sharedKRMainNetTool] postRequstWith:SystemProject_URL params:param withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        
        [weakSelf.proTableView.mj_footer endRefreshing];
        [weakSelf.proTableView.mj_header endRefreshing];
        if (!error) {
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
                        weakSelf.showSpaceView.hidden = NO;
                    }else if (weakSelf.dataArr.count == [showdata[@"count"] integerValue]) {
//                        weakSelf.proTableView.mj_footer.state = MJRefreshStateNoMoreData;
                        [SVProgressHUD showSuccessWithStatus:@"暂无更多数据"];
                        [SVProgressHUD dismissWithDelay:1];
                    }
                }
            }else{
                [SVProgressHUD showErrorWithStatus:showdata[@"msg"]];
                [SVProgressHUD dismissWithDelay:1];
            }
             [weakSelf.proTableView reloadData];
            
        }else{
            [SVProgressHUD showErrorWithStatus:error];
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
