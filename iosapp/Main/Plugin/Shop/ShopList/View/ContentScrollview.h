//
//  ContentScrollview.h
//  GiftSay
//
//  Created by lanou on 15/12/18.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentScrollview : UIScrollView
@property (nonatomic,retain) UITableView  *maintable;
@property (nonatomic,assign) NSInteger  a;



- (instancetype)initWithFrame:(CGRect)frame count:(NSInteger)count delegate:(id)delegate;



@end
