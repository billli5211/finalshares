//
//  SXDetailController.h
//  81 - 网易新闻
//
//  Created by 董 尚先 on 15-1-24.
//  Copyright (c) 2015年 ShangxianDante. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSThread.h"

@interface FSDetailController : UIViewController
{
    UIWebView *webView2;
}

@property(nonatomic,strong) FSThread *newsModel;

@property (nonatomic,assign) NSInteger index;


- (instancetype)initWithModel:(FSThread *)post;

@end
