//
//  OSCTabBarController.m
//  iosapp
//
//  Created by chenhaoxiang on 12/15/14.
//  Copyright (c) 2014 oschina. All rights reserved.
//

#import "OSCTabBarController.h"
#import "SwipableViewController.h"
#import "TweetsViewController.h"
#import "PostsViewController.h"
#import "NewsViewController.h"
#import "BlogsViewController.h"
#import "LoginViewController.h"
#import "HomepageViewController.h"
#import "DiscoverViewcontroller.h"
#import "Config.h"
#import "Utils.h"
#import "OptionButton.h"
#import "TweetEditingVC.h"
#import "UIView+Util.h"
#import "PersonSearchViewController.h"
#import "ScanViewController.h"
#import "ShakingViewController.h"
#import "SearchViewController.h"
#import "VoiceTweetEditingVC.h"

#import "UIBarButtonItem+Badge.h"

#import <RESideMenu/RESideMenu.h>

#import "AppDelegate.h"
#import "SXTableViewController.h"
#import "FSThreadViewController.h"

@interface OSCTabBarController () <UITabBarControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    NewsViewController *newsViewCtl;
    NewsViewController *hotNewsViewCtl;
    BlogsViewController *blogViewCtl;
    BlogsViewController *recommendBlogViewCtl;
    
    TweetsViewController *newTweetViewCtl;
    TweetsViewController *hotTweetViewCtl;
    TweetsViewController *myTweetViewCtl;
    
    NSMutableArray *sxControllers;
    
    NSMutableArray *fsControllers;
    
}

@property (nonatomic, strong) UIView *dimView;
@property (nonatomic, strong) UIImageView *blurView;
@property (nonatomic, assign) BOOL isPressed;
@property (nonatomic, strong) NSMutableArray *optionButtons;
@property (nonatomic, strong) UIDynamicAnimator *animator;

@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGGlyph length;

@end

@implementation OSCTabBarController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dawnAndNightMode:) name:@"dawnAndNight" object:nil];
}

- (void)dawnAndNightMode:(NSNotification *)center
{
    newsViewCtl.view.backgroundColor = [UIColor themeColor];
    hotNewsViewCtl.view.backgroundColor = [UIColor themeColor];
    blogViewCtl.view.backgroundColor = [UIColor themeColor];
    recommendBlogViewCtl.view.backgroundColor = [UIColor themeColor];
    
    newTweetViewCtl.view.backgroundColor = [UIColor themeColor];
    hotTweetViewCtl.view.backgroundColor = [UIColor themeColor];
    myTweetViewCtl.view.backgroundColor = [UIColor themeColor];

    [[UINavigationBar appearance] setBarTintColor:[UIColor navigationbarColor]];
    [[UITabBar appearance] setBarTintColor:[UIColor titleBarColor]];
    
    // suppose the No 3/4/5 tab items are : publish, discovery, me. The first 2 items are flexible
    [self.viewControllers enumerateObjectsUsingBlock:^(UINavigationController *nav, NSUInteger idx, BOOL *stop) {
        if (idx == 0 || idx == 1) {
            SwipableViewController *vc = nav.viewControllers[0];
            [vc.titleBar setTitleButtonsColor];
            [vc.viewPager.controllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                UITableViewController *table = obj;
                [table.navigationController.navigationBar setBarTintColor:[UIColor navigationbarColor]];
                [table.tabBarController.tabBar setBarTintColor:[UIColor titleBarColor]];
                [table.tableView reloadData];
            }];

        } else if (idx == 3) {
            DiscoverViewController *dvc = nav.viewControllers[0];
            [dvc.navigationController.navigationBar setBarTintColor:[UIColor navigationbarColor]];
            [dvc.tabBarController.tabBar setBarTintColor:[UIColor titleBarColor]];
            [dvc dawnAndNightMode];
        } else if (idx == 4) {
            HomepageViewController *homepageVC = nav.viewControllers[0];
            [homepageVC.navigationController.navigationBar setBarTintColor:[UIColor navigationbarColor]];
            [homepageVC.tabBarController.tabBar setBarTintColor:[UIColor titleBarColor]];
            [homepageVC dawnAndNightMode];
        }
    }];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"dawnAndNight" object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    [self setupTabItems];
    
    [self setupActionTab];
}

