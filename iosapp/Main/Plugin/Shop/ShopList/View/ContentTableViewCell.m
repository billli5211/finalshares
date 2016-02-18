//
//  ContentTableViewCell.m
//  GiftSay
//
//  Created by lanou on 15/12/18.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "ContentTableViewCell.h"
#import "imagemodel.h"
#import "UIImageView+AFNetworking.h"
#define kwidth [UIScreen mainScreen].bounds.size.width
#define KHeight [UIScreen mainScreen].bounds.size.height
@implementation ContentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.picture=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, kwidth-20, 200)];
       
        _picture.layer.cornerRadius=10;
        _picture.layer.masksToBounds=YES;
        _label=[[UILabel alloc]initWithFrame:CGRectMake(10, 200-30, kwidth,30)];
        _label.textColor=[UIColor whiteColor];
        _label.font=[UIFont systemFontOfSize:14];
        
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 160, kwidth, 40)];
        view.backgroundColor=[UIColor grayColor];
        view.alpha=0.5;
        //[view addSubview:_label];
        [_picture addSubview:view];
        [_picture addSubview:_label];
        
        [self addSubview:_picture];
    }
    
    
    
    return self;
    
    
}

- (void)setIamge:(imagemodel *)iamge{
    if (_iamge!=iamge) {
        _iamge=iamge;
        _label.text=iamge.title;
        
        [_picture setImage:[UIImage imageNamed:@"占位.png"]];
        [_picture setImageWithURL:[NSURL URLWithString:iamge.cover_image_url]];
    
    }
}


@end
