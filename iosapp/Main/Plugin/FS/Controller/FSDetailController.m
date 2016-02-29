//
//  SXDetailController.m
//  81 - 网易新闻
//
//  Created by 董 尚先 on 15-1-24.
//  Copyright (c) 2015年 ShangxianDante. All rights reserved.
//

#import "FSDetailController.h"
#import "FSAPI.h"

@interface FSDetailController ()<UIWebViewDelegate>
@property (strong, nonatomic) UIWebView *webView;

@end

@implementation FSDetailController



- (UIWebView *)webView
{
    if (!_webView) {
        UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SXSCREEN_W, 700)];
        _webView = web;
    }
    return _webView;
}


- (instancetype)initWithModel:(FSThread *)thread
{
    self = [super init];
    
    _urlId = thread.tid;
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    webView2 = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SXSCREEN_W, 700)];

    NSString* url = [NSString stringWithFormat:@"%@%d", FSAPI_ARTICLE_DETAIL, _urlId];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.view addSubview: webView2];
    [webView2 loadRequest:request];
}


@end
