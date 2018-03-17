//
//  SystemURL.h
//  SDMonitSystem
//
//  Created by tiao on 2018/1/29.
//  Copyright © 2018年 tiao. All rights reserved.
//

#ifndef SystemURL_h
#define SystemURL_h

#define FT_INLINE static inline
FT_INLINE  NSString  *getRequestPath(NSString *act) ;


//测试域名
#define PUBLISH_DIMAIN_URL @"http://ai.gandianli.com/"
//#define PUBLISH_DIMAIN_URL @"http://192.168.3.201:99/"

//----------------------------登录接口----------------------//
//登录接口
#define SystemLogin_URL getRequestPath(@"index/AppTtxUser/logins")
//登出接口
#define SystemLoginOut_URL getRequestPath(@"index/AppTtxUser/logout")
//修改密码接口
#define SystemAlterPwd_URL getRequestPath(@"index/app_user/retrpasswordOne")
//忘记密码
#define SystemForgetPwd_URL getRequestPath(@"index/app_user/sms_ver")
//获取验证码
#define SystemTest_URL  getRequestPath(@"index/app_user/recover_password")
//用户信息
#define SystemUserInfo   getRequestPath(@"index/app_user/userinfo")

//----------------------------监控----------------------//
// 获取用户负责项目
#define SystemProject_URL     getRequestPath(@"index/BeidouCompany/projectList")
//获取设备列表
#define SystemProjectList_URL  getRequestPath(@"index/BeidouCompany/projectDeviceList")
//获取播放地址
#define SystemProjectInfo_URL  getRequestPath(@"index/BeidouCompany/deviceRtsp")
//设备下违规列表
#define SystemBehaviorRecord_URL    getRequestPath(@"index/AppTtxViolat/getDeviceipcBehaviorRecordInfo")
//----------------------------统计----------------------//
//查看统计信息
#define SystemAppviolat_URL getRequestPath(@"index/AppTtxViolat/sumgraph")


FT_INLINE  NSString  * getRequestPath(NSString *op) {
    return [PUBLISH_DIMAIN_URL stringByAppendingFormat:@"%@",op];
}
#endif /* SystemURL_h */
