//
//  INParameterHeader.h
//  iNews2.0
//
//  Created by 123 on 2018/1/24.
//  Copyright © 2018年 ronglian. All rights reserved.
//

#ifndef INParameterHeader_h
#define INParameterHeader_h

#import <UIKit/UIKit.h>
/****************************间距**************************************/
static CGFloat const MARGIN_BASE = 15.0;
static CGFloat const MARGIN_LARGE = 20.0;
static CGFloat const MARGIN_LITTLE = 10.0;
//static NSString * const APPURL = @"https://itunes.apple.com/cn/app/%E7%BA%A2%E5%85%AD/id1236645774?mt=8";


/****************************颜色/字体**************************************/
static NSString * const COLOR_BASE = @"DD232A"; //主色调
static NSString * const COLOR_BROWN_DEEP = @"333333";//深灰色
static NSString * const COLOR_BROWN_LIGHT = @"999999";//浅灰色
static NSString * const COLOR_BORDER_BASE = @"D2D2D2";//边框颜色
static NSString * const SFProTextBold = @"SFProText-Bold";//SFProTextBold字体
static NSString * const SFProTextLight = @"SFProText-Light";//SFProTextLight字体
static NSString * const SFProTextRegular = @"SFProText-Regular";//SFProTextRegular字体
static NSString * const SFProTextSemibold = @"SFProText-Semibold";//SFProTextSemibold字体
static NSString * const CircularAirProBold = @"CircularAirPro-Bold";//SFProTextRegular字体

/****************************其他区**************************************/
static NSString * const STATUS = @"status";//status
static NSString * const DATA = @"data";//data


//app登录途径
typedef enum : NSUInteger {
    INNewsListTypeSpecial = 0,
    INNewsListTypePic = 1,
    INNewsListTypeLive = 2,
    INNewsListTypeReplay = 3,
    INNewsListTypeVideo = 4,
    INNewsListTypeNomal = 100,
} INNewsListType;


#endif /* INParameterHeader_h */
