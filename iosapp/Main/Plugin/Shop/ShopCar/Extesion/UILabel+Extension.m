//
//  UILabel+Extension.m
//  Shopping
//
//  Created by beijingduanluo on 15/8/14.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)
+(UILabel *)addLabelWithFrame:(CGRect)frame AndText:(NSString *)text AndFont:(CGFloat)font AndAlpha:(CGFloat)alpha AndColor:(UIColor *)color
{
    UILabel *label =[[UILabel alloc]initWithFrame:frame];
    label.text = text;
    label.alpha = alpha;
    label.font =[UIFont systemFontOfSize:font];
    label.textColor = color;
    label.textAlignment =NSTextAlignmentLeft;
    //label.textAlignment =NSTextAlignmentCenter;
    return label;
}
@end
