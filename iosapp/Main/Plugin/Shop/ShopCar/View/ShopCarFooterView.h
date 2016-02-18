//
//  FooterView.h
//  购物车
//
//  Created by beijingduanluo on 16/1/7.
//  Copyright © 2016年 beijingduanluo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopModel.h"
@class ShopCarFooterView;
@protocol footerViewDelegate <NSObject>

-(void)footerViewdelegate:(ShopCarFooterView *)footer AndBtn:(UIButton *)btn;

@end

@interface ShopCarFooterView : UITableViewHeaderFooterView
@property(nonatomic,strong)UIButton *allSelectBtn;
@property(nonatomic,strong)UILabel *totalPriceLabel;
@property(nonatomic,assign)BOOL ison;
@property(nonatomic,assign)id<footerViewDelegate>delegate;
@property(nonatomic,strong)ShopModel *model;

@end
