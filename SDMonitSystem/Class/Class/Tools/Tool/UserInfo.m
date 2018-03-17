//
//  UserInfo.m
//  SDMonitSystem
//
//  Created by tiao on 2018/1/31.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

//保存数据
+(void) saveData:(NSDictionary *)data{
    
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    [userD setObject:data forKey:@"Login"];
    //3.强制让数据立刻保存
    [userD synchronize];
}
//修改密码
+(void) forgatPassword:(NSString *)pwd{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userD objectForKey:@"Login"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:dict];
    [dic setObject:pwd forKey:@"password"];
    [userD setObject:dic.copy forKey:@"Login"];
    //3.强制让数据立刻保存
    [userD synchronize];
}
//判断是否登录
+(BOOL) passLoginData{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"Login"]) {
        return YES;
    }else{
       return NO;
    }
}
//获取名字
+(NSString *) obtainWithRenname{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userD objectForKey:@"Login"];
    
    return dict[@"rename"];
}
//获取封面
+(NSString *)obtainWithAvatars{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userD objectForKey:@"Login"];
    return dict[@"avatars"];
}
//获取userID
+(NSString *) obtainWithUserID{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userD objectForKey:@"Login"];
    
    return dict[@"userid"];
}
//项目iD
+(NSString *) obtainWithProjectID{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userD objectForKey:@"Login"];
    
    return dict[@""];
}
//云平台id
+(NSString *) obtainWithKeyID{
    
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userD objectForKey:@"Login"];
    return dict[@"key_id"];
}
//获取code
+(NSString *) obtainWithOrgCode{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userD objectForKey:@"Login"];
    return dict[@"org_code"];
}
//获取登录数据
+(NSDictionary *)obtainLoadData{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userD objectForKey:@"Login"];
    return dict;
}
//获取登录Marks
+(NSDictionary *)obtainWithMarks{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userD objectForKey:@"Login"];
    return dict[@"marks"];
}
//删除用户数据
+(void) delUserData{
    //删除NSUser对象
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Login"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}




@end
