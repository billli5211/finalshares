//
//  Biaoti.m
//  GiftSay
//
//  Created by lanou on 15/12/18.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "Biaoti.h"

@implementation Biaoti

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _Id=value;
    }


}

@end
