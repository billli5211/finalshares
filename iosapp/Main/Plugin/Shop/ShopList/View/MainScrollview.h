//
//  MainScrollview.h
//  GiftSay
//
//  Created by lanou on 15/12/16.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainScrollview : UIScrollView

@property (nonatomic,retain) UIButton  *button;


- (instancetype)initWithFrame:(CGRect)frame Array:(NSArray*)Array delegate:(id)delegate action:(SEL)action ;








@end
