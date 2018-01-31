//
//  INPublicTools.m
//  iNews2.0
//
//  Created by 123 on 2018/1/27.
//  Copyright © 2018年 ronglian. All rights reserved.
//

#import "INPublicTools.h"

@interface INPublicTools()

@property (nonatomic, strong) UIView *showview;//提示视图

@property (nonatomic,assign) BOOL isShowing;

@end
@implementation INPublicTools

static INPublicTools* _instanceType;
+(instancetype)sharedPublicTools{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instanceType = [[self alloc]init];
    });
    return _instanceType;
}


-(CGFloat)calculateLableHeightWithText:(NSString*)text Font:(UIFont*)font width:(CGFloat)width{
    
    CGSize titleSize = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    CGFloat lineH = font.lineHeight;
    NSInteger rowCount = titleSize.height/lineH;
    
    return (rowCount>=3)?3*lineH:lineH*rowCount;
}

#pragma mark
#pragma mark 缓存计算方法
//读取缓存
-(NSString*)loadSystemCache{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES) firstObject];
    CGFloat size = [self folderSizeAtPath:cachePath];
    if (size == 0) {
        return nil;
    }
    NSString *message = size > 1 ? [NSString stringWithFormat:@"缓存%.2fM",size] : [NSString stringWithFormat:@"缓存%.2fKb", size*1024.0];
    return message;
}
- (CGFloat)folderSizeAtPath:(NSString *)path{
    // 利用NSFileManager实现对文件的管理
    NSFileManager *manager = [NSFileManager defaultManager];
    CGFloat size = 0;
    if ([manager fileExistsAtPath:path]) {
        // 获取该目录下的文件，计算其大小
        NSArray *childrenFile = [manager subpathsAtPath:path];
        for (NSString *fileName in childrenFile) {
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            size += [manager attributesOfItemAtPath:absolutePath error:nil].fileSize;
        }
        // 将大小转化为M
        return size / 1024.0 / 1024.0;
    }
    return 0;
}
#pragma mark  提示条
-(void)showMessage:(NSString *)message duration:(NSTimeInterval)time{
    //    if (_isShowing) {
    //        return;
    //    }
    _isShowing = YES;
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor blackColor];
    showview.alpha = 0;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    self.showview = showview;
    
    UILabel *label = [[UILabel alloc]init];
    label.text = message;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = PD_Font(15);
    label.x = MARGIN_BASE;
    label.y = MARGIN_BASE/2;
    [label sizeToFit];
    [showview addSubview:label];
    showview.center = CGPointMake(window.centerX, window.height*3/4);
    showview.bounds = CGRectMake(0, 0, label.width+MARGIN_BASE*2, label.height+MARGIN_BASE);
    [window bringSubviewToFront:showview];
    
    
    [UIView animateWithDuration:time/2 animations:^{
        showview.alpha = 0.7;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:time/2 animations:^{
            showview.alpha = 0;
        } completion:^(BOOL finished) {
            [showview removeFromSuperview];
            _isShowing = NO;
        }];
    }];
}
@end
