//
//  UITableView+ZCExtension.h
//  iNews2.0
//
//  Created by 123 on 2018/1/30.
//  Copyright © 2018年 ronglian. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const UITABLEVIEW_RELOAD_NOTIFICATION = @"UITABLEVIEW_RELOAD_NOTIFICATION";

@protocol UITableViewNoDataSource<NSObject>

@optional
-(void)tableView:(UITableView *)tableView reloadDataWithContentType:(NSInteger)type;
@end

@interface UITableView (ZCExtension)<UITableViewNoDataSource>

@property (nonatomic, weak) id<UITableViewNoDataSource> errorDataSource;

-(void)tableViewLoadNoDataWithImage:(UIImage*)image Title:(NSString*)title;
@end



@interface UITableViewErrorView : UIView


@end
