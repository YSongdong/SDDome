//
//  ProjectViewController.h
//  SDMonitSystem
//
//  Created by tiao on 2018/1/22.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"
@interface ProjectViewController : BaseViewController

//项目名称
@property (nonatomic,strong) NSString *projectName;
//项目ID
@property (nonatomic,strong) NSString *projectID;
@end
