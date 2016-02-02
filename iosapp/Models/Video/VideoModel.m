//
//  iosapp
//
//  Created by bill li on 2016-01-28.
//  Copyright (c) 2016年 finalshares. All rights reserved.
//

#import "VideoModel.h"


@implementation VideoModel
+(instancetype)viodesModelWithDict:(NSDictionary *)dict
{
    VideoModel *model=[[VideoModel alloc]init];
    //对象转换为int类型的
    model.ID=[dict[@"id"] intValue];
    model.url=dict[@"url"];
    model.name=dict[@"name"];
    model.length=[dict[@"length"] intValue];
    model.image=dict[@"image"];
    
    //不能使用KVC
    //    [model setValuesForKeysWithDictionary:dict];
    return model;
}


@end
