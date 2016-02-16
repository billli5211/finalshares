//
//  HeaderView.m
//  购物车
//
//  Created by beijingduanluo on 16/1/7.
//  Copyright © 2016年 beijingduanluo. All rights reserved.
//

#import "ShopCarHeaderView.h"
#import "UIImageView+Extension.h"
#import "UILabel+Extension.h"

@implementation ShopCarHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self) {
        _shopImgV =[UIImageView addImgWithFrame:CGRectMake(15*Width, 5*Height, 20*Width, 20*Height) AndImage:@"shop_Img"];
        [self addSubview:_shopImgV];
        
        _shopNameLabel =[UILabel addLabelWithFrame:CGRectMake(40*Width, 5*Height, 150*Width, 20*Height) AndText:@"蔷薇之花" AndFont:13*Width AndAlpha:1 AndColor:nil];
        [self addSubview:_shopNameLabel];
        
    }
    return self;
}

@end
