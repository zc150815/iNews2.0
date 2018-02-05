//
//  INNewsListLiveCell.h
//  iNews2.0
//
//  Created by 123 on 2018/1/25.
//  Copyright © 2018年 ronglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INNewsListBaseCell.h"

static CGFloat const LIVE_TITLE_FONTSIZE = 24; //标题字号


@interface INNewsListLiveCell : INNewsListBaseCell

@property (nonatomic,strong) INNewsListModel *model;

@end
