//
//  iosapp
//
//  Created by bill li on 2016-01-28.
//  Copyright (c) 2016年 finalshares. All rights reserved.
//

#import "ViewModelClass.h"
#import "WeiboModel.h"

@interface WeiboViewModel : ViewModelClass
//获取围脖列表
-(void) fetchPublicWeiBo;

//跳转到微博详情页
-(void) weiboDetailWithPublicModel: (WeiboModel *) weiboModel WithViewController: (UIViewController *)superController;
@end
