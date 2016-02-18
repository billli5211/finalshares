//
//  headerview.m
//  GiftSay
//
//  Created by lanou on 15/12/21.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "headerview.h"
#import "TapImageView.h"
#import "UIImageView+AFNetworking.h"
@implementation headerview

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate action:(SEL)action imageArray:(NSArray*)imageArray {
    
    self=[super initWithFrame:frame];
    if (self) {
        NSMutableArray*insterimagearray=[NSMutableArray arrayWithArray:imageArray];
        
        self.contentSize=CGSizeMake(insterimagearray.count*100, 0);
        
        self.bounces=NO;
        self.delegate=delegate;
        self.pagingEnabled=YES;
        //self.contentOffset=CGPointMake(kwidth, 0);
        for (int i=0; i<insterimagearray.count; i++) {
            TapImageView*tapimage=[[TapImageView alloc]initWithFrame:CGRectMake(i*110, 0,100, self.bounds.size.height)target:delegate action:action];
            
            [tapimage setImageWithURL:[NSURL URLWithString:insterimagearray[i]]];
            
            //[tapimage setImage:[UIImage imageNamed:insterimagearray[i]]];
            [self addSubview:tapimage];
        }
        
        
        
    }
    
    
    
    
    return self;
    
}







@end
