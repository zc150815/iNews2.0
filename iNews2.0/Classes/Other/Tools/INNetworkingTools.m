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
#pragma mark
#pragma mark 封装get/post请求
-(void)requestWithRequestType:(RequestType)type url:(NSString*)url params:(NSDictionary*)params callBack:(callBack)callBack {
    if (type == GET) {
        //        [[SQPublicTools sharedPublicTools] setupCookie];
        [[INNetworkingTools sharedNetWorkingTools] GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            callBack(responseObject,nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callBack(nil,error);
        }];
    }else{
        //        [[SQPublicTools sharedPublicTools] setupCookie];
        [[INNetworkingTools sharedNetWorkingTools] POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            callBack(responseObject,nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callBack(nil,error);
        }];
    }
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

//获取新闻详情
-(void)getNewsDetailDataWithID:(NSString*)ID callBack:(callBack)callBack{
    NSString*url = @"api/article/news_detail";
    NSDictionary *params = @{@"id":ID};
    [self requestWithRequestType:GET url:url params:params callBack:callBack];
}
@end
