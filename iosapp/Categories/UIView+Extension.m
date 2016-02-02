//
//  UIView+Util.m
//  iosapp
//
//  Created by chenhaoxiang on 14-10-17.
//  Copyright (c) 2014年 oschina. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)


-(void)setX:(CGFloat)x
{
  CGRect frame=self.frame;
   frame.origin.x=x;
    self.frame=frame;
}
-(CGFloat)x
 {
     return self.frame.origin.x;
    }

 -(void)setY:(CGFloat)y
 {
       CGRect frame=self.frame;
        frame.origin.y=y;
       self.frame=frame;
    }

 -(CGFloat)y
 {
     return self.frame.origin.y;
     }

-(void)setWidth:(CGFloat)width
 {
        CGRect frame=self.frame;
         frame.size.width=width;
         self.frame=frame;
     }
 -(CGFloat)width
 {
         return self.frame.size.width;
    }

-(void)setHeight:(CGFloat)height
 {
         CGRect frame=self.frame;
        frame.size.height=height;
        self.frame=frame;
    }
 -(CGFloat)height
 {
        return self.frame.size.height;
     }

@end
