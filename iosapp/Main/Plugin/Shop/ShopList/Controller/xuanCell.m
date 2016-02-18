//
//  xuanCell.m
//  GiftSay
//
//  Created by lanou on 16/1/5.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "xuanCell.h"
#define kwidth [UIScreen mainScreen].bounds.size.width
#define KHeight [UIScreen mainScreen].bounds.size.height
@implementation xuanCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kwidth/4, 20)];
       
      
        [self addSubview:_label];
    }
    return self;
}
- (void)setString:(NSString *)String{
    if (_String != String) {
        _String = String;
        _label.text =String;
        _label.textAlignment = NSTextAlignmentCenter;
        
        _label.textColor = [UIColor orangeColor];
        _label.font = [UIFont systemFontOfSize:14];
    
    }

}
@end
