//
//  iosapp
//
//  Created by bill li on 2016-01-28.
//  Copyright (c) 2016年 finalshares. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoModel : NSObject
/**
 *  视频ID
 */
@property(nonatomic,assign)int ID;
/**
 *  视频路径
 */
@property(nonatomic,copy)NSString *url;
/**
 *  视频名称
 */
@property(nonatomic,copy)NSString *name;
/**
 *  视频长度
 */
@property(nonatomic,assign)int length;
/**
 *  视频缩略图
 */
@property(nonatomic,copy)NSString  *image;

//提供一个对外的接口
+(instancetype)viodesModelWithDict:(NSDictionary *)dict;

@end
