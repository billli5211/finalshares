//
//  ShopModel.h
//  购物车
//
//  Created by beijingduanluo on 16/1/7.
//  Copyright © 2016年 beijingduanluo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopModel : NSObject
@property(nonatomic,copy)NSString *imgStr;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *num;
@property(nonatomic,copy)NSString *isSelected;
@end
