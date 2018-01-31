//
//  INMacroHeader.h
//  iNews2.0
//
//  Created by 123 on 2018/1/24.
//  Copyright © 2018年 ronglian. All rights reserved.
//

#ifndef INMacroHeader_h
#define INMacroHeader_h

#define SystemVersion [[UIDevice currentDevice] systemVersion]
#define PhoneIDNum [[[UIDevice currentDevice] identifierForVendor] UUIDString]

/****************************适配**************************************/
#define PD_Iphone6Width 375.0
#define PD_Iphone6Height 667.0
#define PD_Font(f) [UIFont systemFontOfSize:PD_Fit(f)]
#define Font_(f) [UIFont systemFontOfSize:f]
#define PD_ScreenWidth [UIScreen mainScreen].bounds.size.width
#define PD_ScreenHeight [UIScreen mainScreen].bounds.size.height
//#define PD_Fit(x) (PD_ScreenHeight*((x)/PD_Iphone6Height))
#define PD_Fit(x) (PD_ScreenWidth*((x)/PD_Iphone6Width))
//#define PD_Fit(x) x
#define PD_RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define PD_RandomColor PD_RGBColor(arc4random() % 256, arc4random() % 256, arc4random() % 256)

#define PD_TabBarHeight ((INTabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController).tabBar.frame.size.height
#define PD_NavHeight self.navigationController.navigationBar.frame.size.height
#define PD_StatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height
#endif /* INMacroHeader_h */
