//
//  threadsViewController.m
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
#import "FSCategory.h"

static NSString *kthreadCellID = @"FSThreadCell";


@implementation FSThreadViewController

- (instancetype)initWithFSType:(FSType)type
{
    self = [super init];
    
    if (self) {
        self.generateURL = ^NSString * (int page) {
            if(type == FSTypeDate){
                return [NSString stringWithFormat:@"%@%@&page=%d", FSAPI_ARTICLE_PREFIX, FSAPI_ARTICLE_LIST_BY_DATE, page];
            }
            else if(type == FSTypeHot){
                return [NSString stringWithFormat:@"%@%@&page=%d", FSAPI_ARTICLE_PREFIX, FSAPI_ARTICLE_LIST_BY_HOT, page];
            }else{
                return [NSString stringWithFormat:@"%@%@&page=%d", FSAPI_ARTICLE_PREFIX, FSAPI_ARTICLE_LIST_BY_RECOMMEND, page];
            }

        };

    }
    
    return self;
}

- (instancetype)initWithCategory:(int)category
{
    self = [super init];
    
    if (self) {
        self.generateURL = ^NSString * (int page) {
            return [NSString stringWithFormat:@"%@%@%d&page=%d", FSAPI_ARTICLE_PREFIX, FSAPI_ARTICLE_LIST_BY_CATEGORY, category, page];
            
        };
        
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
    for (FSThread *thread in arrayM) {
        thread.contentResume = [self trimContent:thread.contentResume];
    }
    
    return arrayM;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[FSThreadCell class] forCellReuseIdentifier:kthreadCellID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}





#pragma mark -

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSThreadCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kthreadCellID forIndexPath:indexPath];
    FSThread *thread = self.arrayList[indexPath.row];

    
    [cell.portrait loadPortrait:[NSURL URLWithString:thread.avatarImg]];
    [cell.titleLabel setText:thread.subject];
    [cell.bodyLabel setText:thread.contentResume];
    [cell.authorLabel setText:thread.lastpost_username];
    
    //NSString *timeSp = [NSString stringWithFormat:@"%d", thread.created_time];
    [cell.timeLabel setText:thread.lastpost_time];
    
    /*
     // when time value is something like 1283376197
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyyMMddHHMMss"];
    NSDate *date = [formatter dateFromString:@"1283376197"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:thread.created_time];
    NSLog(@"date1:%@",date);
    [cell.timeLabel setText:[confromTimesp timeAgoSinceNow]];
     */
    
    
    [cell.commentAndView setText:[NSString stringWithFormat:@"%d回 / %d阅", thread.replies, thread.hits]];

    
    cell.titleLabel.textColor = [UIColor titleColor];
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor selectCellSColor];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSThread *thread = self.arrayList[indexPath.row];
    
    self.label.font = [UIFont boldSystemFontOfSize:15];
    self.label.text = thread.subject;
    CGFloat height = [self.label sizeThatFits:CGSizeMake(tableView.frame.size.width - 62, MAXFLOAT)].height;
    
    self.label.text = thread.contentResume;
    self.label.font = [UIFont systemFontOfSize:13];
    height += [self.label sizeThatFits:CGSizeMake(tableView.frame.size.width - 62, MAXFLOAT)].height;
    
    return height + 41;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FSThread *thread = self.arrayList[indexPath.row];
    FSDetailController *detailsViewController = [[FSDetailController alloc] initWithModel:thread];
    [self.navigationController pushViewController:detailsViewController animated:YES];
}

-(NSString*)trimContent:(NSString*)content
{
    if(content == NULL || content.length == 0){
        return NULL;
    }
    else{
        NSString *newContent = [content stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        newContent = [newContent stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        
        return newContent;
    }
}





@end
