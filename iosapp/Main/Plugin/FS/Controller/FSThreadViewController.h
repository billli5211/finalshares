//
//  PostsViewController.h
//  iosapp
//
//  Created by chenhaoxiang on 10/27/14.
//  Copyright (c) 2014 oschina. All rights reserved.
//

#import "FSObjsViewController.h"

typedef NS_ENUM(int, FSType)
{
    FSTypeDate = 1,
    FSTypeHot,
    FSTypeRecommend,
};

@interface FSThreadViewController : FSObjsViewController

- (instancetype)initWithFSType:(FSType)type;
- (instancetype)initWithCategory:(int)category;


@end
