//
//  SXDetailController.m
//  81 - 网易新闻
//
//  Created by 董 尚先 on 15-1-24.
//  Copyright (c) 2015年 ShangxianDante. All rights reserved.
//

#import "FSDetailController.h"


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


- (instancetype)initWithModel:(FSThread *)post
{
    self = [super init];
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    webView2 = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SXSCREEN_W, 700)];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://finalshares.com/read-7310"]];
    [self.view addSubview: webView2];
    [webView2 loadRequest:request];
}


@end
