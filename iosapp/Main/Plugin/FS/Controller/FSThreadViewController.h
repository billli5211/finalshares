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
    FSTypeLatest = 1,
    FSTypeHot,
    FSTypeSoution,
};

@interface FSThreadViewController : FSObjsViewController

- (instancetype)initWithFSType:(FSType)type;

@end
