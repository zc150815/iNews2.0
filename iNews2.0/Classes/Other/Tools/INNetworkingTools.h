//
//  INNetworkingTools.h
//  iNews2.0
//
//  Created by 123 on 2018/1/25.
//  Copyright © 2018年 ronglian. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import <AFNetworking.h>


typedef enum : NSUInteger {
    GET = 0,
    POST = 1,
} RequestType;

typedef void (^callBack)(id response,NSError* error);


@interface INNetworkingTools : AFHTTPSessionManager

+(instancetype)sharedNetWorkingTools;



//fir检查更新
-(void)checkFIRVersionWithCallBack:(callBack)callBack;

@end
