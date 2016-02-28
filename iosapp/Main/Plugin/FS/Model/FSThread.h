//
//  OSCPost.h
//  iosapp
//
//  Created by chenhaoxiang on 10/27/14.
//  Copyright (c) 2014 oschina. All rights reserved.
//


@interface FSThread : NSObject
/*
@property (nonatomic, assign) int64_t postID;
@property (nonatomic, copy) NSURL *portraitURL;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, assign) int64_t authorID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, assign) int replyCount;
@property (nonatomic, assign) int viewCount;
@property (nonatomic, strong) NSDate *pubDate;
 */


@property (nonatomic,assign)int tid;
@property (nonatomic,assign)int fid;
@property (nonatomic,copy) NSString *subject;

@property (nonatomic,assign)int replies;
@property (nonatomic,assign)int hits;
@property (nonatomic,assign)int like_count;

@property (nonatomic, assign) int64_t created_time;



+ (instancetype)newsModelWithDict:(NSDictionary *)dict;

@end
