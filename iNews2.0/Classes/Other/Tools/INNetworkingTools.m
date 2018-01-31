//
//  INNetworkingTools.m
//  iNews2.0
//
//  Created by 123 on 2018/1/25.
//  Copyright © 2018年 ronglian. All rights reserved.
//

#import "INNetworkingTools.h"

@implementation INNetworkingTools

//单例创建对象
+(INNetworkingTools*)sharedNetWorkingTools{
    
    static dispatch_once_t onceToken;
    static INNetworkingTools* instanceType;
    dispatch_once(&onceToken, ^{
        instanceType = [[self alloc]initWithBaseURL:[NSURL URLWithString:URL_BASE]];
        instanceType.responseSerializer = [AFJSONResponseSerializer serializer];//解决3840
        instanceType.requestSerializer.timeoutInterval = 15;
    });
    return instanceType;
}


//fir检查更新
-(void)checkFIRVersionWithCallBack:(callBack)callBack{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    
    NSString *url = [NSString stringWithFormat:@"http://api.fir.im/apps/latest/%@",@"5a6d5202959d6943a6a4e55b"];
    [manager GET:url parameters:@{@"api_token":@"faaa8aa9cb38d14c63d70194112194bd"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        callBack(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(nil,error);
    }];
}
@end
