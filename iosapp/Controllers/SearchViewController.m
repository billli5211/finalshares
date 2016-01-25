//
//  SearchViewController.m
//  iosapp
//
//  Created by chenhaoxiang on 1/22/15.
//  Copyright (c) 2015 oschina. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResultsViewController.h"
#import "Utils.h"
#import "AppDelegate.h"
#import "Config.h"

@interface SearchViewController () <UISearchBarDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation SearchViewController

- (instancetype)init
{
    self = [super initWithTitle:nil
                   andSubTitles:@[@"软件", @"问答", @"博客", @"新闻"]
                 andControllers:@[
                                  [[SearchResultsViewController alloc] initWithType:@"software"],
                                  [[SearchResultsViewController alloc] initWithType:@"post"],
                                  [[SearchResultsViewController alloc] initWithType:@"blog"],
                                  [[SearchResultsViewController alloc] initWithType:@"news"]
                                  ]];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        
        __weak SearchViewController *weakSelf = self;
        for (SearchResultsViewController *searchResultsVC in self.viewPager.childViewControllers) {
            searchResultsVC.viewDidScroll = ^ {
                [weakSelf.searchBar resignFirstResponder];
            
            };
        }
        
        weakSelf.viewPager.viewDidScroll = ^{
            [self.searchBar resignFirstResponder];
        };
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _searchBar = [UISearchBar new];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"请输入关键字";
    ((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode = [Config getMode];
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode) {
        _searchBar.keyboardAppearance = UIKeyboardAppearanceDark;
        _searchBar.barTintColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    }
    
    self.navigationItem.titleView = _searchBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (_searchBar.text.length == 0) {return;}
    
    [searchBar resignFirstResponder];
    
    for (SearchResultsViewController *searchResultsVC in self.viewPager.childViewControllers) {
        searchResultsVC.keyword = searchBar.text;
        [searchResultsVC refresh];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.viewPager.tableView reloadData];
    });
}





@end
