//
//  KRMainNetTool.m
//  Dntrench
//
//  Created by kupurui on 16/10/19.
//  Copyright © 2016年 CoderDX. All rights reserved.
//

#import "KRMainNetTool.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"

#define baseURL @"这里写基础的url"

@implementation KRMainNetTool
singleton_implementation(KRMainNetTool)
//上传文件的接口方法
- (void)upLoadData:(NSString *)url params:(NSDictionary *)param andData:(NSArray *)array complateHandle:(void (^)(id, NSString *))complet {
    [self upLoadData:url params:param andData:array waitView:nil complateHandle:complet];
}
//需要显示加载动画的接口方法 不上传文件
- (void)postRequstWith:(NSString *)url params:(NSDictionary *)dic withModel:(Class)model waitView:(UIView *)waitView complateHandle:(void(^)(id showdata,NSString *error))complet {
    
    //定义需要加载动画的HUD
    __block MBProgressHUD *HUD;
    if (waitView != nil) {
        //如果view不为空就添加到view上
        dispatch_async(dispatch_get_main_queue(), ^{
             HUD = [MBProgressHUD showHUDAddedTo:waitView animated:YES];
             HUD.bezelView.color =[UIColor colorWithWhite:0 alpha:0.7];
             HUD.contentColor = [UIColor colorWithWhite:1 alpha:1];
        });
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    //返回结果支持的类型 方法一
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/xml", nil];
    
    // 3.设置超时时间为10s
    manager.requestSerializer.timeoutInterval = 10;
    //开始网络请求
   [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功，隐藏HUD并销毁
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [HUD hideAnimated:YES];
        });
       
      //判断返回的状态，0即为服务器查询成功，1服务器查询失败
      NSNumber  *code = responseObject[@"code"];
         if ([code integerValue]  == 2) {
            //会话不存在从新登陆
            NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
            NSDictionary *dict = [userd objectForKey:@"User"];
            
            [self postRequstWith:SystemLogin_URL params:dict withModel:nil waitView:nil complateHandle:^(id showdata, NSString *error) {
               
                if (!error) {
                    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                        //请求成功，隐藏HUD并销毁
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [HUD hideAnimated:YES];
                        });
                        NSNumber *code = showdata[@"code"];
                        if ([code integerValue] == 0) {
                            NSDictionary *dict = showdata[@"data"];
                            // 保存用户信息
                            [UserInfo saveData:dict];
                            
                        }
                        complet(responseObject,nil);
                        
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        //网络请求失败，隐藏HUD，服务器响应失败。网络问题 或者服务器崩溃
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [HUD hideAnimated:YES];
                        });
                        complet(nil,@"网络错误");
                    }];
                }
            }];
         }else{
             
              complet(responseObject,nil);
         }
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        //网络请求失败，隐藏HUD，服务器响应失败。网络问题 或者服务器崩溃
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hideAnimated:YES];
        });
        complet(nil,@"网络错误");
    }];

}
// get  需要显示加载动画的接口方法
- (void)getRequstWith:(NSString *)url params:(NSDictionary *)dic withModel:(Class)model waitView:(UIView *)waitView complateHandle:(void(^)(id showdata,NSString *error))complet{
    //定义需要加载动画的HUD
    __block MBProgressHUD *HUD;
    if (waitView != nil) {
        //如果view不为空就添加到view上
        dispatch_async(dispatch_get_main_queue(), ^{
            HUD = [MBProgressHUD showHUDAddedTo:waitView animated:YES];
            HUD.bezelView.color =[UIColor colorWithWhite:0 alpha:0.7];
            HUD.contentColor = [UIColor colorWithWhite:1 alpha:1];
        });
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    //返回结果支持的类型 方法一
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/xml", nil];
    
    // 3.设置超时时间为10s
    manager.requestSerializer.timeoutInterval = 10;
    //开始网络请求
    [manager GET:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功，隐藏HUD并销毁
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [HUD hideAnimated:YES];
        });
        //判断返回的状态，0即为服务器查询成功，1服务器查询失败
        NSNumber  *code = responseObject[@"code"];
        
        if ([code integerValue]  == 0) {
            
            if (model == nil) {
                
                if (responseObject[@"data"]) {
                    
                    complet(responseObject[@"data"],nil);
                    
                } else {
                    
                    complet(responseObject[@"msg"],nil);
                }
            } else {
                
                complet([self getModelArrayWith:responseObject[@"data"] andModel:model],nil);
            }
        } else {
            complet(nil,responseObject[@"msg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        //网络请求失败，隐藏HUD，服务器响应失败。网络问题 或者服务器崩溃
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hideAnimated:YES];
        });
        complet(nil,@"网络错误");
    }];
    
}

