//
//  hostmodel.m
//  GiftSay
//
//  Created by lanou on 15/12/22.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "hostmodel.h"

@implementation hostmodel


- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.Id=value;
    }
}



@end
