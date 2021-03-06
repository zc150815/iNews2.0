//
//  INNewsListBaseCell.h
//  iNews2.0
//
//  Created by 123 on 2018/1/25.
//  Copyright © 2018年 ronglian. All rights reserved.
//

#import "INBaseCell.h"

@class INNewsListBaseCell;

static CGFloat const BASE_TIME_FONTSIZE = 12; //来源,时间字号

@protocol INNewsListBaseCellDelegate <NSObject>

@optional
-(void)cellCloseWithCellWithContentCell:(INNewsListBaseCell*)contentCell;
@end

@interface INNewsListBaseCell : INBaseCell


@property (nonatomic,weak) id<INNewsListBaseCellDelegate> delegate;
@property (nonatomic,assign) BOOL hiddenDeleBtn;
@end