-(void)setupTabItems
{
    // customize tab bar according to remote server or local config.
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableArray *tabItems = appDelegate.tabItems;
    
    NSMutableArray *enableFlag = [NSMutableArray arrayWithCapacity:tabItems.count];
    
    // to be user friendly, should be no more than 5 tab items.
    
    NSMutableArray *title = [NSMutableArray arrayWithCapacity:5];
    NSString *itemId[5];
    NSMutableArray *image = [NSMutableArray arrayWithCapacity:5];
    NSArray *subTitle[5];
    
    for (int index = 0, j = 0; index < tabItems.count && j < 5;index++) {
        enableFlag[index] = [[tabItems objectAtIndex:index] objectForKey:@"enable"];
        if (![enableFlag[index] isEqualToString:@"true"]) {
            continue;
        }
        
        [title addObject:[[tabItems objectAtIndex:index] objectForKey:@"title"]];
        itemId[j] = [[tabItems objectAtIndex:index] objectForKey:@"id"];
        image[j] = [[tabItems objectAtIndex:index] objectForKey:@"image"];
        subTitle[j] = [[tabItems objectAtIndex:index] objectForKey:@"subTitle"];
        j++;
    }
    
    SwipableViewController *newsSVC = NULL;
    SwipableViewController *tweetsSVC = NULL;
    UINavigationController *discoverNav = NULL;
    UINavigationController *homepageNav = NULL;
    
    SwipableViewController *sxNewsSVC = NULL;
    SwipableViewController *fsForumSVC = NULL;
    
    NSMutableArray *vcArray = [[NSMutableArray alloc] init];
    
    for (int index = 0; index < 5;index++) {
        
        if ([itemId[index] isEqualToString:@"news"]) {
            NSArray * arrayLists = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"NewsURLs.plist" ofType:nil]];
            sxControllers = [[NSMutableArray alloc] init];
            for (int i=0 ; i< arrayLists.count ;i++){
                SXTableViewController *vc1 = [[UIStoryboard storyboardWithName:@"News" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
                vc1.title = arrayLists[i][@"title"];
                vc1.urlString = arrayLists[i][@"urlString"];
                
                [sxControllers addObject: vc1];
            }
            
            
            sxNewsSVC = [[SwipableViewController alloc] initWithTitle:title[index]
                                                         andSubTitles:subTitle[index]
                                                       andControllers:sxControllers];
            
            [vcArray addObject:[self addNavigationItemForViewController:sxNewsSVC withSearch:false]];
            
        }
        
        else if ([itemId[index] isEqualToString:@"fs"]){

            fsControllers = [[NSMutableArray alloc] init];

            [fsControllers addObject: [[FSThreadViewController alloc] initWithFSType:FSTypeDate]];
            [fsControllers addObject: [[FSThreadViewController alloc] initWithFSType:FSTypeHot]];
            [fsControllers addObject: [[FSThreadViewController alloc] initWithFSType:FSTypeRecommend]];
            
            
            fsForumSVC = [[SwipableViewController alloc] initWithTitle:title[index]
                                                         andSubTitles:subTitle[index]
                                                       andControllers:fsControllers];
            
            [vcArray addObject:[self addNavigationItemForViewController:fsForumSVC withSearch:false]];
        }
        
        else if ([itemId[index] isEqualToString:@"synthesization"]) {
            
            newsViewCtl = [[NewsViewController alloc]  initWithNewsListType:NewsListTypeNews];
            hotNewsViewCtl = [[NewsViewController alloc]  initWithNewsListType:NewsListTypeAllTypeWeekHottest];
            blogViewCtl = [[BlogsViewController alloc] initWithBlogsType:BlogTypeLatest];
            recommendBlogViewCtl = [[BlogsViewController alloc] initWithBlogsType:BlogTypeRecommended];
            
            newsViewCtl.needCache = YES;
            hotNewsViewCtl.needCache = YES;
            blogViewCtl.needCache = YES;
            recommendBlogViewCtl.needCache = YES;
            
            
            newsSVC = [[SwipableViewController alloc] initWithTitle:title[index]
                                                       andSubTitles:subTitle[index]
                                                     andControllers:@[newsViewCtl, hotNewsViewCtl, blogViewCtl,recommendBlogViewCtl]
                                                        underTabbar:YES];
            
            [vcArray addObject:[self addNavigationItemForViewController:newsSVC withSearch:true]];
        }
        else if([itemId[index] isEqualToString:@"tweet"]) {
            
            newTweetViewCtl = [[TweetsViewController alloc] initWithTweetsType:TweetsTypeAllTweets];
            hotTweetViewCtl = [[TweetsViewController alloc] initWithTweetsType:TweetsTypeHotestTweets];
            myTweetViewCtl = [[TweetsViewController alloc] initWithTweetsType:TweetsTypeOwnTweets];
            
            newTweetViewCtl.needCache = YES;
            hotTweetViewCtl.needCache = YES;
            myTweetViewCtl.needCache = YES;
            
            
            tweetsSVC = [[SwipableViewController alloc] initWithTitle:title[index]
                                                         andSubTitles:subTitle[index]
                                                       andControllers:@[newTweetViewCtl, hotTweetViewCtl, myTweetViewCtl]
                                                          underTabbar:YES];
            
            [vcArray addObject:[self addNavigationItemForViewController:tweetsSVC withSearch:true]];
            
        }
        else if([itemId[index] isEqualToString:@"action"]) {
            [vcArray addObject:[UIViewController new]];
        }
        else if([itemId[index] isEqualToString:@"discover"]) {
            UIStoryboard *discoverSB = [UIStoryboard storyboardWithName:@"Discover" bundle:nil];
            discoverNav = [discoverSB instantiateViewControllerWithIdentifier:@"Nav"];
            [vcArray addObject:discoverNav];
        }
        else if([itemId[index] isEqualToString:@"me"]) {
            UIStoryboard *homepageSB = [UIStoryboard storyboardWithName:@"Homepage" bundle:nil];
            homepageNav = [homepageSB instantiateViewControllerWithIdentifier:@"Nav"];
            [vcArray addObject:homepageNav];
        }
        
    }
    
    
    self.tabBar.translucent = NO;
    self.viewControllers = vcArray;
    
    
    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem *item, NSUInteger idx, BOOL *stop) {
        [item setTitle:[title objectAtIndex:idx]];
        
        if(idx != 2)
        {
            [item setImage:[UIImage imageNamed:image[idx]]];
            [item setSelectedImage:[UIImage imageNamed:[image[idx] stringByAppendingString:@"-selected"]]];
        }
        
    }];
}

