//
//  UserInfo.h
//  SDMonitSystem
//
//  Created by tiao on 2018/1/31.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

//保存数据
+(void) saveData:(NSDictionary *)data;

//修改密码
+(void) forgatPassword:(NSString *)pwd;

//判断是否登录
+(BOOL) passLoginData;

//获取名字
+(NSString *) obtainWithRenname;
//获取封面
+(NSString *)obtainWithAvatars;
//获取userID
+(NSString *) obtainWithUserID;

//项目iD
+(NSString *) obtainWithProjectID;
//云平台id
+(NSString *) obtainWithKeyID;
//获取code
+(NSString *) obtainWithOrgCode;
//获取登录数据
+(NSDictionary *)obtainLoadData;
//获取登录Marks
+(NSDictionary *)obtainWithMarks;



//删除用户数据
+(void) delUserData;


@end
