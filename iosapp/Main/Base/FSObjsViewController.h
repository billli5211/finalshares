//
//  OSCObjsViewController.h
//  iosapp
//
//  Created by chenhaoxiang on 10/27/14.
//  Copyright (c) 2014 oschina. All rights reserved.
//


// bill json version base class
#import <UIKit/UIKit.h>
#import "Utils.h"

@interface FSObjsViewController : UITableViewController


@property (nonatomic, copy) NSString * (^generateURL)(int page);

@property (nonatomic, assign) int allCount;
@property (nonatomic, assign) int page;
@property(nonatomic,strong) NSMutableArray *arrayList;

@property (nonatomic, strong) UILabel *label;// only to calculate row height

@end