-(void)setupActionTab
{
    
    [self.tabBar.items[2] setEnabled:NO];
    
    [self addCenterButtonWithImage:[UIImage imageNamed:@"tabbar-more"]];
    
    [self.tabBar addObserver:self
                  forKeyPath:@"selectedItem"
                     options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                     context:nil];
    
    // 功能键相关
    _optionButtons = [NSMutableArray new];
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    _screenWidth  = [UIScreen mainScreen].bounds.size.width;
    _length = 60;        // 圆形按钮的直径
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    //
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableArray *actionItems = appDelegate.actionItems;
    
    for (int i = 0; i < 6; i++) {

        NSString *temp = [[actionItems objectAtIndex:i] objectForKey:@"color"];
        
        unsigned long color = strtoul([temp UTF8String],0,16);
        
        OptionButton *optionButton = [[OptionButton alloc] initWithTitle:[[actionItems objectAtIndex:i] objectForKey:@"title"]
                                                                   image:[UIImage imageNamed:[[actionItems objectAtIndex:i] objectForKey:@"image"]]
                                                                andColor:[UIColor colorWithHex:color]];
        
        optionButton.frame = CGRectMake((_screenWidth/6 * (i%3*2+1) - (_length+16)/2),
                                        _screenHeight + 150 + i/3*100,
                                        _length + 16,
                                        _length + [UIFont systemFontOfSize:14].lineHeight + 24);
        [optionButton.button setCornerRadius:_length/2];
        
        optionButton.tag = i;
        optionButton.userInteractionEnabled = YES;
        [optionButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapOptionButton:)]];
        
        [self.view addSubview:optionButton];
        [_optionButtons addObject:optionButton];
    }

}

- (void)dealloc
{
    [self.tabBar removeObserver:self forKeyPath:@"selectedItem"];
}

