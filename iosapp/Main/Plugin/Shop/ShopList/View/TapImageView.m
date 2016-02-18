//
//  TapImageView.m
//  GiftSay
//
//  Created by lanou on 15/12/18.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "TapImageView.h"

@implementation TapImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame target:(id)target action:(SEL)action{
    
    self=[super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer*tapgesture=[[UITapGestureRecognizer alloc]initWithTarget:target action:action];
        [self addGestureRecognizer:tapgesture];
        self.userInteractionEnabled=YES;
        
    }
    
    
    return self;
    
    
}
@end
