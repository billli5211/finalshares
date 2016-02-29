//
//  AppDelegate.m
//  iosapp
//
//  Created by chenhaoxiang on 14-10-13.
//  Copyright (c) 2014年 oschina. All rights reserved.
//

#import "AppDelegate.h"
#import "OSCThread.h"
#import "Config.h"
#import "UIView+Util.h"
#import "UIColor+Util.h"
#import "AFHTTPRequestOperationManager+Util.h"
#import "OSCAPI.h"
#import "OSCUser.h"

#import <AFOnoResponseSerializer.h>
#import <Ono.h>
#import <UMSocial.h>
#import <UMengSocial/UMSocialQQHandler.h>
#import <UMengSocial/UMSocialWechatHandler.h>
#import <UMengSocial/UMSocialSinaHandler.h>

#import "FSAPI.h"
#import "JsonUtils.h"
#import "FSCategory.h"
#import "SXNetworkTools.h"

@interface AppDelegate () <UIApplicationDelegate>

@end

@implementation AppDelegate

#define USE_STAGING_FEEDS (true)

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _inNightMode = [Config getMode];
    
    [NBSAppAgent startWithAppID:@"2142ec9589c2480f952feab9ed19a535"];
    
    
    [self loadCookies];
    
    /************ 控件外观设置 **************/
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    NSDictionary *navbarTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UITabBar appearance] setTintColor:[UIColor colorWithHex:0x15A230]];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x15A230]} forState:UIControlStateSelected];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor navigationbarColor]];
    [[UITabBar appearance] setBarTintColor:[UIColor titleBarColor]];
    
    [UISearchBar appearance].tintColor = [UIColor colorWithHex:0x15A230];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setCornerRadius:14.0];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setAlpha:0.6];
    
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor colorWithHex:0xDCDCDC];
    pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    
    [[UITextField appearance] setTintColor:[UIColor nameColor]];
    [[UITextView appearance]  setTintColor:[UIColor nameColor]];
    
    
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    
    [menuController setMenuVisible:YES animated:YES];
    [menuController setMenuItems:@[
                                   [[UIMenuItem alloc] initWithTitle:@"复制" action:NSSelectorFromString(@"copyText:")],
                                   [[UIMenuItem alloc] initWithTitle:@"删除" action:NSSelectorFromString(@"deleteObject:")]
                                   ]];
    
    /************ 检测通知 **************/
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType types = UIUserNotificationTypeSound | UIUserNotificationTypeBadge | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    
    /*if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 &&
        [[UIApplication sharedApplication] currentUserNotificationSettings].types != UIUserNotificationTypeNone) {
    }*/
    if ([Config getOwnID] != 0) {[OSCThread startPollingNotice];}
    
    
    /************ 友盟分享组件 **************/
    
    [UMSocialData setAppKey:@"54c9a412fd98c5779c000752"];
    [UMSocialWechatHandler setWXAppId:@"wxa8213dc827399101" appSecret:@"5c716417ce72ff69d8cf0c43572c9284" url:@"http://www.umeng.com/social"];
    [UMSocialQQHandler setQQWithAppId:@"100942993" appKey:@"8edd3cc7ca8dcc15082d6fe75969601b" url:@"http://www.umeng.com/social"];
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    
    /************ 第三方登录设置 *************/
    
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:@"3616966952"];
    
    
    //
    [self setupCustomConfig];
    
    return YES;
}

- (void)loadCookies
{
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey: @"sessionCookies"]];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (NSHTTPCookie *cookie in cookies){
        [cookieStorage setCookie: cookie];
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [UMSocialSnsService handleOpenURL:url]             ||
           [WXApi handleOpenURL:url delegate:_loginDelegate]  ||
           [TencentOAuth HandleOpenURL:url]                   ||
           [WeiboSDK handleOpenURL:url delegate:_loginDelegate];
    
//    return [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [UMSocialSnsService handleOpenURL:url]             ||
           [WXApi handleOpenURL:url delegate:_loginDelegate]  ||
           [TencentOAuth HandleOpenURL:url]                   ||
           [WeiboSDK handleOpenURL:url delegate:_loginDelegate];
    
//    return [UMSocialSnsService handleOpenURL:url];
}


# pragma BackgroundFetch


