//
//  CountEquiListView.m
//  SDMonitSystem
//
//  Created by tiao on 2018/1/25.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "CountEquiListView.h"

#import "ShowSpaceView.h"

@interface CountEquiListView  ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *listTableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) ShowSpaceView *showSpaceView;
@property (nonatomic,assign) NSInteger page;

@end


@implementation CountEquiListView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.page = 1;
        [self requestLoadData];
        [self initViewUI];
    }
    return self;
}

-(void) initViewUI{

    self.listTableView  =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, self.frame.size.height)];
    [self addSubview:self.listTableView];
    
    self.listTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    self.listTableView.backgroundColor  =[UIColor lineBackGrounpColor];
    
    self.listTableView.separatorColor = [UIColor lineBackGrounpColor];
    
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    
    [self.listTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
    

    __weak typeof(self) weakSelf = self;
    self.listTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf requestLoadData];
    } ];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf requestLoadData];
    }];
    
    self.listTableView.mj_footer = footer;
    footer.refreshingTitleHidden = YES;
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"" forState:MJRefreshStatePulling];
    [footer setTitle:@"" forState:MJRefreshStateRefreshing];
    
}
#pragma mark --- UITableViewDataSoucre---
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    NSDictionary *dict = self.dataArr[indexPath.row];
    cell.textLabel.text = dict[@"Name"];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    
    if (indexPath == self.selectIndexPath) {
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    }else{
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50*kWJHeightCoefficient;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSIndexPath *oldIndex =[tableView indexPathForSelectedRow];
    [tableView cellForRowAtIndexPath:oldIndex].accessoryType = UITableViewCellAccessoryNone;
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    return indexPath;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = self.dataArr[indexPath.row];
    self.selectBlock(indexPath,dict);
}

-(void)setSelectIndexPath:(NSIndexPath *)selectIndexPath{
    
    _selectIndexPath = selectIndexPath;
}
#pragma mark------ 数据相关----

-(void)requestAgainLoadData{
    
    [self requestLoadData];
}
//请求数据
-(void) requestLoadData{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    param[@"userid"] =[UserInfo obtainWithUserID];
    param[@"page"] = [NSNumber numberWithInteger:self.page];
    param[@"jsession"] = [UserInfo obtainWithMarks];
    
    [[KRMainNetTool sharedKRMainNetTool] postRequstWith:SystemProject_URL params:param withModel:nil waitView:self complateHandle:^(id showdata, NSString *error) {
        
        [weakSelf.listTableView.mj_footer endRefreshing];
        [weakSelf.listTableView.mj_header endRefreshing];
        
        if (error) {
            [SVProgressHUD showErrorWithStatus:error];
            [SVProgressHUD dismissWithDelay:1];
            return ;
        }
        
        NSNumber *code = showdata[@"code"];
        if ([code integerValue] == 0) {
            
            NSArray *dictArr = showdata[@"data"];
            if (dictArr.count > 0) {
                if (weakSelf.page == 1 ) {
                    
                    [weakSelf.dataArr removeAllObjects];
                }
                
                if (dictArr.count > 0) {
                    
                    [weakSelf.dataArr addObjectsFromArray:dictArr];
                }
            
            }else{
                //判断是否没有项目
                NSNumber *count = showdata[@"count"];
                if ([count integerValue] == 0) {
                    weakSelf.showSpaceView.hidden = YES;
                    weakSelf.listTableView.mj_footer.hidden = YES;
                    [weakSelf.dataArr removeAllObjects];
                    //删除NSUser对象
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"project"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [weakSelf.listTableView reloadData];
                    
                    weakSelf.showSpaceView.hidden = NO;
                }else if (weakSelf.dataArr.count == [showdata[@"count"] integerValue]) {
                    weakSelf.listTableView.mj_footer.state = MJRefreshStateNoMoreData;
                    [SVProgressHUD showSuccessWithStatus:@"暂无更多数据"];
                    [SVProgressHUD dismissWithDelay:1];
                }
            }

        }else{
            
            [SVProgressHUD showErrorWithStatus: showdata[@"msg"]];
            [SVProgressHUD dismissWithDelay:1];
        }
        
        [weakSelf.listTableView reloadData];
    }];
    
}

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
    
}

@end
