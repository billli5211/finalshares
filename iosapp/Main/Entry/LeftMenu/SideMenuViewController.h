//
//  SideMenuViewController.h
//  iosapp
//
//  Created by chenhaoxiang on 1/31/15.
//  Copyright (c) 2015 oschina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideMenuViewController : UITableViewController
@property (nonatomic, strong) NSArray *menuItems;
/**
 *  存放url的数组
 */
@property(nonatomic,strong) NSArray *arrayLists;
@end
