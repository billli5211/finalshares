//
//  PostsViewController.m
//  iosapp
//
//  Created by chenhaoxiang on 10/27/14.
//  Copyright (c) 2014 oschina. All rights reserved.
//

#import "FSThreadViewController.h"
#import "FSThreadCell.h"
#import "FSThread.h"
#import "DetailsViewController.h"
#import "UIImageView+Util.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "FSAPI.h"
#import "FSDetailController.h"

static NSString *kPostCellID = @"FSThreadCell";


@implementation FSThreadViewController

- (instancetype)initWithFSType:(FSType)type
{
    self = [super init];
    
    if (self) {
        self.generateURL = ^NSString * (NSUInteger page) {
            return FSAPI_PATH;// set fixed value by now
        };
        
        self.objClass = [FSThread class];
    }
    
    return self;
}

// override parent
- (NSArray *)parseJson:(id)responseObject
{
    //NSString *key = [responseObject.keyEnumerator nextObject];
    //NSArray *temArray = responseObject[key];
    
    NSArray *temArray = responseObject[@"threaddb"];
    
    NSArray *arrayM = [FSThread objectArrayWithKeyValuesArray:temArray];
    
    return arrayM;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[FSThreadCell class] forCellReuseIdentifier:kPostCellID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}





#pragma mark -

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSThreadCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kPostCellID forIndexPath:indexPath];
    FSThread *post = self.objects[indexPath.row];
    /*
    [cell.portrait loadPortrait:post.portraitURL];
    [cell.titleLabel setText:post.title];
    [cell.bodyLabel setText:post.body];
    [cell.authorLabel setText:post.author];
    [cell.timeLabel setText:[post.pubDate timeAgoSinceNow]];
    [cell.commentAndView setText:[NSString stringWithFormat:@"%d回 / %d阅", post.replyCount, post.viewCount]];
     */
    
    //[cell.portrait loadPortrait:post.portraitURL];
    [cell.titleLabel setText:post.subject];
    [cell.bodyLabel setText:post.subject];
    [cell.authorLabel setText:@"bill"];
    
    //NSString *timeSp = [NSString stringWithFormat:@"%d", post.created_time];
    //[cell.timeLabel setText:timeSp];
    
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyyMMddHHMMss"];
    NSDate *date = [formatter dateFromString:@"1283376197"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:post.created_time];
    NSLog(@"date1:%@",date);
    [cell.timeLabel setText:[confromTimesp timeAgoSinceNow]];
    
    
    [cell.commentAndView setText:[NSString stringWithFormat:@"%d回 / %d阅", post.replies, post.hits]];

    
    cell.titleLabel.textColor = [UIColor titleColor];
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor selectCellSColor];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSThread *post = self.objects[indexPath.row];
    
    self.label.font = [UIFont boldSystemFontOfSize:15];
    self.label.text = post.subject;
    CGFloat height = [self.label sizeThatFits:CGSizeMake(tableView.frame.size.width - 62, MAXFLOAT)].height;
    
    self.label.text = post.subject;// bill not body by now
    self.label.font = [UIFont systemFontOfSize:13];
    height += [self.label sizeThatFits:CGSizeMake(tableView.frame.size.width - 62, MAXFLOAT)].height;
    
    return height + 41;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FSThread *post = self.objects[indexPath.row];
    FSDetailController *detailsViewController = [[FSDetailController alloc] initWithModel:post];
    [self.navigationController pushViewController:detailsViewController animated:YES];
}







@end
