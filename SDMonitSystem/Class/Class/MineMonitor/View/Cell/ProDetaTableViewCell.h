//
//  ProDetaTableViewCell.h
//  SDMontir
//
//  Created by tiao on 2018/1/19.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProDetaTableViewCell : UITableViewCell
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) NSDictionary *dict;

+(CGFloat) heightForExplain:(NSString *)exqlain;


@end
