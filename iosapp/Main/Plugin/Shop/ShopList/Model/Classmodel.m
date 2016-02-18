//
//  Classmodel.m
//  GiftSay
//
//  Created by lanou on 15/12/19.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "Classmodel.h"

@implementation Classmodel


- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.Id=value;
    }
}

@end
