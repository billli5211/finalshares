//
//  Utils.m
//  iosapp
//
//  Created by chenhaoxiang on 14-10-16.
//  Copyright (c) 2014年 oschina. All rights reserved.
//

#import "JsonUtils.h"



@implementation JsonUtils


#pragma mark - 处理API返回信息

+ (NSArray *)getConfig:(NSString*)fileName with:(NSString*) item
{
    NSString *file = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSString *str = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:NULL];
    NSError *jsonError;
    NSData *objectData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&jsonError];
    return json[item];
}


@end
