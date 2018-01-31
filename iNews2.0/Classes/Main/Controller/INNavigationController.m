//
//  INNavigationController.m
//  iNews2.0
//
//  Created by 123 on 2018/1/24.
//  Copyright © 2018年 ronglian. All rights reserved.
//

#import "INNavigationController.h"

@interface INNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation INNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.interactivePopGestureRecognizer.delegate = (id)self;
    
    self.navigationBar.hidden = YES;
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{

    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];

}
//修改状态栏样式
-(UIStatusBarStyle)preferredStatusBarStyle{
    [super preferredStatusBarStyle];
    return UIStatusBarStyleDefault;
}



//#pragma - UIGestureRecognizerDelegate
//-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
//
//    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
//        PD_NSLog(@"%s",__func__);
//
//    }
//    return YES;
//}
//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
//        PD_NSLog(@"%s",__func__);
//
//    }
//
//    return YES;
//}
//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
//        PD_NSLog(@"%s",__func__);
//
//    }
//
//    return YES;
//}
//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
//        PD_NSLog(@"%s",__func__);
//
//    }
//
//    return YES;
//}
@end
