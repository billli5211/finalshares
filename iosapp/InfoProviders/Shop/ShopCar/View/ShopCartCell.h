//
//  ShopCartCell.h
//  购物车
//
//  Created by beijingduanluo on 16/1/7.
//  Copyright © 2016年 beijingduanluo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopModel.h"
@class ShopCartCell;
@protocol shopCartDelegate <NSObject>

-(void)shopCartDelegate:(ShopCartCell *)cell WithBtn:(UIButton *)btn;
-(void)shopCartDelegateNum:(ShopCartCell *)cell WithBtn:(UIButton *)btn;

@end
@interface ShopCartCell : UITableViewCell
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIImageView *headImgV;
@property(nonatomic,strong)UIButton *addNumBtn;
@property(nonatomic,strong)UIButton *cutNumBtn;
@property(nonatomic,strong)UILabel *numLabel;
@property(nonatomic,strong)UIButton *selectBtn;
@property(nonatomic,strong)UILabel *priceLabel;
@property(nonatomic,strong)UIButton *addShopBtn;
@property(nonatomic,strong)ShopModel *model;
@property(nonatomic,assign)id<shopCartDelegate>delegate;
@end
