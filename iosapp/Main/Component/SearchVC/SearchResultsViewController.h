//
//  SearchResultsViewController.h
//  iosapp
//
//  Created by chenhaoxiang on 1/22/15.
//  Copyright (c) 2015 oschina. All rights reserved.
//

#import "OSCObjsViewController.h"

@interface SearchResultsViewController : OSCObjsViewController

@property (nonatomic, copy) NSString *keyword;
@property (nonatomic, copy) void (^viewDidScroll)();

- (instancetype)initWithType:(NSString *)type;

@end
