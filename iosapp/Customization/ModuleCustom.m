//
//  ModuleCustom.h
//  iosapp
//
//  Created by bill li on 2016-01-27.
//  Copyright (c) 2016年 finalshares. All rights reserved.
//

#import "ModuleCustom.h"

/* tab item customization */
NSString * const kTabItemTitles[5] = {@"综合", @"动弹", @"", @"发现", @"我"};
NSString * const kTabItemImages[5] = {@"tabbar-news", @"tabbar-tweet", @"", @"tabbar-discover", @"tabbar-me"};

NSString * const kButtonTitles[6] = {@"文字", @"相册", @"拍照", @"语音", @"扫一扫", @"找人"};
NSString * const kButtonImages[6] = {@"tweetEditing", @"picture", @"shooting", @"sound", @"scan", @"search"};
int kButtonColors[6] = {0xe69961, 0x0dac6b, 0x24a0c4, 0xe96360, 0x61b644, 0xf1c50e};

/* side menu item customization */
int kSideMenuItemNum = 6;
NSString * const kSideMenuItemImages[6] = {@"sidemenu_QA", @"sidemenu-software", @"sidemenu_blog", @"sidemenu_setting", @"sidemenu-night", @"sidemenu-night"};
NSString * const kSideMenuItemTitles[6] = {@"技术问答", @"开源软件", @"博客区", @"设置", @"夜间模式", @"微博"};