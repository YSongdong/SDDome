//
//  Tool.h
//  SDMonitSystem
//
//  Created by tiao on 2018/2/2.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tool : NSObject
//加载网络图片
+(void)sd_setImageView:(UIImageView *)imageView WithURL:(NSString*)str;
@end