- (void) setupCustomConfig{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [paths objectAtIndex:0];
    NSString *menuPath = [docDirectory stringByAppendingPathComponent:@"menuData"];
    NSString *tabPath = [docDirectory stringByAppendingPathComponent:@"tabData"];
    NSString *actionPath = [docDirectory stringByAppendingPathComponent:@"actionData"];
    
    __block NSArray * menuJSON = NULL;
    __block NSArray * tabJSON = NULL;
    __block NSArray * actionJSON = NULL;
    
    if USE_STAGING_FEEDS {
        menuJSON = [JsonUtils getConfig:@"customizeConfig" with:@"menuItems"];
        [menuJSON writeToFile:menuPath atomically: YES];
        _menuItems = [[NSMutableArray alloc] initWithArray: menuJSON];
        
        tabJSON = [JsonUtils getConfig:@"customizeConfig" with:@"tabItems"];
        [tabJSON writeToFile:tabPath atomically: YES];
        _tabItems = [[NSMutableArray alloc] initWithArray: tabJSON];
        
        actionJSON = [JsonUtils getConfig:@"customizeConfig" with:@"actionItems"];
        [actionJSON writeToFile:actionPath atomically: YES];
        _actionItems = [[NSMutableArray alloc] initWithArray: actionJSON];
        
        [self appendMoreMenus];
        
    }else{
        
        NSString *custUrl = [NSString stringWithFormat:FSAPI_CUSTOMIZE_CONFIG];
        NSURL *url = [NSURL URLWithString:custUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            menuJSON = responseObject[@"menuItems"];
            if (![menuJSON writeToFile:menuPath atomically:YES]) {
                NSLog(@"Couldn't save menu config");
            }
            if ([[NSFileManager defaultManager] fileExistsAtPath:menuPath]) {
                _menuItems = [[NSMutableArray alloc] initWithContentsOfFile:menuPath];

            }
            
            tabJSON = responseObject[@"tabItems"];
            if (![tabJSON writeToFile:tabPath atomically:YES]) {
                NSLog(@"Couldn't save tab config");
            }
            if ([[NSFileManager defaultManager] fileExistsAtPath:tabPath]) {
                _tabItems = [[NSMutableArray alloc] initWithContentsOfFile:tabPath];
                
            }
            
            actionJSON = responseObject[@"actionItems"];
            if (![actionJSON writeToFile:actionPath atomically:YES]) {
                NSLog(@"Couldn't save action config");
            }
            if ([[NSFileManager defaultManager] fileExistsAtPath:actionPath]) {
                _actionItems = [[NSMutableArray alloc] initWithContentsOfFile:actionPath];
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:menuPath]) {
                _menuItems = [[NSMutableArray alloc] initWithContentsOfFile:menuPath];
            }
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:tabPath]) {
                _tabItems = [[NSMutableArray alloc] initWithContentsOfFile:tabPath];
            }
            
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:actionPath]) {
                _actionItems = [[NSMutableArray alloc] initWithContentsOfFile:actionPath];
            }
            
            NSLog(@"Error fetching customized config");
        }];
        [operation start];
    }
    
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:menuPath]) {
        _menuItems = [[NSMutableArray alloc] initWithContentsOfFile:menuPath];
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:tabPath]) {
        _tabItems = [[NSMutableArray alloc] initWithContentsOfFile:tabPath];
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:actionPath]) {
        _actionItems = [[NSMutableArray alloc] initWithContentsOfFile:actionPath];
    }
}


#pragma mark - load more menus
- (void)appendMoreMenus
{
    [[[SXNetworkTools sharedNetworkTools]GET:FSAPI_CATEGORY parameters:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
        
        NSDictionary *dict = responseObject[@"categories"];
        NSMutableArray *newMenuItems = [[NSMutableArray alloc]init];
        
        for(id key in dict)
        {
            NSDictionary *data=[dict objectForKey:key];
            //NSLog(@"key: %@,value: %@",key, data);
            
            FSCategory *category = [FSCategory mj_objectWithKeyValues:data];
            NSLog(@"id: %d,name: %@",category.category_id, category.category_name);
            
            NSString* cid = [[NSString alloc] initWithFormat:@"%d",category.category_id];
            NSString* cname = category.category_name;
            NSDictionary *test_dictionary = [NSDictionary dictionaryWithObjectsAndKeys:cid , @"id",
                                             cname ,@"title", @"sidemenu_setting", @"image",
                                             nil];
            
            [newMenuItems addObject:test_dictionary];
            
            
        }
        
        [newMenuItems addObjectsFromArray:self.menuItems];
        self.menuItems = newMenuItems;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"menuUpdate" object:nil];

        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }] resume];
    
   }

@end
