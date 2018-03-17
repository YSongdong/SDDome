//
//  CountEquiListView.h
//  SDMonitSystem
//
//  Created by tiao on 2018/1/25.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountEquiListView : UIView

//选中cell
@property (nonatomic,strong) NSIndexPath *selectIndexPath;

//选中cell点击方法
@property (nonatomic,copy) void(^selectBlock)(NSIndexPath *indexPath,NSDictionary *dict);
// 取消
@property (nonatomic,copy) void(^cacelBlock)(void);

//从新加载数据
-(void) requestAgainLoadData;

@end
