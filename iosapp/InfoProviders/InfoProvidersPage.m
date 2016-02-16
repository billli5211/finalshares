//
//  InfoProvidersPage.m
//  iosapp
//
//  Created by bill li on 3/02/2016.
//  Copyright (c) 2016 finalshares. All rights reserved.
//

#import "InfoProvidersPage.h"
#import "Utils.h"
#import "Config.h"
#import "AboutPage.h"
#import "OSLicensePage.h"
#import "FeedBackViewController.h"

#import <RESideMenu.h>
#import <MBProgressHUD.h>
#import <AFNetworking.h>
#import <SDImageCache.h>

#import "AppDelegate.h"

#import "SXWeatherDetailVC.h"
#import "SXWeatherModel.h"
#import "SXHTTPManager.h"
#import "MJExtension.h"
#import "UIView+Frame.h"
#import "CityInfoViewController.h"
#import "BuyViewController.h"
#import "ClassViewController.h"
#import "CarViewController.h"

@interface InfoProvidersPage () <UIAlertViewDelegate>

@end

@implementation InfoProvidersPage

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"信息查询";
    self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.backgroundColor = [UIColor themeColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.separatorColor = [UIColor separatorColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [UITableViewCell new];
    
    
    NSArray *titles = @[
                        @[@"天气", @"城市信息",@"商品", @"购物列表",@"购物车"]
                        ];
    cell.textLabel.text = titles[indexPath.section][indexPath.row];
    cell.backgroundColor = [UIColor cellsColor];
    cell.textLabel.textColor = [UIColor titleColor];
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor selectCellSColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger section = indexPath.section, row = indexPath.row;
    
    if (section == 0) {
        if(row == 0){
            [self sendWeatherRequest];
        }else if (row == 1){
            CityInfoViewController *vc = [[CityInfoViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (row == 2){
            BuyViewController* buy = [[BuyViewController alloc] init];
            [self.navigationController pushViewController:buy animated:YES];
        }else if (row == 3){
            ClassViewController*classList=[[ClassViewController alloc]init];
            [self.navigationController pushViewController:classList animated:YES];
            
        }else if (row == 4){
            CarViewController *vc =[[CarViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
}

- (void)sendWeatherRequest
{
    NSString *url = @"http://c.3g.163.com/nc/weather/5YyX5LqsfOWMl%2BS6rA%3D%3D.html";
    [[SXHTTPManager manager]GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        SXWeatherModel *weatherModel = [SXWeatherModel objectWithKeyValues:responseObject];
        
        SXWeatherDetailVC *wdvc = [[SXWeatherDetailVC alloc]init];
        wdvc.weatherModel = weatherModel;
        [self.navigationController pushViewController:wdvc animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure %@",error);
    }];
}


@end
