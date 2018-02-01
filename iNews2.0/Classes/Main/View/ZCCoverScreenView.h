//
//  ZCCoverScreenView.h
//  iNews2.0
//
//  Created by 123 on 2018/2/1.
//  Copyright © 2018年 ronglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZCCoverScreenView;
@protocol ZCCoverScreenViewDelegate<NSObject>

@optional
-(void)makeSureToRemoveNotInterestedNews;

@optional


@end

@interface ZCCoverScreenView : UIView

@property (nonatomic,assign) BOOL isShowing;
@property (nonatomic, weak) id<ZCCoverScreenViewDelegate> delegate;

+(ZCCoverScreenView*)sharedCoverScreenView;
+(void)show;
+(void)dismiss;


+(void)removeNotInterstedNewsWithSubview:(UIView*)subview;
@end
