//
//  AppDelegate+INAppSetting.m
//  iNews2.0
//
//  Created by 123 on 2018/1/24.
//  Copyright © 2018年 ronglian. All rights reserved.
//

#import "AppDelegate+INAppSetting.h"

@implementation AppDelegate (INAppSetting)

-(void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
    
}

-(void)checkNewVersionApp{
    
    [[INNetworkingTools sharedNetWorkingTools]checkFIRVersionWithCallBack:^(id response, NSError *error) {
        if (error) {
            [SVProgressHUD dismiss];
            [[INPublicTools sharedPublicTools]showMessage:@"error" duration:3];
            PD_NSLog(@"error===%@",error);
            return;
        }
        
//        PD_NSLog(@"%@",response);
        NSDictionary *dic = (NSDictionary*)response;
        NSString *changelog = [dic objectForKey:@"changelog"];
        CGFloat version = [[dic objectForKey:@"versionShort"] floatValue];
        NSInteger build = [[dic objectForKey:@"build"] integerValue];
        
        CGFloat currentVersion = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] floatValue];
        NSInteger currentBundle = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] integerValue];
        
        if (version > currentVersion || (version == currentVersion && build > currentBundle)) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"发现新版本%.1f.%zd",version,build] message:changelog preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[dic objectForKey:@"update_url"]]];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
//            [self presentViewController:alert animated:YES completion:NULL];
        }
    }];
}
@end
