//
//  MineCountViewController.m
//  SDMonitSystem
//
//  Created by tiao on 2018/1/22.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "MineCountViewController.h"

#import "CountEquiListView.h"
#import "NaviTitleView.h"
#import "SelectTimeHeaderView.h"
#import "ShowSpaceView.h"

#import "ProjectCountNumTableViewCell.h"
#import "RuleCountTableViewCell.h"
#import "EquipmentCountTableViewCell.h"
#import "ShowCalenarView.h"
#define PROJECTCOUNTTALEVIEW_CELL  @"ProjectCountNumTableViewCell"
#define RULECOUNTTABLEVIEW_CELL   @"RuleCountTableViewCell"
#define EQUIPMENTCOUNTTABLEVIEW_CELL @"EquipmentCountTableViewCell"

@interface MineCountViewController ()
<UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic,strong) UITableView *countTableView;

@property (nonatomic,strong) NSMutableArray *dataArr;
//统计的数量
@property (nonatomic,strong) NSMutableArray *statArr;
//违规统计
@property (nonatomic,strong) NSMutableArray *violArr;
//月份统计
@property (nonatomic,strong) NSMutableArray *timestArr;

//项目按钮
@property (nonatomic,strong) UIButton *equiBtn;
//项目弹框
@property (nonatomic,strong) CountEquiListView *listView;
//headerView
@property (nonatomic,strong) SelectTimeHeaderView *headerView;
//项目名字
@property (nonatomic,strong) UILabel *equiNameLab;
//自定义时间view
@property (nonatomic,strong) ShowCalenarView *calenderView;
//自定义naviView
@property (nonatomic,strong) NaviTitleView *titleView;

//配置参数
@property (nonatomic,strong) NSMutableDictionary *param;
//days  seven=>7天  week=>1周 month=>1个月
@property (nonatomic,strong) NSString *days;
//项目ID
@property (nonatomic,strong) NSString *project_id;
//是否显示自定义view
@property (nonatomic,assign) BOOL isShowTimeView;
//project_id
@property (nonatomic,strong) NSDictionary *idDict;
//判断是否有数据
@property (nonatomic,assign) BOOL isData;
//空白页
@property (nonatomic,strong) ShowSpaceView *showSpaceView;
@end

@implementation MineCountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShowTimeView = NO;
  
    [self createNaviBar];
    
  //  [self requestCountData];
    //创建tableview
    [self createTableView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //请求项目数据
    [self requestAgeLoadData];

}
#pragma mark  --- UITableViewDataSoucre
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        
        ProjectCountNumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PROJECTCOUNTTALEVIEW_CELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.data = self.statArr[indexPath.row];
        
        __weak typeof(self) weakSelf = self;
        cell.headerViewBlock = ^(UIButton *sender) {
            
            [weakSelf selectdTimeBtnAction:sender];
            
        };
        return cell;
        
    }
        //判断违规数组存在不
        if (self.violArr.count > 0) {
            if (indexPath.row == 1) {
                RuleCountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RULECOUNTTABLEVIEW_CELL forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.dataArr = self.violArr;
                return cell;
            }else{
                EquipmentCountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EQUIPMENTCOUNTTABLEVIEW_CELL forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.dataArr = self.timestArr;
                
                return cell;
            }
            
        }else{
            EquipmentCountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EQUIPMENTCOUNTTABLEVIEW_CELL forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            cell.dataArr = self.timestArr;

            return cell;

        }
    
  
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        
       // return KSIphonScreenH(150);
        return 150*kWJHeightCoefficient;
    }
    //判断违规数组存在不
    if (self.violArr.count > 0) {
        
        if (indexPath.row == 1) {
            
           // return KSIphonScreenH(267);
            return 267*kWJHeightCoefficient;
        }else{
            
          //  return KSIphonScreenH(250);
            return 250*kWJHeightCoefficient;
        }
    }else{
        
        // return KSIphonScreenH(250);
         return 250*kWJHeightCoefficient;
    }
    return 0;
}

