//
//  SelectTimeHeaderView.h
//  SDMonitSystem
//
//  Created by tiao on 2018/1/25.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectTimeHeaderView : UIView
@property (nonatomic,copy) void(^headerViewBlock)(BOOL isSelectd);

-(void) selectdShowTime:(NSDictionary *)dict;

@end
