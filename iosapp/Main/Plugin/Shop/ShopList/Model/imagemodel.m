//
//  imagemodel.m
//  GiftSay
//
//  Created by lanou on 15/12/18.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "imagemodel.h"

@implementation imagemodel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _Id=value;
    }
    if ([key isEqualToString:@"image_url"]) {
        _cover_image_url=value;
    }


}

@end