-(void) selectdTimeBtnAction:(UIButton *)sender{
    /*
     typesof month=>按12月统计  project=>按项目统计 violat=>按违规类型统计
     days seven=>7天  week=>1周 month=>1个月
     datime 自定义时间
     project_id 项目id  如果不传就是所有
     keyid 云平台id  登陆的时候会给你返回
    */
    [self.param removeObjectForKey:@"datime"];
    __weak  typeof(self) weaSelf = self;
    switch (sender.tag-100) {
        case 0:
        {
            //移除之前存储的key
            [self.param removeObjectForKey:@"days"];
            
            //自定义选择时间
            _isShowTimeView = !_isShowTimeView;
            if (_isShowTimeView) {
                self.calenderView = [[ShowCalenarView alloc]initWithFrame:CGRectMake(0, 150*kWJHeightCoefficient, KScreenW, KScreenH)];
                self.calenderView.showBlock = ^{
                    
                    weaSelf.isShowTimeView = !weaSelf.isShowTimeView;
                    
                    [weaSelf.calenderView removeFromSuperview];
                    
//                    //取消选中状态
//                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//                    ProjectCountNumTableViewCell *cell = [weaSelf.countTableView cellForRowAtIndexPath:indexPath];
//                    [cell cancelSelectaStuta];
                    
                };
                
                self.calenderView.selectBlock = ^(NSDictionary *dict) {
                    
                    weaSelf.isShowTimeView = !weaSelf.isShowTimeView;
                    
                    [weaSelf.calenderView removeFromSuperview];
                    
                    NSString *datimeStr = [NSString  stringWithFormat:@"%@ - %@",dict[@"begin"],dict[@"end"]];
                   
                    weaSelf.param[@"datime"] = datimeStr;
                    
                    //重新请求数据
                    [weaSelf requestCountData];
                };
                
                [self.countTableView addSubview:self.calenderView];
            }else{
               
                [self.calenderView removeFromSuperview];
            }
            break;
        }
        case 1:{
           
            if (_isShowTimeView) {
               _isShowTimeView = !_isShowTimeView;
            }
            [self.calenderView removeFromSuperview];
            self.param[@"days"] = @"seven";
            //重新请求数据
            [self requestCountData];
            
            break;
            
        }
        case 2:
        {
            if (_isShowTimeView) {
                _isShowTimeView = !_isShowTimeView;
            }
            [self.calenderView removeFromSuperview];
            self.param[@"days"] = @"week";
            //重新请求数据
            [self requestCountData];
           
            break;
          }
        case 3:{
            if (_isShowTimeView) {
                _isShowTimeView = !_isShowTimeView;
            }
            [self.calenderView removeFromSuperview];
            self.param[@"days"] = @"month";
            //重新请求数据
            [self requestCountData];
           
            break;
            
          }
        default:
            break;
    }

}
#pragma mark  --- 创建UI--------
-(void) createTableView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.countTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, KScreenW, KScreenH-SafeAreaTopHeight-49-SafeAreaBottomHeight)];
    self.countTableView.tableFooterView  =[[UIView alloc]initWithFrame:CGRectZero];
    self.countTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.countTableView.backgroundColor = [UIColor whiteColor];
    self.countTableView.separatorColor = [UIColor lineBackGrounpColor];
    self.countTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.countTableView];
    self.countTableView.delegate = self;
    self.countTableView.dataSource = self;

    [self.countTableView registerNib:[UINib nibWithNibName:PROJECTCOUNTTALEVIEW_CELL bundle:nil] forCellReuseIdentifier:PROJECTCOUNTTALEVIEW_CELL];
    [self.countTableView registerNib:[UINib nibWithNibName:RULECOUNTTABLEVIEW_CELL bundle:nil] forCellReuseIdentifier:RULECOUNTTABLEVIEW_CELL];
    [self.countTableView registerNib:[UINib nibWithNibName:EQUIPMENTCOUNTTABLEVIEW_CELL bundle:nil] forCellReuseIdentifier:EQUIPMENTCOUNTTABLEVIEW_CELL];

    //加载空白页
    self.showSpaceView =[ [ShowSpaceView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH-SafeAreaTopHeight-49)];
    self.showSpaceView.lab.text = @"暂无统计";
    [self.countTableView addSubview:self.showSpaceView];
    
    __weak typeof(self) weakSelf = self;
    self.countTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //移除自定义时间view
         [weakSelf.calenderView removeFromSuperview];
        if (weakSelf.isData) {
            
            [weakSelf requestCountData];
            
        }else{
            
            [weakSelf requestAgeLoadData];
        }
    } ];
}
-(void) createNaviBar{
    __weak typeof(self) weakSelf = self;
    self.titleView = [[NaviTitleView alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    self.titleView.intrinsicContentSize = CGSizeMake(100, 44);
    self.titleView.backgroundColor = [UIColor clearColor];
    self.titleView.titleViewBlock = ^(UIButton *sender) {
        
        [weakSelf selectdProjectBtnAction:sender];
    };
    self.navigationItem.titleView = self.titleView;
    
}
#pragma mark  ---- NaviBarBtnAction----
-(void)selectdProjectBtnAction:(UIButton *) sender{
    __weak typeof(self) weakSelf = self;
    if (sender.selected) {
        //判断是否存在
        if (!self.listView) {
            self.listView = [[CountEquiListView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, KScreenW, KScreenH-SafeAreaTopHeight-49-SafeAreaBottomHeight)];
            
            [self.view addSubview:self.listView];
            
            //选中cell点击方法
            self.listView.selectBlock = ^(NSIndexPath *indexPath, NSDictionary *dict) {
                
                weakSelf.listView.selectIndexPath = indexPath;
                
                //获取项目名称
                weakSelf.titleView.equiNameLab.text = dict[@"Name"];
                
                //移除之前存储的key
                [weakSelf.param removeObjectForKey:@"days"];
                [weakSelf.param removeObjectForKey:@"datime"];
                
                //取消选中状态
                NSIndexPath *indexPatha = [NSIndexPath indexPathForRow:0 inSection:0];
                ProjectCountNumTableViewCell *cell = [weakSelf.countTableView cellForRowAtIndexPath:indexPatha];
                [cell cancelSelectaStuta];
                
                //项目ID
                NSString *projectId = dict[@"ID"];
                weakSelf.project_id = projectId;
                
                //重新请求数据
                [weakSelf requestCountData];
                
                sender.selected  = !sender.selected;
                
                [weakSelf selectdProjectBtnAction:sender];
                
            };
            self.listView.cacelBlock = ^{
                
                sender.selected  = !sender.selected;
                
                [weakSelf selectdProjectBtnAction:sender];
            };
            
        }else{
            [self.listView  requestAgainLoadData];
            self.listView.hidden = NO;
        }
    
    }else{
        self.listView.hidden = YES;
        
    }
}
#pragma mark ----数据相关----
//统计数量
-(void) requestCountData{
    
    __weak typeof(self) weakSelf = self;

    if (self.project_id) {
        self.param[@"project_id"] =self.project_id;
    }else{
        //判断是否存在
        if (self.isData) {
           self.param[@"project_id"] =self.idDict[@"ID"];
        }
    }

    [[KRMainNetTool sharedKRMainNetTool]postRequstWith:SystemAppviolat_URL params:self.param.copy withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        
         //隐藏空白页
        weakSelf.showSpaceView.hidden = YES;
        weakSelf.countTableView.hidden = NO;
        [weakSelf.countTableView.mj_header endRefreshing];
        
        if (error) {
            [SVProgressHUD showErrorWithStatus:error];
            [SVProgressHUD dismissWithDelay:1];
            return ;
        }
       // NSLog(@"-----11111111====%@----",showdata);
        NSNumber *code = showdata[@"code"];
        if ([code integerValue] == 0) {
            //删除之前所有数据
            [weakSelf.dataArr removeAllObjects];
            [weakSelf.violArr removeAllObjects];
            [weakSelf.statArr removeAllObjects];
            [weakSelf.timestArr removeAllObjects];
            //隐藏空白页
            weakSelf.showSpaceView.hidden = YES;
            NSDictionary *dict = showdata[@"data"];
            if (dict) {
                //statistics 统计的数量
                NSDictionary *statiDict = dict[@"statistics"];
                [weakSelf.statArr addObject:statiDict];
                [weakSelf.dataArr addObject:weakSelf.statArr];
                
                //violastat 违规统计 第一张图
                NSArray *violArr = dict[@"violastat"];
                NSArray *arr = violArr[0];
                if (arr.count > 0 ) {
                    [weakSelf.violArr addObject:violArr];
                    [weakSelf.dataArr addObject:weakSelf.violArr];
                }
                
                //timestat 月份统计 就是第二张统计图
                NSArray *timArr = dict[@"timestat"];
                if (timArr.count > 0) {
                    [weakSelf.timestArr addObject:timArr];
                    [weakSelf.dataArr addObject:weakSelf.timestArr];
                }
    
                [weakSelf.countTableView reloadData];
                
            }else{
            //判断是否没有项目
            NSNumber *count = showdata[@"count"];
            if ([count integerValue] == 0) {
                weakSelf.showSpaceView.hidden = YES;
                weakSelf.countTableView.mj_footer.hidden = YES;
                [weakSelf.dataArr removeAllObjects];
                //删除NSUser对象
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"project"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [weakSelf.countTableView reloadData];
                
                weakSelf.showSpaceView.hidden = NO;
            }else if (weakSelf.dataArr.count == [showdata[@"count"] integerValue]) {
                weakSelf.countTableView.mj_footer.state = MJRefreshStateNoMoreData;
                [SVProgressHUD showSuccessWithStatus:@"暂无更多数据"];
                [SVProgressHUD dismissWithDelay:1];
            }
        }
        }else  if ([code integerValue] == 1) {
            
            NSString *err =  showdata[@"msg"];
            if ([err isEqualToString:@"缺少project_id"] ) {
     
                [weakSelf.dataArr removeAllObjects];
                [weakSelf.violArr removeAllObjects];
                [weakSelf.timestArr removeAllObjects];
                [weakSelf.statArr removeAllObjects];
                [weakSelf.countTableView reloadData];
                
                weakSelf.showSpaceView.hidden = NO;
                weakSelf.titleView.equiNameLab.text =@"";
                
                return ;
            }else if([err isEqualToString:@"无权查看该项目"]) {
                
                [weakSelf.dataArr removeAllObjects];
                [weakSelf.violArr removeAllObjects];
                [weakSelf.timestArr removeAllObjects];
                [weakSelf.statArr removeAllObjects];
                [weakSelf.countTableView reloadData];
    
                weakSelf.showSpaceView.hidden = NO;
                weakSelf.titleView.equiNameLab.text =@"";
                
                 return ;
            }else if([err isEqualToString:@"暂无项目"]) {
                [weakSelf.dataArr removeAllObjects];
                [weakSelf.violArr removeAllObjects];
                [weakSelf.timestArr removeAllObjects];
                [weakSelf.statArr removeAllObjects];
                [weakSelf.countTableView reloadData];
                
                weakSelf.showSpaceView.hidden = NO;
                weakSelf.titleView.equiNameLab.text =@"";
            
            }else {
                
                [SVProgressHUD showErrorWithStatus:showdata[@"msg"]];
                [SVProgressHUD dismissWithDelay:1];
            }
        }
    }];
}
//请求数据
-(void) requestAgeLoadData{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    param[@"userid"] =[UserInfo obtainWithUserID];
    param[@"jsession"] = [UserInfo obtainWithMarks];
 
    [[KRMainNetTool sharedKRMainNetTool] postRequstWith:SystemProject_URL params:param withModel:nil waitView:nil complateHandle:^(id showdata, NSString *error) {

        if (error) {
            [SVProgressHUD showErrorWithStatus:error];
            [SVProgressHUD dismissWithDelay:1];
            return ;
        }
        NSNumber *code = showdata[@"code"];
        if ([code integerValue] == 0) {
            
            NSArray *dictArr = showdata[@"data"];
            
            if (dictArr.count > 0) {
                weakSelf.isData = YES;
                weakSelf.idDict = dictArr[0];
                weakSelf.titleView.equiNameLab.text = weakSelf.idDict[@"Name"];
            }else{
                
                weakSelf.isData = NO;
            }
        }
        [weakSelf requestCountData];
    }];
}

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
-(NSMutableArray *)statArr{
    if (!_statArr) {
        _statArr = [NSMutableArray array];
    }
    return _statArr;
}
-(NSMutableArray *)violArr{
    if (!_violArr) {
        _violArr = [NSMutableArray array];
    }
    return _violArr;
}
-(NSMutableArray *)timestArr{
    if (!_timestArr) {
        _timestArr = [NSMutableArray array];
    }
    return _timestArr;
}
-(NSMutableDictionary *)param{
    if (!_param) {
        _param = [NSMutableDictionary dictionary];
    }
    return _param;
}
-(NSDictionary *)idDict{
    if (!_idDict) {
        _idDict  =[NSDictionary dictionary];
    }
    return _idDict;
}


@end
