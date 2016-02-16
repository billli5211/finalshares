//
//  FooterView.m
//  购物车
//
//  Created by beijingduanluo on 16/1/7.
//  Copyright © 2016年 beijingduanluo. All rights reserved.
//

#import "ShopCarFooterView.h"
#import "UIButton+Extension.h"
#import "UILabel+Extension.h"

@implementation ShopCarFooterView

-(instancetype)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self) {
        _allSelectBtn =[UIButton addBtnImage:nil AndFrame:CGRectMake(10*Width, 5*Height, 30*Width, 30*Width) WithTarget:self action:@selector(allShopSelected:)];
        
        UILabel *label =[UILabel addLabelWithFrame:CGRectMake(40*Width, 5*Height, 50*Width, 30*Height) AndText:@"全选" AndFont:11 AndAlpha:1 AndColor:nil];
        [self addSubview:label];
        [self addSubview:_allSelectBtn];
        
        _totalPriceLabel =[UILabel addLabelWithFrame:CGRectMake(120*Width, 5*Height, 100*Width, 30*Height) AndText:@"总价：" AndFont:12 AndAlpha:1 AndColor:[UIColor redColor]];
        [self addSubview:_totalPriceLabel];
        
        UIImageView *img =[[UIImageView alloc]initWithFrame:CGRectMake(0, 40*Height, SCREEN_WIDTH, 10*Height)];
        img.backgroundColor =[UIColor lightGrayColor];
        [self addSubview:img];
        
    }
    return self;
}





-(void)allShopSelected:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if ([self.delegate respondsToSelector:@selector(footerViewdelegate:AndBtn:)]) {
        [self.delegate footerViewdelegate:self AndBtn:btn];
    }
}



@end
