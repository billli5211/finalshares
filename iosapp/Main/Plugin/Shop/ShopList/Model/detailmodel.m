//
//  detailmodel.m
//  GiftSay
//
//  Created by lanou on 15/12/21.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "detailmodel.h"

@implementation detailmodel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.Id=value;
    }
}

//- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
//}



@end