-(void)addCenterButtonWithImage:(UIImage *)buttonImage
{
    _centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGPoint origin = [self.view convertPoint:self.tabBar.center toView:self.tabBar];
    CGSize buttonSize = CGSizeMake(self.tabBar.frame.size.width / 5 - 6, self.tabBar.frame.size.height - 4);
    
    _centerButton.frame = CGRectMake(origin.x - buttonSize.height/2, origin.y - buttonSize.height/2, buttonSize.height, buttonSize.height);
    
    [_centerButton setCornerRadius:buttonSize.height/2];
    [_centerButton setBackgroundColor:[UIColor colorWithHex:0x24a83d]];
    [_centerButton setImage:buttonImage forState:UIControlStateNormal];
    [_centerButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tabBar addSubview:_centerButton];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"selectedItem"]) {
        if(self.isPressed) {[self buttonPressed];}
    }
}


- (void)buttonPressed
{
    [self changeTheButtonStateAnimatedToOpen:_isPressed];
    
    _isPressed = !_isPressed;
}


- (void)changeTheButtonStateAnimatedToOpen:(BOOL)isPressed
{
    if (isPressed) {
        [self removeBlurView];
        
        [_animator removeAllBehaviors];
        for (int i = 0; i < 6; i++) {
            UIButton *button = _optionButtons[i];
            
            UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:button
                                                                         attachedToAnchor:CGPointMake(_screenWidth/6 * (i%3*2+1),
                                                                                                      _screenHeight + 200 + i/3*100)];
            attachment.damping = 0.65;
            attachment.frequency = 4;
            attachment.length = 1;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC * (6 - i)), dispatch_get_main_queue(), ^{
                [_animator addBehavior:attachment];
            });
        }
    } else {
        [self addBlurView];
        
        [_animator removeAllBehaviors];
        for (int i = 0; i < 6; i++) {
            UIButton *button = _optionButtons[i];
            [self.view bringSubviewToFront:button];
            
            UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:button
                                                                         attachedToAnchor:CGPointMake(_screenWidth/6 * (i%3*2+1),
                                                                                                      _screenHeight - 200 + i/3*100)];
            attachment.damping = 0.65;
            attachment.frequency = 4;
            attachment.length = 1;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.02 * NSEC_PER_SEC * (i + 1)), dispatch_get_main_queue(), ^{
                [_animator addBehavior:attachment];
            });
        }
    }
}

- (void)addBlurView
{
    _centerButton.enabled = NO;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGRect cropRect = CGRectMake(0, screenSize.height - 270, screenSize.width, screenSize.height);
    
    UIImage *originalImage = [self.view updateBlur];
    UIImage *croppedBlurImage = [originalImage cropToRect:cropRect];
    
    _blurView = [[UIImageView alloc] initWithImage:croppedBlurImage];
    _blurView.frame = cropRect;
    _blurView.userInteractionEnabled = YES;
    [self.view addSubview:_blurView];
    
    _dimView = [[UIView alloc] initWithFrame:self.view.bounds];
    _dimView.backgroundColor = [UIColor blackColor];
    _dimView.alpha = 0.4;
    [self.view insertSubview:_dimView belowSubview:self.tabBar];
    
    [_blurView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonPressed)]];
    [_dimView  addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonPressed)]];
    
    [UIView animateWithDuration:0.25f
                     animations:^{}
                     completion:^(BOOL finished) {
                         if (finished) {_centerButton.enabled = YES;}
                     }];
}

- (void)removeBlurView
{
    _centerButton.enabled = NO;
    
    self.view.alpha = 1;
    [UIView animateWithDuration:0.25f
                     animations:^{}
                     completion:^(BOOL finished) {
                         if(finished) {
                             [_dimView removeFromSuperview];
                             _dimView = nil;
                             
                             [self.blurView removeFromSuperview];
                             self.blurView = nil;
                             _centerButton.enabled = YES;
                         }
                     }];
}


#pragma mark - 处理点击事件

