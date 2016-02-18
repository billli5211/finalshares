//
//  ShopCartCell.m
//  购物车
//
//  Created by beijingduanluo on 16/1/7.
//  Copyright © 2016年 beijingduanluo. All rights reserved.
//


#import "ShopCartCell.h"
#import "UIButton+Extension.h"
#import "UILabel+Extension.h"
#import "UIImageView+Extension.h"
#import "UILabel+Extension.h"

#import "shopConfig.h"

@implementation ShopCartCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self  =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _selectBtn =[UIButton addBtnImage:@"btnSelected" AndFrame:CGRectMake(10*Width, 25*Height, 30*Width, 30*Height) WithTarget:self action:@selector(selectAllAndCancel:)];
        _selectBtn.selected = YES;
        [self addSubview:_selectBtn];
        
        _headImgV =[UIImageView addImgWithFrame:CGRectMake(50*Width, 10*Height, 60*Width, 60*Height) AndImage:@"img-1"];
        [self addSubview:_headImgV];
        
        _titleLabel =[UILabel addLabelWithFrame:CGRectMake(115*Width, 15*Height, 100*Width, 15*Height) AndText:@"高级玫瑰礼盒" AndFont:12*Width AndAlpha:1 AndColor:nil];
        [self addSubview:_titleLabel];
        
        _priceLabel =[UILabel addLabelWithFrame:CGRectMake(115*Width, 45*Height, 100*Width, 15*Height) AndText:@"￥123" AndFont:12 AndAlpha:1 AndColor:[UIColor redColor]];
        [self addSubview:_priceLabel];
        
        _addShopBtn =[UIButton addBtnImage:nil AndFrame:CGRectMake(SCREEN_WIDTH-100*Width, 25*Height, 80*Width, 30*Height) WithTarget:self action:@selector(addShopClick:)];
        [_addShopBtn setBackgroundImage:[UIImage imageNamed:@"addShopNum_bord"] forState:UIControlStateNormal];
        [_addShopBtn setTitle:@"+" forState:UIControlStateNormal];
        _addShopBtn.tag = 1000;
        [_addShopBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        
        UIImageView *img =[UIImageView addImgWithFrame:CGRectMake(SCREEN_WIDTH-100*Width, 25*Height, 80*Width, 30*Height) AndImage:@"addShopNum_bord"];
        [self addSubview:img];
       // [self addSubview:_addShopBtn];
        
        _addNumBtn =[UIButton addBtnImage:nil AndFrame:CGRectMake( SCREEN_WIDTH-50*Width, 25*Height,30*Width, 30*Height) WithTarget:self action:@selector(addShopClick:)];
        _addNumBtn.tag = 2000;
        [_addNumBtn setTitle:@"+" forState:UIControlStateNormal];
        [_addNumBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self addSubview:_addNumBtn];
        _cutNumBtn =[UIButton addBtnImage:nil AndFrame:CGRectMake(SCREEN_WIDTH-100*Width, 25*Height,30*Width, 30*Height) WithTarget:self action:@selector(addShopClick:)];
        _cutNumBtn.tag = 3000;
        [_cutNumBtn setTitle:@"-" forState:UIControlStateNormal];
        [_cutNumBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _numLabel =[UILabel addLabelWithFrame:CGRectMake(SCREEN_WIDTH-70*Width, 25*Height, 20*Width, 30*Height) AndText:@"1" AndFont:12 AndAlpha:1 AndColor:[UIColor redColor]];
        _numLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_numLabel];
        [self addSubview:_cutNumBtn];
    }
    return self;
}
//增加数量方法
-(void)addShopClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(shopCartDelegateNum:WithBtn:)]) {
        [self.delegate shopCartDelegateNum:self WithBtn:btn];
    }
}
//取消选中方法
-(void)selectAllAndCancel:(UIButton *)btn
{
    btn.selected =!btn.selected;
    if (btn.selected) {
        [btn setImage:[UIImage imageNamed:@"btnSelected"] forState:UIControlStateNormal];
    }else{
        [btn setImage:[UIImage imageNamed:@"addShop_bord"] forState:UIControlStateNormal];
    }
    if ([self.delegate respondsToSelector:@selector(shopCartDelegate:WithBtn:)]) {
        [self.delegate shopCartDelegate:self WithBtn:btn];
    }
}


-(void)setModel:(ShopModel *)model
{
    if (_model != model) {
        _model = model;
    }
    _priceLabel.text = [NSString stringWithFormat:@"￥%@",model.price];
    _titleLabel.text =model.title;
    _headImgV.image =[UIImage imageNamed:model.imgStr];
    if ([model.isSelected isEqualToString:@"true"]) {
        _selectBtn.selected = YES;
        [_selectBtn setImage:[UIImage imageNamed:@"btnSelected"] forState:UIControlStateNormal];
    }else{
        _selectBtn.selected = NO;
        [_selectBtn setImage:[UIImage imageNamed:@"addShop_bord"] forState:UIControlStateNormal];
    }
    _numLabel.text =model.num;
}









@end
