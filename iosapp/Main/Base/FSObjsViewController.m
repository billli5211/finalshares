//
//  OSCObjsViewController.m
//  iosapp
//
//  Created by chenhaoxiang on 10/27/14.
//  Copyright (c) 2014 oschina. All rights reserved.
//

#import "FSObjsViewController.h"

#import "MJExtension.h"
#import "MJRefresh.h"
#import "SXNetworkTools.h"
#import "OSCAPI.h"
#import <AFNetworking.h>


@interface FSObjsViewController ()

@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property(nonatomic,assign)BOOL update;

@end


@implementation FSObjsViewController

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _page = 0;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _label = [UILabel new];
    _label.numberOfLines = 0;
    _label.lineBreakMode = NSLineBreakByWordWrapping;
    _label.font = [UIFont boldSystemFontOfSize:14];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    
    self.update = YES;
    //    self.tableView.headerHidden = NO;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    //    NSLog(@"bbbb");
    if (self.update == YES) {
        // 马上进入刷新状态
        [self.tableView.mj_header beginRefreshing];
        
        self.update = NO;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dawnAndNightMode:) name:@"dawnAndNight" object:nil];
    
    self.tableView.backgroundColor = [UIColor themeColor];
    
}


#pragma mark - /************************* 刷新数据 ***************************/
// ------下拉刷新
- (void)loadData
{
    [self loadDataForType:1 withURL:self.generateURL(0)];
}

// ------上拉加载
- (void)loadMoreData
{
    if(_page < _allCount - 1){
        [self loadDataForType:2 withURL:self.generateURL(++_page)];
    }
    
}

// ------公共方法
- (void)loadDataForType:(int)type withURL:(NSString *)allUrlstring
{
    [[[SXNetworkTools sharedNetworkTools]GET:allUrlstring parameters:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
        NSLog(@"%@",allUrlstring);
        
        /*
         NSString *key = [responseObject.keyEnumerator nextObject];
         
         NSArray *temArray = responseObject[key];
         */
        
        _allCount = [responseObject[@"totalpage"] integerValue];
        
        NSArray *arrayM = [self parseJson:responseObject];
        
        
        if (type == 1) {
            _page = 1;
            self.arrayList = arrayM;
            
            // 马上进入刷新状态
            [self.tableView.mj_header endRefreshing];
            
            [self.tableView reloadData];
        }else if(type == 2){
            [self.arrayList addObjectsFromArray:arrayM];
            
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }] resume];
}// ------想把这里改成block来着

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"dawnAndNight" object:nil];
}


-(void)dawnAndNightMode:(NSNotification *)center
{
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"cellForRowAtIndexPath: Over ride in subclasses");
    return nil;
    
}

#pragma mark - /************************* tbv代理方法 ***************************/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"heightForRowAtIndexPath:: Over ride in subclasses");
    return 100;
}

- (NSArray *)parseJson:(id)responseObject
{
    NSAssert(false, @"Over ride in subclasses");
    return nil;
}


@end
