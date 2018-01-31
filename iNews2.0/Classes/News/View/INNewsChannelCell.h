//
//  INNewsChannelCell.h
//  iNews2.0
//
//  Created by 123 on 2018/1/28.
//  Copyright © 2018年 ronglian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class INNewsListModel,INNewsChannelCell;


@protocol INNewsChannelCellDelegate<NSObject>

@optional
-(void)removeChannelWithINNewsChannelCell:(INNewsChannelCell*)cell;
@end


@interface INNewsChannelCell : UICollectionViewCell

@property (nonatomic,strong) INNewsListModel *model;
@property (nonatomic,weak) id<INNewsChannelCellDelegate> delegate;

@end
