//
//  iosapp
//
//  Created by bill li on 2016-01-28.
//  Copyright (c) 2016年 finalshares. All rights reserved.
//

#import "WeiboTableViewController.h"
#import "WeiboViewModel.h"
#import "WeiboCell.h"

#import "Utils.h"
#import <MBProgressHUD.h>

@interface WeiboTableViewController ()

@property (strong, nonatomic) NSArray *publicModelArray;
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation WeiboTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WeiboViewModel *publicViewModel = [[WeiboViewModel alloc] init];
    [publicViewModel setBlockWithReturnBlock:^(id returnValue) {
        
        [_hud hide:YES];
        _publicModelArray = returnValue;
        [self.tableView reloadData];
        DDLog(@"%@",_publicModelArray);
        
    } WithErrorBlock:^(id errorCode) {
        
        //[SVProgressHUD dismiss];
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = [NSString stringWithFormat:@"错误：%@", errorCode];
        [_hud hide:YES afterDelay:1];
        
    } WithFailureBlock:^{
        
        //[SVProgressHUD dismiss];
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = [NSString stringWithFormat:@"失败"];
        [_hud hide:YES afterDelay:1];
        
    }];
    
    [publicViewModel fetchPublicWeiBo];
    
    //[SVProgressHUD showWithStatus:@"正在获取用户信息……" maskType:SVProgressHUDMaskTypeBlack];
    _hud = [Utils createHUD];
    _hud.labelText = @"正在获取用户信息……";
    _hud.userInteractionEnabled = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _publicModelArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //[self.tableView registerClass:[WeiboCell class] forCellReuseIdentifier:@"WeiboCell"];
    
    WeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeiboCell" forIndexPath:indexPath];
    
    [cell setValueWithDic:_publicModelArray[indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeiboViewModel *publicViewModel = [[WeiboViewModel alloc] init];
    [publicViewModel weiboDetailWithPublicModel:_publicModelArray[indexPath.row] WithViewController:self];
}

@end
