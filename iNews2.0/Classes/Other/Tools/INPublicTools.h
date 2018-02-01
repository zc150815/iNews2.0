//
//  INPublicTools.h
//  iNews2.0
//
//  Created by 123 on 2018/1/27.
//  Copyright © 2018年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface INPublicTools : NSObject

+(instancetype)sharedPublicTools;

//计算文字高度
-(CGFloat)calculateLableHeightWithText:(NSString*)text Font:(UIFont*)font width:(CGFloat)width limitRowCount:(NSInteger)limiteRow;
//读取缓存
-(NSString*)loadSystemCache;
//提示条
-(void)showMessage:(NSString *)message duration:(NSTimeInterval)time;


@end
