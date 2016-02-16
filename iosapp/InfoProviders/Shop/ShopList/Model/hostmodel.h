//
//  hostmodel.h
//  GiftSay
//
//  Created by lanou on 15/12/22.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface hostmodel : NSObject
@property (nonatomic,copy) NSString  *Id;

@property (nonatomic,copy) NSString  *name;

@property (nonatomic,copy) NSString  *price;

@property (nonatomic,copy) NSString  *url;

@property (nonatomic,assign) float  favorites_count;

@property (nonatomic,copy) NSString  *cover_image_url;




@end
