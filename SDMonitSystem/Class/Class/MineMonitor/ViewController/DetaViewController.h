//
//  DetaViewController.h
//  SDMonitSystem
//
//  Created by tiao on 2018/3/18.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"

@interface DetaViewController : BaseViewController

//项目ID
@property (nonatomic,strong) NSString *projectID;

@property (nonatomic,strong) NSString *deviceID;

@property (nonatomic,strong) NSString *titleStr;

@property (nonatomic,strong) NSDictionary *dict;

//是否在线
@property (nonatomic,strong) NSString *online;


@end
