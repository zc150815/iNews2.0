//
//  INNewsListModel.h
//  iNews2.0
//
//  Created by 123 on 2018/1/25.
//  Copyright © 2018年 ronglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface INNewsListModel : NSObject

@property (nonatomic,copy) NSString *ID;//id
@property (nonatomic,copy) NSString *title;//新闻标题
@property (nonatomic,copy) NSString *pub_time;//发布时间
@property (nonatomic,copy) NSString *image_list;//图片数量
@property (nonatomic,strong) NSArray *image_list_detail;//图片数组
@property (nonatomic,assign) INNewsListType listType;//新闻列表样式
@property (nonatomic,copy) NSString *url;//图片链接地址


@property (nonatomic,assign) BOOL isEditing;
@property (nonatomic,assign) BOOL canEdit;
@property (nonatomic,assign) BOOL isRead;

@property (nonatomic,copy) NSString *newsTitle;
@property (nonatomic,copy) NSString *newsWebsite;
@property (nonatomic,copy) NSString *comment;
@property (nonatomic,copy) NSString *detail;


//----------------------------------------------------------------------
@property (nonatomic,copy) NSString *contenttype;//标识
@property (nonatomic, strong) NSArray *news;
@property (nonatomic, strong) NSArray *top_news;
@property (nonatomic,copy) NSString *channel;//新闻所在频道
@property (nonatomic,copy) NSString *comment_num;//新闻评论数量
@property (nonatomic,copy) NSString *create_time;
@property (nonatomic,copy) NSString *return_time;
@property (nonatomic,copy) NSString *return_last_time;
@property (nonatomic,copy) NSString *to_top;//是否为置顶标识
@property (nonatomic,copy) NSString *desc;
@property (nonatomic,copy) NSString *news_id;
@property (nonatomic,copy) NSString *original;
@property (nonatomic,copy) NSString *Final;
@property (nonatomic,copy) NSString *plus_refresh;


@end
