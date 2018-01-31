//
//  INNewsListModel.m
//  iNews2.0
//
//  Created by 123 on 2018/1/25.
//  Copyright © 2018年 ronglian. All rights reserved.
//

#import "INNewsListModel.h"

@implementation INNewsListModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
