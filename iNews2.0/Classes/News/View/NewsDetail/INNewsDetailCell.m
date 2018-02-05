//
//  INNewsDetailCell.m
//  iNews2.0
//
//  Created by 123 on 2018/2/2.
//  Copyright © 2018年 ronglian. All rights reserved.
//

#import "INNewsDetailCell.h"
#import "PDNewsModel.h"

@interface INNewsDetailCell()<WKNavigationDelegate>

@end

@implementation INNewsDetailCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    
}

-(void)loadNewsDetailWithString:(NSString*)detail{
    
    NSString *htmlString = [NSString stringWithFormat:@"<html>\n"
                            "<head>\n"
                            "<meta charset=\"UTF-8\"/>"
                            "<meta content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0\" name=\"viewport\"/>"
                            "<meta content=\"yes\" name=\"apple-mobile-web-app-capable\"/>"
                            "<meta content=\"black\" name=\"apple-mobile-web-app-status-bar-style\"/>"
                            "<meta content=\"telephone=no\" name=\"format-detection\"/>"
                            "<title>人民日报详情页</title>"
                            "<style>"
                            "body{"
                            "font-family: Arial, Helvetica, sans-serif;"
                            "font-size: 15px;"
                            "font-weight: normal;"
                            "word-wrap: break-word;"
                            "-webkit-user-select: auto;"
                            "user-select: auto;"
                            "}"
                            ".content{"
                            "padding: 10px 5px;"
                            "background: #fff;"
                            "margin-bottom: 10px;"
                            "}"
                            ".content .title{"
                            "font-size: 27px;"
                            "font-weight: bold;"
                            "margin-bottom: 8px;"
                            "color: #333;"
                            "}"
                            ".content .info{"
                            "color: #888;"
                            "font-size: 11px;"
                            "font-weight: normal"
                            "}"
                            ".content .info .author{"
                            "margin-right: 10px;"
                            "}"
                            ".content .info .time{"
                            "padding:0 5px;"
                            "}"
                            ".main{"
                            "color: #333"
                            "}"
                            ".main p{"
                            "line-height: 28px"
                            "}"
                            ".main img{width: 100%%}"
                            "</style>"
                            "</head>"
                            "<body>"
                            "<div id=\"content\">"
                            "<div class=\"main\" id=\"main\">%@"
                            //内容
                            //内容 end
                            "</div>"
                            "</div>"
                            "<script>"
                            "var dom = document.getElementById('main');"
                            "var img = dom.getElementsByTagName('img');"
                            "for(var i=0;img.length>i;i++){"
                            "img[i].style.width = '100%%';"
                            "img[i].style.height ='auto'\n"
                            "img[i].index = i;"
                            "img[i].onclick = function(){"
                            "alert(this.index);"
                            "}"
                            "}"
                            "</script>"
                            "</body>"
                            "</html>"
                            "",detail];
//    [self.webView loadHTMLString:htmlString baseURL:nil];
}

@end
