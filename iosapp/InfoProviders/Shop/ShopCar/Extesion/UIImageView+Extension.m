//
//  UIImageView+Extension.m
//  Shopping
//
//  Created by beijingduanluo on 15/8/14.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "UIImageView+Extension.h"

@implementation UIImageView (Extension)
+(UIImageView *)addImgWithFrame:(CGRect)frame AndImage:(NSString *)imgName
{
    UIImageView *imgView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:imgName]];
    
    imgView.frame = frame;
    return imgView;
}
@end
