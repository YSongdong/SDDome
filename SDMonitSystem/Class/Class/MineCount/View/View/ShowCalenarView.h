//
//  ShowCalenarView.h
//  SDMonitSystem
//
//  Created by tiao on 2018/1/26.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowCalenarView : UIView

@property (nonatomic,copy) void(^showBlock)(void);
//显示时间
@property (nonatomic,copy) void(^selectBlock)(NSDictionary *dict);

@end
