//
//  iosapp
//
//  Created by bill li on 2016-01-28.
//  Copyright (c) 2016年 finalshares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"

@class VideoModel;

@interface VideoCell : UITableViewCell

@property(nonatomic,strong)VideoModel  *model;
+(instancetype)cellWithTableView:(UITableView *)tableView;

@end