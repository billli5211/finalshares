//
//  UISegmentedControl+Extension.m
//  易林
//
//  Created by beijingduanluo on 15/10/17.
//  Copyright (c) 2015年 beijingduanluo. All rights reserved.
//

#import "UISegmentedControl+Extension.h"

@implementation UISegmentedControl (Extension)
+(UISegmentedControl *)addSegMentControlWithArray:(NSArray *)array WithTarget:(id)target action:(SEL)action
{
    UISegmentedControl *segMentCon=[[UISegmentedControl alloc]initWithItems:array];
    [segMentCon addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    segMentCon.tintColor=[UIColor whiteColor];
    segMentCon.selectedSegmentIndex = 0;
    segMentCon.layer.cornerRadius = 5;
    segMentCon.layer.masksToBounds = YES;
    segMentCon.frame =CGRectMake(0, 0, 100*Width, 28*Height);
    return segMentCon;
}
@end
