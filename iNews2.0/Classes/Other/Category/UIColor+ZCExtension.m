//
//  UIColor+ZCExtension.m
//  常用工具汇总
//
//  Created by zhangchong on 16/12/16.
//  Copyright © 2016年 Online Community Of China. All rights reserved.
//

#import "UIColor+ZCExtension.h"

@implementation UIColor (ZCExtension)

+ (UIColor *)getColor:(NSString *)hexColor
{
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:1.0f];
}


#define AGEColorImplement(COLOR_NAME,RED,GREEN,BLUE)    \
+ (UIColor *)COLOR_NAME{    \
static UIColor* COLOR_NAME##_color;    \
static dispatch_once_t COLOR_NAME##_onceToken;   \
dispatch_once(&COLOR_NAME##_onceToken, ^{    \
COLOR_NAME##_color = [UIColor colorWithRed:RED green:GREEN blue:BLUE alpha:1.0];  \
}); \
return COLOR_NAME##_color;  \
}

AGEColorImplement(flatTurquoiseColor, 0.10196078431372549, 0.7372549019607844, 0.611764705882353)
AGEColorImplement(flatGreenSeaColor, 0.08627450980392157, 0.6274509803921569, 0.5215686274509804)
AGEColorImplement(flatEmeraldColor, 0.1803921568627451, 0.8, 0.44313725490196076)
AGEColorImplement(flatNephritisColor, 0.15294117647058825, 0.6823529411764706, 0.3764705882352941)
AGEColorImplement(flatPeterRiverColor, 0.20392156862745098, 0.596078431372549, 0.8588235294117647)
AGEColorImplement(flatBelizeHoleColor, 0.1607843137254902, 0.5019607843137255, 0.7254901960784313)
AGEColorImplement(flatAmethystColor, 0.6078431372549019, 0.34901960784313724, 0.7137254901960784)
AGEColorImplement(flatWisteriaColor, 0.5568627450980392, 0.26666666666666666, 0.6784313725490196)
AGEColorImplement(flatWetAsphaltColor, 0.20392156862745098, 0.28627450980392155, 0.3686274509803922)
AGEColorImplement(flatMidnightBlueColor, 0.17254901960784313, 0.24313725490196078, 0.3137254901960784)
AGEColorImplement(flatSunFlowerColor, 0.9450980392156862, 0.7686274509803922, 0.058823529411764705)
AGEColorImplement(flatOrangeColor, 0.9529411764705882, 0.611764705882353, 0.07058823529411765)
AGEColorImplement(flatCarrotColor, 0.9019607843137255, 0.49411764705882355, 0.13333333333333333)
AGEColorImplement(flatPumpkinColor, 0.8274509803921568, 0.32941176470588235, 0)
AGEColorImplement(flatAlizarinColor, 0.9058823529411765, 0.2980392156862745, 0.23529411764705882)
AGEColorImplement(flatPomegranateColor, 0.7529411764705882, 0.2235294117647059, 0.16862745098039217)
AGEColorImplement(flatCloudsColor, 0.9254901960784314, 0.9411764705882353, 0.9450980392156862)
AGEColorImplement(flatSilverColor, 0.7411764705882353, 0.7647058823529411, 0.7803921568627451)
AGEColorImplement(flatConcreteColor, 0.5843137254901961, 0.6470588235294118, 0.6509803921568628)
AGEColorImplement(flatAsbestosColor, 0.4980392156862745, 0.5490196078431373, 0.5529411764705883)
@end
