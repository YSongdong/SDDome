//
//  ProjectCountNumTableViewCell.h
//  SDMontir
//
//  Created by tiao on 2018/1/16.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectCountNumTableViewCell : UITableViewCell

@property (nonatomic,copy) void(^headerViewBlock)(UIButton *sender );

@property (nonatomic,strong) NSDictionary *data;

// 取消选中状态
-(void) cancelSelectaStuta;

@end
