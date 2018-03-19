//
//  DetaTableViewCell.h
//  SDMonitSystem
//
//  Created by tiao on 2018/3/19.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetaTableViewCell : UITableViewCell

//YEs 是返回  NO 横屏
@property (nonatomic,copy) void(^btnBlock)(BOOL isBack);

@property (nonatomic,strong) NSDictionary *dict;

+(CGFloat) cellHeightDict:(NSDictionary *) dict;


@end
