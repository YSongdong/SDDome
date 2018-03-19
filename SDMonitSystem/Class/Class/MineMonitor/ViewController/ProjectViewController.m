//
//  ProjectViewController.m
//  SDMonitSystem
//
//  Created by tiao on 2018/1/22.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "ProjectViewController.h"
#import "DetaViewController.h"
#import "ShowSpaceView.h"
#import "ProjectTableViewCell.h"
#define PROJECTTABLEVIEW_CELL  @"ProjectTableViewCell"
@interface ProjectViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *proTaleView;
@property (nonatomic,strong) NSMutableArray *dataArr;
//分页
@property (nonatomic,assign) NSInteger  page;
//空白页
@property (nonatomic,strong) ShowSpaceView *showSpaceView;
@end

@implementation ProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    //设置导航栏
    [self initNaviBar];
    //请求数据
    [self requestLoadData];
    //创建UITableView
    [self initTableView];
}
#pragma mark -----设置导航栏----
-(void) initNaviBar{
    [self customNaviItemTitle:self.projectName titleColor:[UIColor whiteColor]];
    [self customTabBarButtonimage:@"back_wither" target:self action:@selector(rightBtnAction:) isLeft:YES];
}
-(void)rightBtnAction:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --- 创建Taleview --
-(void) initTableView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.proTaleView = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, KScreenW, KScreenH-SafeAreaTopHeight) style:UITableViewStylePlain];
    self.proTaleView.tableFooterView =[[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.proTaleView];
    self.proTaleView.separatorStyle =UITableViewCellSeparatorStyleNone;
    
    self.proTaleView.delegate = self;
    self.proTaleView.dataSource = self;
    
    [self.proTaleView registerNib:[UINib nibWithNibName:PROJECTTABLEVIEW_CELL bundle:nil] forCellReuseIdentifier:PROJECTTABLEVIEW_CELL];
    
    //加载空白页
    self.showSpaceView =[ [ShowSpaceView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, CGRectGetHeight(self.proTaleView.frame))];
    self.showSpaceView.lab.text = @"暂无项目";
    [self.proTaleView addSubview:self.showSpaceView];
    
    __weak typeof(self) weakSelf = self;
    self.proTaleView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf requestLoadData];
    } ];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf requestLoadData];
    }];
    
    self.proTaleView.mj_footer = footer;
    footer.refreshingTitleHidden = YES;
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"" forState:MJRefreshStatePulling];
    [footer setTitle:@"" forState:MJRefreshStateRefreshing];
    
    self.proTaleView.mj_footer.hidden = YES;
}
#pragma mark ---UITableViewDataSource 、 UITableViewDelegate--
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PROJECTTABLEVIEW_CELL forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dict =self.dataArr[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   // return KSIphonScreenH(217);
     return 217*kWJHeightCoefficient;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed = YES;
    NSDictionary *dict =self.dataArr[indexPath.row];
    
    DetaViewController *detaVC = [[DetaViewController alloc]init];
    
    //项目ID
    detaVC.projectID = self.projectID;
    
    detaVC.deviceID = dict[@"did"];
   
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"did"] = dict[@"did"];
    param[@"name"] = dict[@"name"];
    param[@"vid"] = dict[@"vid"];
    param[@"way"] = dict[@"way"];
    param[@"header_img"] = dict[@"header_img"];
    detaVC.dict = param.copy;
    
    [self.navigationController pushViewController:detaVC animated:YES];
}
#pragma mark ----数据相关------
//请求数据
-(void) requestLoadData{
    
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"pid"] =self.projectID;
    param[@"page"] = [NSNumber numberWithInteger:self.page];
    param[@"jsession"] = [UserInfo obtainWithMarks];
   
    [[KRMainNetTool sharedKRMainNetTool] postRequstWith:SystemProjectList_URL params:param withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        
        [weakSelf.proTaleView.mj_footer endRefreshing];
        [weakSelf.proTaleView.mj_header endRefreshing];
       
        if (!error) {
            NSNumber *code = showdata[@"code"];
            if ([code integerValue] == 0) {
                //显示foot
                weakSelf.proTaleView.mj_footer.hidden = NO;
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
                    
                    [weakSelf.proTaleView reloadData];
                    
                }else{
                    //判断是否没有项目
                    NSNumber *count = showdata[@"count"];
                    if ([count integerValue] == 0) {
                        weakSelf.showSpaceView.hidden = YES;
                        weakSelf.proTaleView.mj_footer.hidden = YES;
                        [weakSelf.dataArr removeAllObjects];
                        //删除NSUser对象
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"project"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        [weakSelf.proTaleView reloadData];
                        
                        weakSelf.showSpaceView.hidden = NO;
                    }else if (weakSelf.dataArr.count == [showdata[@"count"] integerValue]) {
                        weakSelf.proTaleView.mj_footer.state = MJRefreshStateNoMoreData;
                        [SVProgressHUD showSuccessWithStatus:@"暂无更多数据"];
                        [SVProgressHUD dismissWithDelay:1];
                    }
                }
            }else{
                [SVProgressHUD showErrorWithStatus:showdata[@"msg"]];
                [SVProgressHUD dismissWithDelay:1];
            }
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
