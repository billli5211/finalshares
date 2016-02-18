//
//  iosapp
//
//  Created by bill li on 2016-01-28.
//  Copyright (c) 2016年 finalshares. All rights reserved.
//

#import "VideoCell.h"
#import "VideoModel.h"
#import "UIImageView+WebCache.h"

@interface VideoCell ()
@property(nonatomic,weak)UIView * divider;
@end

@implementation VideoCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID=@"ID";
    VideoCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[VideoCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

-(void)setModel:(VideoModel *)model
{
    _model=model;
    self.textLabel.text=model.name;
    NSString *length=[NSString stringWithFormat:@"时长%d分钟",model.length];
    self.detailTextLabel.text=length;
    
    // video.image == resources/images/minion_01.png
    NSString *imageUrl = [NSString stringWithFormat:@"http://192.168.1.53:8080/MJServer/%@", model.image];
    
    //这里使用了第三方框架
    [self.imageView  setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"logo"]];
    
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //调整frame
    //图片的frame
    CGFloat imageX=10;
    CGFloat imageY=10;
    CGFloat imageH=self.frame.size.height-2*imageY;
    CGFloat imageW=imageH*200/112;
    self.imageView.frame=CGRectMake(imageX, imageY, imageW, imageH);
    
    //标题的frame
    CGRect textF=self.textLabel.frame;
    textF.origin.x=imageW+2*imageX;
    self.textLabel.frame=textF;
    
    //小标题的frame
    CGRect detailTextF=self.detailTextLabel.frame;
    detailTextF.origin.x=textF.origin.x;
    self.detailTextLabel.frame=detailTextF;
    
    //设置下划线的frame
    CGFloat dividerH=1.0;
    CGFloat dividerW=self.frame.size.width;
    CGFloat dividerY=self.frame.size.height-1;
    self.divider.frame=CGRectMake(0, dividerY, dividerW, dividerH);
}

@end
