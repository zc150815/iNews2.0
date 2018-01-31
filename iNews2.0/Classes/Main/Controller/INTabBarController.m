//
//  INTabBarController.m
//  iNews2.0
//
//  Created by 123 on 2018/1/24.
//  Copyright © 2018年 ronglian. All rights reserved.
//

#import "INTabBarController.h"
#import "INNavigationController.h"

#import "INNewsController.h"
#import "INMeController.h"

@interface INTabBarController ()<UITabBarControllerDelegate>

@end

@implementation INTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupChildController];
    
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self hiddenTopLineToBack];
}
-(void)hiddenTopLineToBack{
    
    for (UIView *lineView in self.tabBar.subviews)
    {
        if ([lineView isKindOfClass:[UIImageView class]] && lineView.bounds.size.height <= 1)
        {
            UIImageView *lineImage = (UIImageView *)lineView;
            [self.tabBar sendSubviewToBack:lineImage];
            
        }
    }
}

+(void)initialize{
    
    UITabBar *tabBar = [UITabBar appearance];
    
    if (@available(iOS 10.0, *)) {
        tabBar.unselectedItemTintColor = [UIColor getColor:COLOR_BROWN_LIGHT];
    } else {
        tabBar.barTintColor = [UIColor getColor:COLOR_BROWN_LIGHT];
    }
    
    tabBar.tintColor = [UIColor getColor:COLOR_BASE];
    [tabBar setBarTintColor:[UIColor whiteColor]];
}

-(void)setupChildController{
    
    [self addChildViewController:[[INNewsController alloc]init] title:@"News" image:@"tabbar_news_inactive" selectedImage:@"tabbar_news_active"];
    [self addChildViewController:[[INMeController alloc]init] title:@"Me" image:@"tabbar_me_inactive" selectedImage:@"tabbar_me_active"];
    
}
-(void)addChildViewController:(UIViewController *)childController title:(NSString*)title image:(NSString*)imageName selectedImage:(NSString*)selectedImageName{
    
    [childController.tabBarItem setImage:[UIImage scaleFromImage:[UIImage imageNamed:imageName] toSize:CGSizeMake(24, 24)]];
    [childController.tabBarItem setSelectedImage:[UIImage scaleFromImage:[UIImage imageNamed:selectedImageName] toSize:CGSizeMake(24, 24)]];
    childController.tabBarItem.title = title;
    INNavigationController *nav = [[INNavigationController alloc]initWithRootViewController:childController];
    [self addChildViewController:nav];
}

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    if (viewController == self.selectedViewController) {
        
        PD_NSLog(@"%@",tabBarController.selectedViewController.childViewControllers.firstObject.childViewControllers);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TAPAGAIN_TOTOP_NOTIFICATION" object:nil];
        return NO;
    }
    
    return YES;
}

@end
