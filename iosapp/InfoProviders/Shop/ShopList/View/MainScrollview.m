//
//  MainScrollview.m
//  GiftSay
//
//  Created by lanou on 15/12/16.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "MainScrollview.h"
#import "Biaoti.h"
@implementation MainScrollview

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame Array:(NSArray*)Array delegate:(id)delegate action:(SEL)action{
    self= [super initWithFrame:frame];
    if (self) {
              // _button.frame=CGRectMake(0, 0, 100, 30);
        self.contentSize=CGSizeMake(100*Array.count, 50);
        Biaoti*b=[[Biaoti alloc]init]; 
        //self.delegate=delegate;
        for (int i=0; i<Array.count; i++) {
            _button=[UIButton buttonWithType:(UIButtonTypeSystem)];
            
            _button.frame=CGRectMake(100*i, 10, 100, 30);
            _button.tag=i;
            
            b=Array[i];
            [_button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            [_button setTitle:b.name forState:(UIControlStateNormal)];
            [_button addTarget:delegate action:action forControlEvents:(UIControlEventTouchUpInside)];
            
            [self addSubview:_button];
            self.directionalLockEnabled=YES;
            self.alwaysBounceVertical=YES;
        
        }
    }
    
    return self;
    
}

@end
