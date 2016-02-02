//
//  SideMenuViewController.m
//  iosapp
//
//  Created by chenhaoxiang on 1/31/15.
//  Copyright (c) 2015 oschina. All rights reserved.
//

#import "SideMenuViewController.h"
#import "Config.h"
#import "Utils.h"
#import "OSCUser.h"
#import "SwipableViewController.h"
#import "PostsViewController.h"
#import "BlogsViewController.h"
#import "SoftwareCatalogVC.h"
#import "SoftwareListVC.h"
#import "SettingsPage.h"
#import "LoginViewController.h"

#import "AppDelegate.h"

#import <RESideMenu.h>
#import <MBProgressHUD.h>
#import <AFNetworking.h>
#import <ReactiveCocoa.h>
#import <UIImageView+WebCache.h>

#import "ModuleCustom.h"
#import "WeiboTableViewController.h"
#import "VideoTableViewController.h"

@implementation SideMenuViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:@"userRefresh" object:nil];
    
    self.tableView.bounces = NO;
    
    self.tableView.backgroundColor = [UIColor titleBarColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dawnAndNightMode:) name:@"dawnAndNight" object:nil];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _menuItems = appDelegate.menuItems;

}

- (void)dawnAndNightMode:(NSNotification *)center
{
    self.tableView.backgroundColor = [UIColor titleBarColor];
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 160;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    OSCUser *myProfile = [Config myProfile];
    
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor clearColor];
    
    UIImageView *avatar = [UIImageView new];
    avatar.contentMode = UIViewContentModeScaleAspectFit;
    [avatar setCornerRadius:30];
    avatar.userInteractionEnabled = YES;
    avatar.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:avatar];
    if (myProfile.userID) {
        [avatar loadPortrait:myProfile.portraitURL];
    } else {
        avatar.image = [UIImage imageNamed:@"default-portrait"];
    }
    
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = myProfile.name;
    nameLabel.font = [UIFont boldSystemFontOfSize:20];
    
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode){
        nameLabel.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    } else {
        nameLabel.textColor = [UIColor colorWithHex:0x696969];
    }
    nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:nameLabel];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(avatar, nameLabel);
    NSDictionary *metrics = @{@"x": @([UIScreen mainScreen].bounds.size.width / 4 - 15)};
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[avatar(60)]-10-[nameLabel]-15-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-x-[avatar(60)]" options:0 metrics:metrics views:views]];
    
    avatar.userInteractionEnabled = YES;
    nameLabel.userInteractionEnabled = YES;
    [avatar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushLoginPage)]];
    [nameLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushLoginPage)]];
        
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menuItems count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [UITableViewCell new];
    
    cell.backgroundColor = [UIColor clearColor];
    
    UIView *selectedBackground = [UIView new];
    selectedBackground.backgroundColor = [UIColor colorWithHex:0xCFCFCF];
    [cell setSelectedBackgroundView:selectedBackground];
    
    NSString *title = [[_menuItems objectAtIndex:indexPath.row] objectForKey:@"title"];
    NSString *image = [[_menuItems objectAtIndex:indexPath.row] objectForKey:@"image"];
    NSString *itemId = [[_menuItems objectAtIndex:indexPath.row] objectForKey:@"id"];
    
    cell.imageView.image = [UIImage imageNamed:image];
    cell.textLabel.text = title;
    
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode){
        cell.textLabel.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    } else {
        cell.textLabel.textColor = [UIColor colorWithHex:0x555555];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:19];
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor selectCellSColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *title = [[_menuItems objectAtIndex:indexPath.row] objectForKey:@"title"];
    NSString *itemId = [[_menuItems objectAtIndex:indexPath.row] objectForKey:@"id"];
    NSArray *subTitle = [[_menuItems objectAtIndex:indexPath.row] objectForKey:@"subTitle"];
    
    if ([itemId isEqualToString:@"qa"]) {
        SwipableViewController *newsSVC = [[SwipableViewController alloc] initWithTitle:title
                                                                           andSubTitles:subTitle
                                                                         andControllers:@[
                                                                                          [[PostsViewController alloc] initWithPostsType:PostsTypeQA],
                                                                                          [[PostsViewController alloc] initWithPostsType:PostsTypeShare],
                                                                                          [[PostsViewController alloc] initWithPostsType:PostsTypeSynthesis],
                                                                                          [[PostsViewController alloc] initWithPostsType:PostsTypeCaree],
                                                                                          [[PostsViewController alloc] initWithPostsType:PostsTypeSiteManager]
                                                                                          ]];
        
        [self setContentViewController:newsSVC];
    }
    else if([itemId isEqualToString:@"software"]){
        SwipableViewController *softwaresSVC = [[SwipableViewController alloc] initWithTitle:title
                                                                                andSubTitles:subTitle
                                                                              andControllers:@[
                                                                                               [[SoftwareCatalogVC alloc] initWithTag:0],
                                                                                               [[SoftwareListVC alloc] initWithSoftwaresType:SoftwaresTypeRecommended],
                                                                                               [[SoftwareListVC alloc] initWithSoftwaresType:SoftwaresTypeNewest],
                                                                                               [[SoftwareListVC alloc] initWithSoftwaresType:SoftwaresTypeHottest],
                                                                                               [[SoftwareListVC alloc] initWithSoftwaresType:SoftwaresTypeCN]
                                                                                               ]];
        
        [self setContentViewController:softwaresSVC];
    }
    else if([itemId isEqualToString:@"blog"]){
        SwipableViewController *blogsSVC = [[SwipableViewController alloc] initWithTitle:title
                                                                            andSubTitles:subTitle
                                                                          andControllers:@[
                                                                                           [[BlogsViewController alloc] initWithBlogsType:BlogTypeLatest],
                                                                                           [[BlogsViewController alloc] initWithBlogsType:BlogTypeRecommended]
                                                                                           ]];
        
        [self setContentViewController:blogsSVC];
    }
    else if([itemId isEqualToString:@"setting"]){
        SettingsPage *settingPage = [SettingsPage new];
        [self setContentViewController:settingPage];
    }
    else if([itemId isEqualToString:@"weibo"]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Weibo" bundle:[NSBundle mainBundle]];
        WeiboTableViewController *weiboPage = [storyboard instantiateViewControllerWithIdentifier:@"WeiboTableViewController"];
        
        [self setContentViewController:weiboPage];
    }
    else if([itemId isEqualToString:@"video"]){
        VideoTableViewController *videoPage = [VideoTableViewController new];
        
        [self setContentViewController:videoPage];
    }
    else if([itemId isEqualToString:@"music"]){
        
    }
}


- (void)setContentViewController:(UIViewController *)viewController
{
    viewController.hidesBottomBarWhenPushed = YES;
    UINavigationController *nav = (UINavigationController *)((UITabBarController *)self.sideMenuViewController.contentViewController).selectedViewController;
    //UIViewController *vc = nav.viewControllers[0];
    //vc.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [nav pushViewController:viewController animated:NO];
    
    [self.sideMenuViewController hideMenuViewController];
}

#pragma mark - 点击登录

- (void)pushLoginPage
{
    if ([Config getOwnID] == 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        LoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self setContentViewController:loginVC];
    } else {
        return;
    }
}

- (void)reload
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}


@end
