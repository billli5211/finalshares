//
//  ClassCollectionViewCell.m
//  GiftSay
//
//  Created by lanou on 15/12/19.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "ClassCollectionViewCell.h"
#import "Classmodel.h"
#import "UIImageView+AFNetworking.h"
#import "detailmodel.h"
@implementation ClassCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self=[super initWithFrame:frame];
    if (self) {
        CGFloat height=self.frame.size.height;
        
        CGFloat width=self.frame.size.width;
        
        
        
        _picture=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    
        [self setImageViewWithLayer:_picture];
        [self addSubview:_picture];
        _label=[[UILabel alloc]initWithFrame:CGRectMake(0, height, width, 20)];
        _label.textAlignment=NSTextAlignmentCenter;
       _label.text=@"1";
        _label.font=[UIFont systemFontOfSize:14];
        [self addSubview:_label];
    }
    

    return self;
}


- (void)setImageViewWithLayer:(UIImageView*)tapImageview{
    
    tapImageview.layer.masksToBounds=YES;
    tapImageview.layer.borderWidth=2;
    tapImageview.layer.cornerRadius=tapImageview.bounds.size.height/2;
    tapImageview.layer.borderColor=[[UIColor whiteColor]CGColor];
    
    
    
}

- (void)setModel:(Classmodel *)model{
    if (_model!=model) {
        _model=model;
    
        _label.text=model.name;
                 [_picture setImage:[UIImage imageNamed:@"占位.png"]];
        [_picture setImageWithURL:[NSURL URLWithString:model.icon_url]];
        
    
    }
}

- (void)setDetail:(detailmodel *)detail{
    if (_detail!=detail) {
        _detail=detail;
        NSLog(@"%@",detail.name);
        _label.text=detail.name;
        [_picture setImageWithURL:[NSURL URLWithString:detail.icon_url]];
    }
}





@end
