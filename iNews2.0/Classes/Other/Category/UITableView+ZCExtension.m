//
//  UITableView+ZCExtension.m
//  iNews2.0
//
//  Created by 123 on 2018/1/30.
//  Copyright © 2018年 ronglian. All rights reserved.
//

#import "UITableView+ZCExtension.h"
#import <objc/runtime.h>



@implementation UITableView (ZCExtension)

-(void)tableViewLoadNoDataWithImage:(UIImage*)image Title:(NSString*)title{

    self.bounces = NO;
    [self reloadData];
    self.contentInset = UIEdgeInsetsZero;
    
    UIButton *noDataBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    noDataBtn.frame = self.bounds;
    noDataBtn.adjustsImageWhenHighlighted = NO;
    [noDataBtn setBackgroundColor:[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1]];
    [noDataBtn addTarget:self action:@selector(reloadDataBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [noDataBtn setImage:[UIImage scaleFromImage:image toSize:CGSizeMake(80, 80)] forState:UIControlStateNormal];
    [noDataBtn setTitle:title forState:UIControlStateNormal];
    [noDataBtn setTitleColor:[UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1] forState:UIControlStateNormal];
    noDataBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    noDataBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    noDataBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [noDataBtn setTitleEdgeInsets:UIEdgeInsetsMake(noDataBtn.imageView.frame.size.height+50,-noDataBtn.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [noDataBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,0.0, -noDataBtn.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
    self.backgroundView = noDataBtn;
    
}

-(void)reloadDataBtnClick{
    
    self.backgroundView = nil;
    self.bounces = YES;
//    if ([self.errorDataSource respondsToSelector:@selector(tableView:reloadDataWithContentType:)] ) {
//        [self.errorDataSource tableView:self reloadDataWithContentType:0];
//    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:UITABLEVIEW_RELOAD_NOTIFICATION object:nil];
}
-(id<UITableViewNoDataSource>)errorDataSource{
    return objc_getAssociatedObject(self, @"errorDataSourceKey");
}
-(void)setErrorDataSource:(id<UITableViewNoDataSource>)errorDataSource{
    objc_setAssociatedObject(self, @"errorDataSourceKey", errorDataSource, OBJC_ASSOCIATION_ASSIGN);
}

@end


@implementation UITableViewErrorView :UIView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UIButton *noDataBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        noDataBtn.frame = frame;
        [noDataBtn setBackgroundColor:[UIColor purpleColor]];
        [noDataBtn addTarget:self action:@selector(reloadDataBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:noDataBtn];
    }
    return self;
}


@end