//需要显示加载动画的接口方法 上传文件
- (void)upLoadData:(NSString *)url params:(NSDictionary *)param andData:(NSArray *)array waitView:(UIView *)waitView complateHandle:(void(^)(id showdata,NSString *error))complet {
    //拼接网络请求url
  //  NSString *path = [NSString stringWithFormat:@"%@%@",baseURL,url];
    //定义需要加载动画的HUD
    __block MBProgressHUD *HUD;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (waitView != nil) {
            //如果view不为空就添加到view上
            HUD = [MBProgressHUD showHUDAddedTo:waitView animated:YES];
            HUD.bezelView.color =[UIColor colorWithWhite:0 alpha:0.7];
            HUD.contentColor = [UIColor colorWithWhite:1 alpha:1];
        }
    });
    //开始上传数据并网络请求
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //返回结果支持的类型 方法一
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/xml", nil];
    // 3.设置超时时间为10s
    manager.requestSerializer.timeoutInterval = 10;
    //开始网络请求
    [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //通过遍历传过来的上传数据的数组，把每一个数据拼接到formData对象上
        for (NSDictionary *dic in array) {
            
            //NSString *str = [NSString stringWithFormat:@"picture%ld.png",[array indexOfObject:data]];
            
            [formData appendPartWithFileData:dic[@"data"] name:dic[@"name"] fileName:@"image.jpg" mimeType:@"image/jpeg"];//
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        nil ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功，隐藏HUD并销毁
        [HUD hideAnimated:YES];
        NSNumber *num = responseObject[@"status"];
        //判断返回的状态，200即为服务器查询成功，500服务器查询失败
        if ([num longLongValue] == 200) {
            complet(@"修改成功",nil);
        } else {
            complet(nil,responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        //网络请求失败，隐藏HUD，服务器响应失败。网络问题 或者服务器崩溃
        [HUD hideAnimated:YES];
        complet(nil,@"网络错误");
    }];
}
//把模型数据传入返回模型数据的数组
- (NSArray *)getModelArrayWith:(NSArray *)array
                      andModel:(Class)modelClass {
    NSMutableArray *mut = [NSMutableArray array];
    //遍历模型数据 用KVC给创建每个模型类的对象并赋值过后放进数组
    for (NSDictionary *dic in array) {
        id model = [modelClass new];
        [model setValuesForKeysWithDictionary:dic];
        [mut addObject:model];
    }
    return [mut copy];
}

#pragma mark  -- 判断网络类型
+(NSString *) networkingStatesFromStatebar
{
     NSString *stateString = @"WIFI";
//    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
//    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//
//        if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
//
//            stateString = @"WIFI";
//
//        }else if (status == AFNetworkReachabilityStatusReachableViaWWAN) {
//
//            //GPRS网络
//             stateString =@"GPRS";
//        }else{
//
//            //没有网络
//            stateString = @"NO";
//        }
//    }];
//
//    NSLog(@"--------%@---",stateString);
//
   return stateString;
   
}
+ (void)ysy_hasNetwork:(void(^)(NSString *net))hasNet
{
    //创建网络监听对象
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //开始监听
    [manager startMonitoring];
    //监听改变
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                hasNet(@"NO");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                hasNet(@"NO");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                hasNet(@"GPRS");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                hasNet(@"WIFI");
                break;
        }
    }];
    //结束监听
    [manager stopMonitoring];
}








@end