- (void)onTapOptionButton:(UIGestureRecognizer *)recognizer
{
    switch (recognizer.view.tag) {
        case 0: {
            TweetEditingVC *tweetEditingVC = [TweetEditingVC new];
            UINavigationController *tweetEditingNav = [[UINavigationController alloc] initWithRootViewController:tweetEditingVC];
            [self.selectedViewController presentViewController:tweetEditingNav animated:YES completion:nil];
            break;
        }
        case 1: {
            UIImagePickerController *imagePickerController = [UIImagePickerController new];
            imagePickerController.delegate = self;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePickerController.allowsEditing = NO;
            imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
            
            [self presentViewController:imagePickerController animated:YES completion:nil];
            
            break;
        }
        case 2: {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:@"Device has no camera"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles: nil];
                
                [alertView show];
            } else {
                UIImagePickerController *imagePickerController = [UIImagePickerController new];
                imagePickerController.delegate = self;
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePickerController.allowsEditing = NO;
                imagePickerController.showsCameraControls = YES;
                imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
                imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
                
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }
            break;
        }
        case 3: {
            /*
            ShakingViewController *shakingVC = [ShakingViewController new];
            UINavigationController *shakingNav = [[UINavigationController alloc] initWithRootViewController:shakingVC];
            [self.selectedViewController presentViewController:shakingNav animated:NO completion:nil];
             */
            
            VoiceTweetEditingVC *voiceTweetVC = [VoiceTweetEditingVC new];
            UINavigationController *voiceTweetNav = [[UINavigationController alloc] initWithRootViewController:voiceTweetVC];
            [self.selectedViewController presentViewController:voiceTweetNav animated:NO completion:nil];
            
            break;
        }
        case 4: {
            ScanViewController *scanVC = [ScanViewController new];
            UINavigationController *scanNav = [[UINavigationController alloc] initWithRootViewController:scanVC];
            [self.selectedViewController presentViewController:scanNav animated:NO completion:nil];
            break;
        }
        case 5: {
            PersonSearchViewController *personSearchVC = [PersonSearchViewController new];
            UINavigationController *personSearchNav = [[UINavigationController alloc] initWithRootViewController:personSearchVC];
            [self.selectedViewController presentViewController:personSearchNav animated:YES completion:nil];
            break;
        }
        default: break;
    }
    
    [self buttonPressed];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{    
    //如果是拍照的照片，则需要手动保存到本地，系统不会自动保存拍照成功后的照片
    //UIImageWriteToSavedPhotosAlbum(edit, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    [picker dismissViewControllerAnimated:NO completion:^{
        TweetEditingVC *tweetEditingVC = [[TweetEditingVC alloc] initWithImage:info[UIImagePickerControllerOriginalImage]];
        UINavigationController *tweetEditingNav = [[UINavigationController alloc] initWithRootViewController:tweetEditingVC];
        [self.selectedViewController presentViewController:tweetEditingNav animated:NO completion:nil];
    }];
}


#pragma mark -

- (UINavigationController *)addNavigationItemForViewController:(UIViewController *)viewController withSearch: (BOOL)enableSeach
{
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    viewController.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigationbar-sidebar"]
                                                                                        style:UIBarButtonItemStylePlain
                                                                                       target:self action:@selector(onClickMenuButton)];
    if(enableSeach)
    {
        viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                                                         target:self
                                                                                                         action:@selector(pushSearchViewController)];
    }
    
    
    
    return navigationController;
}

- (void)onClickMenuButton
{
    [self.sideMenuViewController presentLeftMenuViewController];
}


#pragma mark - UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if (self.selectedIndex <= 1 && self.selectedIndex == [tabBar.items indexOfObject:item]) {
        SwipableViewController *swipeableVC = (SwipableViewController *)((UINavigationController *)self.selectedViewController).viewControllers[0];
        OSCObjsViewController *objsViewController = (OSCObjsViewController *)swipeableVC.viewPager.childViewControllers[swipeableVC.titleBar.currentIndex];
        
        [UIView animateWithDuration:0.1 animations:^{
            [objsViewController.tableView setContentOffset:CGPointMake(0, -objsViewController.refreshControl.frame.size.height)];
        } completion:^(BOOL finished) {
            [objsViewController.tableView.mj_header beginRefreshing];
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [objsViewController refresh];
        });
    }
}

#pragma mark - 处理左右navigationItem点击事件

- (void)pushSearchViewController
{
    [(UINavigationController *)self.selectedViewController pushViewController:[SearchViewController new] animated:YES];
}




@end
