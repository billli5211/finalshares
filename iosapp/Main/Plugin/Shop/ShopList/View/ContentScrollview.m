//
//  ContentScrollview.m
//  GiftSay
//
//  Created by lanou on 15/12/18.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "ContentScrollview.h"

@implementation ContentScrollview

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame count:(NSInteger)count delegate:(id)delegate{
    self= [super initWithFrame:frame];
    if (self) {
       
        self.delegate=delegate;
        self.pagingEnabled=YES;
        self.directionalLockEnabled=YES;
        self.alwaysBounceVertical=YES;
    }
    
    return self;
}



@end
