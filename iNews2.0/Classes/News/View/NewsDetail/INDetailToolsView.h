//
//  INDetailToolsView.h
//  iNews2.0
//
//  Created by 123 on 2018/2/2.
//  Copyright © 2018年 ronglian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    INDetailToolsViewTypeSearch = 103,
    INDetailToolsViewTypeShare = 100,
    INDetailToolsViewTypeCollect = 101,
    INDetailToolsViewTypeComment = 102
} INDetailToolsViewType;

@class INDetailToolsView;

@protocol INDetailToolsViewDelegate<NSObject>

-(void)INDetailToolsView:(INDetailToolsView*)toolsView toolsButtonClickWith:(INDetailToolsViewType)type;
@end

@interface INDetailToolsView : UIView

@property (nonatomic, weak) id<INDetailToolsViewDelegate> delegate;

@end
